# Informe de incidente · LAB-2026-007

## Resumen ejecutivo
Durante el laboratorio se detectaron en el servidor `metasploitable` **187 intentos de contraseña fallidos por SSH** desde un mismo origen (`kali-lab`), seguidos de **un acceso correcto**. Esto indica un ataque de fuerza bruta que consiguió entrar. Además, el servidor exponía dos servicios inseguros (FTP vsftpd 2.3.4 con backdoor y Telnet en claro).
Se cortó el acceso, se cambió la contraseña afectada y se desactivaron FTP y Telnet. No hay constancia de datos extraídos.

## Clasificación
| Campo | Valor |
|---|---|
| Tipo (taxonomía INCIBE-CERT) | Intrusión · compromiso de cuenta sin privilegios |
| Severidad | **SEV-2 Alta** |
| Activo afectado | `metasploitable` (servidor de laboratorio) |
| Vector | Credenciales débiles + servicio SSH accesible |
| Detectado | 28/10 a las 11:20, revisando `auth.log` |

## Cronología
| Hora | Evento | Fuente |
|---|---|---|
| 11:05:41 | Primer `Invalid user oracle from kali-lab` | `/var/log/auth.log` |
| 11:05–11:07 | 187 × `Failed password` desde `kali-lab` | `/var/log/auth.log` |
| 11:07:02 | `Accepted password for user from kali-lab` | `/var/log/auth.log` |
| 11:08–11:15 | 1.342 respuestas 404 en Apache (enumeración de directorios) | `/var/log/apache2/access.log` |
| 11:20 | Detección durante la revisión de logs | Analista |
| 11:25 | Contención: sesión cerrada, contraseña cambiada | Analista |

## Análisis técnico
- **Preservación:** antes de tocar nada se copiaron `auth.log`, `syslog` y los logs de Apache, siguiendo el orden de volatilidad (primero conexiones activas con `ss -tnp`, luego los ficheros).
- **Indicadores:** un único origen, intentos cada menos de un segundo, usuarios de diccionario (`oracle`, `test`) y un éxito final.
- **Superficie expuesta:** `nmap -sV` mostró 21/tcp (vsftpd 2.3.4, CVE-2011-2523) y 23/tcp (Telnet) abiertos.

## Contención, erradicación y recuperación
1. Cierre de la sesión abierta y cambio de la contraseña del usuario comprometido.
2. Desactivación de vsftpd y Telnet (`scripts/02_desactivar_servicios_inseguros.sh`).
3. Comprobación posterior con `nmap -sV`: solo el 22/tcp queda abierto.

## Lecciones aprendidas y medidas preventivas
- Autenticación SSH por **clave** y `PasswordAuthentication no`.
- **Fail2ban** para bloquear un origen tras pocos fallos.
- Revisión periódica de logs, o un SIEM que alerte sin depender de una revisión manual.
- Inventario de servicios con versiones tras cada cambio en el servidor.
