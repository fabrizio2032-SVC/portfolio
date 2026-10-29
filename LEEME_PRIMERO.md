# Repositorios para tu GitHub · fabrizio2032-SVC

Cada carpeta de este ZIP es **un repositorio**. El nombre de la carpeta es el nombre exacto que debe tener en GitHub, porque el portfolio ya enlaza a esas URL (`https://github.com/fabrizio2032-SVC/<carpeta>`).

## 1. Qué subir y en qué orden

| Prioridad | Repositorio | Por qué |
|---|---|---|
| 1 | `fabrizio2032-SVC` | Es tu **README de perfil**: aparece en la portada de tu GitHub. Tiene que llamarse igual que tu usuario. |
| 1 | `portfolio` | Tu web. Activa GitHub Pages con tu dominio `.es` (instrucciones en su README). |
| 1 | `glacianova-samba-ad` ⭐ | Tu mejor proyecto de sistemas: Samba AD, RAID 1, DHCP, CUPS, Nagios y backups probados. |
| 1 | `ransomware-resiliencia-lab` | El más completo técnicamente: Docker, restic append-only, n8n, Grafana y VPN. |
| 2 | `active-directory-gpo-fsmo` | Windows Server: lo más pedido en ofertas de FCT de sistemas. |
| 2 | `lvm-snapshots-dokuwiki` | Incluye un problema real que resolviste, algo que un reclutador valora mucho. |
| 2 | `auditoria-windows-linux` | Auditoría en los dos sistemas. |
| 2 | `hardening-servicios-inseguros` | Seguridad con enfoque defensivo: detectar, corregir y analizar logs. |
| 3 | `soc-escolar` | Tu informe completo de clasificación de amenazas. |
| 3 | `clinica-veterinaria-lamp` | Windows Server más una web PHP/MySQL, con mejoras de seguridad explicadas. |
| 3 | `nexatech-lan-packet-tracer` | Redes. **Súbelo cuando añadas tu archivo `.pkt`**; sin él queda flojo. |

**Ya tienes otro repositorio** en la cuenta `Fabrizio277` (`python_y_cyberseguridad`, con el Cifrado César y otros ejercicios de Python). Muévelo a esta cuenta desde *Settings › Danger Zone › Transfer ownership* para tenerlo todo en un único perfil.

## 2. Qué NO subir a GitHub

- **Enunciados, guías y rúbricas de los profesores** (por ejemplo las guías `M0370_…_Alumnat`): no son tuyos.
- **Exámenes** y actividades corregidas.
- Trabajos que no son de sistemas: FOL y Seguridad Social, convenios, nóminas, inglés, sostenibilidad, digitalización o IPO. No suman para una FCT de ASIR.
- **Documentos personales**: certificados de estudios, carta de presentación o tu CV con el teléfono (en el portfolio decides tú si lo publicas).
- Cualquier documento con **IPs reales, contraseñas o nombres de compañeros sin su permiso**. En tus memorias originales aparecen contraseñas de usuarios de prueba y nombres de compañeros: en estos repositorios ya están quitados.
- Un documento de broma con el nombre de un compañero en el título que había en el ZIP.

## 3. Antes de subir: revisa esto

**Qué es tuyo y qué he reconstruido.** La mayor parte sale literal de tus memorias: configuraciones de COAL, `dhcpd.conf`, `smb.conf`, `sshd`, comandos de LVM y de Active Directory, las páginas de la web, el informe del SOC… Algunos ficheros los escribí yo a partir de lo que describen tus documentos, y tienes que **probarlos y ajustarlos**, porque te pueden preguntar por ellos en una entrevista:

| Repositorio | Fichero | Qué revisar |
|---|---|---|
| glacianova | `scripts/backup_completo.sh`, `prueba_restauracion.sh`, `crear_estructura_ad.sh` | Probados aquí con datos de prueba. Compáralos con tu script real y usa el tuyo si es distinto. |
| ransomware | `scripts/canario.sh`, `boveda/preparar_boveda.sh`, `web/index.html` | La memoria describe el servicio inotify y el manual, pero no trae el script. |
| active-directory | `02_pso_gg_sistemes.ps1` | Los **valores** de la PSO son de ejemplo: pon los de tu práctica. |
| auditoria | `linux/audit.rules` | La ruta `/srv/confidencial/` es supuesta: pon la que usaste. |
| hardening | `scripts/*.sh` | Scripts de comprobación y corrección escritos para el repositorio. |
| veterinaria | `web/estilos.css` | Es una recreación. **Sustitúyela por tu `estilos.css` original.** |
| veterinaria | `web/registro.php` | Es tu código **con tres mejoras de seguridad** (explicadas en el README). Entiéndelas bien, son un buen tema de entrevista. |

**Añade capturas.** Cada repositorio tiene `docs/capturas/`. Dos o tres capturas por proyecto bastan (RAID con `[UU]`, el "Acceso denegado", el panel de Nagios…). **Tapa las IPs** antes de subirlas.

**Compañeros.** En los proyectos de grupo aparece "y X compañeros". Si te dan permiso, pon sus nombres o sus usuarios de GitHub en la sección *Autoría*.

**Pasa el comprobador** (busca IPs, contraseñas, claves y teléfonos):
```bash
bash _herramientas/comprobar_antes_de_subir.sh .
```
```powershell
powershell -ExecutionPolicy Bypass -File .\_herramientas\comprobar_antes_de_subir.ps1 -Ruta .
```

## 4. Cómo subirlo

### Opción A · Desde la web (sin instalar nada)
1. En GitHub, **New repository** → nombre igual que la carpeta → *Public* → sin README → **Create**.
2. *uploading an existing file* → arrastra **el contenido** de la carpeta (no la carpeta entera) → **Commit changes**.
3. Repite con cada carpeta.

### Opción B · Todo de golpe con GitHub CLI
```bash
# 1) Instala Git y GitHub CLI (en Windows: winget install Git.Git GitHub.cli)
gh auth login
# 2) Desde la carpeta descomprimida:
bash _herramientas/subir_con_gh.sh                                        # Linux / macOS / Git Bash
powershell -ExecutionPolicy Bypass -File .\_herramientas\subir_con_gh.ps1 # Windows
```
El script pasa el comprobador, crea cada repositorio como público, sube el contenido e intenta activar GitHub Pages en `portfolio`.

## 5. Después de subir
- En tu perfil, **Customize your pins** → fija `glacianova-samba-ad`, `ransomware-resiliencia-lab`, `active-directory-gpo-fsmo`, `lvm-snapshots-dokuwiki`, `hardening-servicios-inseguros` y `portfolio`.
- Añade a cada repositorio sus **topics** (por ejemplo `asir`, `samba`, `active-directory`, `sysadmin`, `homelab`), en el engranaje de *About*.
- Cambia `TU_DOMINIO.es` por tu dominio en `fabrizio2032-SVC/README.md`, `portfolio/README.md` y `portfolio/index.html`.
