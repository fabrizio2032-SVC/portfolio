# Infraestructura Windows Server · Patitas Felices

## Especificaciones
| Elemento | Elección | Motivo |
|---|---|---|
| Servidor | Windows Server 2022 con Experiencia de escritorio | Plataforma estable y compatible con software de gestión clínica |
| Clientes | Windows 11 Pro | Pueden unirse al dominio |
| Administración | RSAT | Todo el equipo administraba el mismo servidor de forma remota |
| Red | Adaptador puente en VirtualBox | |
| Discos | 2 × 100 GB en **RAID 1** (espejo), creado con PowerShell antes de instalar | Si un disco muere, la clínica sigue funcionando |

> El RAID **no sustituye** a las copias de seguridad: protege del fallo de un disco, no de un borrado o de un ransomware. Por eso se propone además una política de copias 3-2-1.

## Directorio activo: `ad.vetpf.com`
Bosque y dominio únicos, porque la clínica tiene una sola sede. UO por departamento, ya que las necesidades de acceso son más homogéneas dentro de cada departamento:

```
ad.vetpf.com
├── UO_Administracion
├── UO_Clinica
│   ├── UO_Enfermeria
│   └── UO_Veterinarios
├── UO_Direccion
├── UO_Equipos
├── UO_Mantenimiento
└── UO_Recepcion
```

- **Grupos** por departamento para asignar permisos. Las UO organizan y reciben GPO; los grupos dan acceso a recursos.
- **Nomenclatura de usuarios:** `Nombre Apellido1`, o el nombre del rol para cuentas de servicio.
- **Contraseñas:** contraseña temporal para el alta, con cambio obligatorio en el primer inicio de sesión, y directiva de complejidad (longitud mínima, mayúscula, número y carácter especial).

## Recursos compartidos
- Carpetas: Clientes, Pacientes, Historial clínico, Facturaciones, Proveedores, Administración y **Común**.
- Cada carpeta solo es accesible por los grupos que la necesitan. En *Común* todos pueden escribir, pero con **CREATOR OWNER** cada usuario solo modifica lo que ha creado.
- Impresoras compartidas con permiso por grupo: `Impresora_Recepción` (solo Recepción) e `Impresora_Administración`.

## Servidor web (Ubuntu, fuera del dominio)
El servidor LAMP no se unió al dominio Windows. Estaban en redes distintas, unirlo obligaba a usar el DNS del dominio (y perder la resolución de Internet) y cada validación habría añadido latencia. Manteniendo la base de datos local, la web sigue aceptando citas aunque caiga la conexión con el servidor Windows.

- **Sistemas** modifica la web por **SFTP**.
- **Recepción** solo consulta las citas con un usuario de MySQL con `GRANT SELECT`.
