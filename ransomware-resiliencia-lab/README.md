<p align="center"><img src="docs/img/banner.svg" alt="Resiliencia frente a ransomware" width="100%"></p>

<p align="center">
  <img src="https://img.shields.io/badge/estado-en_curso-F2B33D" alt="En curso">
  <img src="https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white" alt="Docker Compose">
  <img src="https://img.shields.io/badge/restic-append--only-3EE08F" alt="restic">
  <img src="https://img.shields.io/badge/n8n-workflows-EA4B71" alt="n8n">
  <img src="https://img.shields.io/badge/Grafana-paneles-F46800?logo=grafana&logoColor=white" alt="Grafana">
  <img src="https://img.shields.io/badge/WireGuard-VPN-88171A?logo=wireguard&logoColor=white" alt="WireGuard">
</p>

Proyecto intermodular de 2º de ASIR (Digitech FP), en equipo de tres. Parte de un caso real de octubre de 2026: un colegio profesional con los servidores cifrados por ransomware. Diseñamos y validamos en un laboratorio virtualizado un sistema que permite **recuperarse aunque el atacante llegue a ser administrador del dominio**.

## Índice
- [El reto](#el-reto)
- [Arquitectura](#arquitectura)
- [Flujo ante un ataque](#flujo-ante-un-ataque)
- [Despliegue paso a paso](#despliegue-paso-a-paso)
- [Verificación](#verificación)
- [Riesgos y medidas](#riesgos-y-medidas)
- [Estructura del repositorio](#estructura-del-repositorio)

## El reto

El acceso inicial de un atacante nunca se puede descartar del todo. El proyecto se centra en **la capacidad de recuperarse**:

| Objetivo | Medida |
|---|---|
| Copias que el atacante no pueda borrar ni cifrar | Bóveda aislada con `rest-server --append-only`, snapshots y copia offline (3-2-1-1-0) |
| Detectar un cifrado masivo en menos de 5 minutos | Ficheros canario + control del tamaño de las copias |
| Responder sin depender de una persona | n8n registra, clasifica, avisa y lanza la restauración |
| Recuperar en un tiempo pactado | **RTO 4 h** y **RPO 24 h**, medidos en cada ensayo |

## Arquitectura

```mermaid
flowchart TB
    subgraph CORP["Red corporativa 198.51.100.0/24 · coal.lab"]
        DC["<b>srv-dc01</b><br/>Windows Server 2022<br/>AD DS · DNS · GPO"]
        DOCS["<b>srv-docs01</b><br/>Ubuntu + Samba<br/>expedientes · canarios"]
        SVC["<b>srv-svc01</b> · Docker<br/>Nginx · n8n · PostgreSQL · Grafana<br/>WireGuard · Squid · Fail2ban"]
        CLI["<b>cli-win01</b><br/>cliente de pruebas"]
    end
    subgraph VAULT["Red aislada 203.0.113.0/24 · sin puerta de enlace"]
        BOV["<b>srv-vault01</b><br/>rest-server append-only<br/>snapshots btrfs"]
    end
    ADM["Administrador"] -- "VPN WireGuard 192.0.2.0/24" --> SVC
    DOCS -- "restic backup diario" --> BOV
    DC -- "estado del sistema + SYSVOL" --> BOV
    DOCS -- "webhook: canario tocado" --> SVC
    SVC -- "restic restore por SSH" --> DOCS
    BOV --> USB[("Copia offline<br/>USB rotatorio")]
    CLI --> DOCS
```

**Principio de diseño:** ninguna cuenta del dominio, ni siquiera la de administrador, puede borrar las copias. Se combinan cinco capas: modo append-only, credenciales de restic independientes del dominio, cortafuegos que solo acepta tres orígenes, snapshots en solo lectura y una copia offline.

### Pila de contenedores

```mermaid
flowchart LR
    U["Personal"] -->|":8080 formulario"| NGINX[nginx]
    NGINX -->|"/enviar → webhook"| N8N[n8n]
    N8N --> PG[(PostgreSQL)]
    GRAF[Grafana] -->|"rol grafana_ro"| PG
    subgraph app_net
        NGINX
        N8N
        GRAF
    end
    subgraph data_net["data_net (internal: true)"]
        PG
    end
```

## Flujo ante un ataque

```mermaid
sequenceDiagram
    participant C as canario.sh (srv-docs01)
    participant N as n8n (srv-svc01)
    participant DB as PostgreSQL
    participant V as srv-vault01
    C->>N: webhook {tipo: canario, fichero, huella}
    N->>DB: INSERT incidente (huella única, sin duplicados)
    N->>N: clasifica gravedad N1 y avisa al equipo
    N->>V: restic restore del último snapshot verificado
    V-->>N: datos restaurados en un destino limpio
    N->>DB: restauración EXITOSA (o rollback por Error Trigger)
```

## Despliegue paso a paso

**1. Máquinas virtuales.** Crea `srv-dc01` (Windows Server 2022, 2 vCPU y 4 GB), `srv-docs01` (Ubuntu 24.04, 2 GB), `srv-svc01` (Ubuntu 24.04, 4 vCPU y 8 GB) y `srv-vault01` (Ubuntu 24.04 con disco btrfs) en tres redes virtuales: corporativa, bóveda sin gateway y NAT solo para `srv-svc01`.

**2. Dominio y ficheros.** Promociona `srv-dc01` a un bosque nuevo `coal.lab`, une `srv-docs01` con `realm join coal.lab` y aplica [`samba/smb.conf.extracto`](samba/smb.conf.extracto) (SMB3, sin acceso anónimo).

**3. Bóveda de copias** (en `srv-vault01`):
```bash
sudo bash boveda/preparar_boveda.sh   # rest-server, una credencial por cliente y ufw con 3 orígenes
```

**4. Primera copia** (en `srv-docs01`):
```bash
sudo install -m 600 /dev/stdin /root/.restic_pass <<< "$(openssl rand -base64 32)"
read -rsp "Credencial de srv-docs01 en la bóveda: " RESTIC_HTTP_PASS && export RESTIC_HTTP_PASS
sudo -E restic -r "rest:http://srv-docs01:${RESTIC_HTTP_PASS}@srv-vault01:8000/srv-docs01" \
     --password-file /root/.restic_pass init
sudo -E bash scripts/backup_restic.sh # backup diario + restic check
```

**5. Pila de servicios** (en `srv-svc01`):
```bash
sudo cp -r . /opt/resiliencia && cd /opt/resiliencia
bash scripts/generar_secretos.sh      # crea .env (600) con contraseñas aleatorias
docker compose up -d && docker compose ps
```

**6. Perímetro:**
```bash
sudo bash wireguard/generar_wg0.sh admin1                  # claves y configuración de la VPN
sudo cp squid/squid.conf squid/*.txt /etc/squid/ && sudo systemctl restart squid
sudo cp fail2ban/jail.local /etc/fail2ban/ && sudo systemctl restart fail2ban
```

**7. Detección** (en `srv-docs01`):
```bash
sudo apt install -y inotify-tools curl
sudo mkdir -p /srv/expedientes/_canario && sudo cp docs/senuelos/* /srv/expedientes/_canario/
sudo install -m 755 scripts/canario.sh /usr/local/bin/canario.sh
sudo install -m 644 scripts/canario.service /etc/systemd/system/ && sudo systemctl enable --now canario
```

**8. Paneles.** En Grafana, añade PostgreSQL como fuente de datos con el rol `grafana_ro` y crea el panel de estado con [`grafana/estado_copias.sql`](grafana/estado_copias.sql). El umbral rojo salta a partir de 26 h sin copia.

## Verificación

**Pila de servicios levantada**

<img src="docs/img/pila.svg" alt="docker compose ps" width="100%">

**Las copias existen, no se pueden borrar y están íntegras**

<img src="docs/img/boveda.svg" alt="restic snapshots, intento de borrado y restic check" width="100%">

**Un canario modificado abre un incidente en segundos**

<img src="docs/img/canario.svg" alt="journalctl del canario e incidente en PostgreSQL" width="100%">

| Prueba | Resultado esperado | Estado |
|---|---|:-:|
| `docker compose ps` | 4 servicios *Up*; PostgreSQL solo en `data_net` | ✅ |
| `restic forget` desde un cliente | `403 Forbidden` (append-only) | ✅ |
| `restic check --read-data-subset=5%` | `no errors were found` | ✅ |
| Modificar un fichero canario | Webhook a n8n e incidente N1 en < 5 min | ✅ |
| Ensayo de restauración completo | Dentro del RTO de 4 h | 🔄 en curso |

> Las capturas de consola están reproducidas en SVG a partir de las pruebas del laboratorio.

## Riesgos y medidas

| Riesgo | Probabilidad | Impacto | Medida |
|---|:-:|:-:|---|
| Fallos de webhooks al pasar a producción | Alta | Alto | Validar URLs y variables en un entorno de pruebas |
| Copias corruptas sin detectar | Media | Alto | `restic check` periódico y ensayo semanal |
| Falsos positivos de los canarios | Alta | Bajo | Ventanas de mantenimiento y lista de procesos permitidos |

## Estructura del repositorio

```
ransomware-resiliencia-lab/
├── docker-compose.yml         Pila de srv-svc01 con versiones fijadas
├── initdb/
│   ├── 01_schema.sql          sistemas, copias, incidentes, restauraciones y logs
│   └── 02_roles.sh            Roles de n8n y Grafana con mínimo privilegio
├── nginx/default.conf         Formulario con limitación de peticiones y cabeceras seguras
├── web/index.html             Formulario de incidencias para el personal
├── boveda/                    rest-server append-only, credenciales y cortafuegos
├── scripts/
│   ├── generar_secretos.sh    .env con contraseñas aleatorias
│   ├── backup_restic.sh       Copia diaria y verificación de integridad
│   ├── canario.sh             Ficheros señuelo → webhook a n8n
│   └── canario.service        Unidad de systemd del vigilante
├── wireguard/generar_wg0.sh   Claves y configuración de la VPN
├── squid/ · fail2ban/ · samba/
├── grafana/estado_copias.sql  Panel de estado de copias
└── docs/
    ├── memoria-proyecto.md    Viabilidad, presupuesto, riesgos y manuales
    ├── senuelos/              Ficheros canario de ejemplo
    └── img/
```

Los secretos (contraseñas, claves de WireGuard, `N8N_KEY`) **se generan en el propio servidor** y nunca se suben. Las direcciones usan rangos de documentación RFC 5737.

## Lo que estoy aprendiendo

- Una copia al alcance del administrador del dominio **no protege** contra ransomware: lo que marca la diferencia es separar las credenciales y la red.
- Automatizar la respuesta con n8n reduce el tiempo entre la detección y la restauración.
- Medir el RTO y el RPO convierte un "creo que funciona" en una prueba demostrable.

---
**Autoría:** Fabrizio Barrial y dos compañeros de 2º de ASIR en Digitech FP. Todos los datos del laboratorio son ficticios. · [Portfolio](https://fabrizio2032-svc.github.io/portfolio/)
