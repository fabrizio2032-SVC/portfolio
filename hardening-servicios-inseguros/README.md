# Servicios inseguros · detectar, demostrar y corregir

> Laboratorios del módulo *Python y Ciberseguridad* (2º ASIR, Digitech FP). Se hicieron en una **red aislada (host-only)** contra Metasploitable 2, una máquina vulnerable creada a propósito para practicar. El enfoque es **defensivo**: encontrar el riesgo, corregirlo y saber detectarlo.

![Nmap](https://img.shields.io/badge/Nmap-inventario-4682B4)
![Wireshark](https://img.shields.io/badge/Wireshark-análisis-1679A7?logo=wireshark&logoColor=white)
![Hardening](https://img.shields.io/badge/hardening-SSH-3EE08F)

## El reto

Un servidor heredado expone servicios antiguos:

| Puerto | Servicio | Riesgo |
|---|---|---|
| 21/tcp | vsftpd 2.3.4 | Versión con una **backdoor conocida** (CVE-2011-2523) que permite ejecutar comandos sin autenticación |
| 23/tcp | Telnet | Todo viaja **en texto plano**, también el usuario y la contraseña |

Había que demostrar el riesgo a un responsable, aplicar la contramedida y dejar preparado cómo detectarlo en los logs.

## Lo que hice

1. **Inventario:** con `nmap -sV` identifiqué los servicios y sus versiones, y relacioné cada hallazgo con la fase de la **Cyber Kill Chain** y la técnica de **MITRE ATT&CK** correspondiente.
2. **Investigación:** consulté el CVE en la base de MITRE. Esta vulnerabilidad compromete la confidencialidad, la integridad y la disponibilidad, porque da acceso con privilegios de administrador.
3. **Demostración controlada:** comprobé el riesgo con Metasploit **solo dentro del laboratorio aislado**. Con **Wireshark** ("Seguir flujo TCP") capturé las credenciales de Telnet en claro y las comparé con una sesión SSH, en la que solo se ve tráfico cifrado.
4. **Corrección:** desactivé FTP y Telnet y dejé **SSH** como única vía de administración ([scripts/02_desactivar_servicios_inseguros.sh](scripts/02_desactivar_servicios_inseguros.sh)).
5. **Detección:** analicé `auth.log`, `syslog` y los logs de Apache para encontrar el rastro de cada acción (intentos fallidos, usuarios inexistentes, errores 404 y 500) y lo documenté en un informe de incidente con resumen ejecutivo.

## Antes y después

| Puerto | Antes | Después |
|---|---|---|
| 21/tcp | 🔴 abierto · backdoor CVE-2011-2523 | 🟢 cerrado |
| 23/tcp | 🔴 abierto · credenciales en claro | 🟢 cerrado |
| 22/tcp | abierto | 🟢 abierto, cifrado, única vía de administración |

## Estructura

```
hardening-servicios-inseguros/
├── scripts/
│   ├── 01_inventario_servicios.sh          # ss, nmap -sV y comprobación de puertos en claro
│   ├── 02_desactivar_servicios_inseguros.sh # Contramedida: fuera FTP y Telnet
│   └── 03_analizar_logs.sh                 # Rastro en auth.log, syslog y Apache
└── docs/
    ├── informe-incidente-plantilla.md      # Resumen ejecutivo + análisis técnico
    └── capturas/
```

## Lo que aprendí

- **Versión vieja = riesgo**, aunque el servicio "funcione". Un inventario con versiones es el primer paso de cualquier hardening.
- La diferencia entre Telnet y SSH se ve en diez segundos con Wireshark, y eso convence más que cualquier explicación.
- Un sistema sin monitorización de logs es como una tienda sin cámaras: los ataques ocurren y nadie se entera.

## Aviso

Todo se hizo en máquinas virtuales propias, sin conexión con redes de terceros. Este repositorio documenta la **detección y la corrección**, no paso a paso cómo explotar el fallo.

## Autoría

Fabrizio Barrial · 2º ASIR, Digitech FP.
