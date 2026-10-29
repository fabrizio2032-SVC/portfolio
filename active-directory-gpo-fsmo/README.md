# Active Directory · GPO, PSO, roles FSMO y copias del dominio

> Prácticas del módulo 0374 *Administración de sistemas operativos* (2º ASIR, Digitech FP). Dominio de laboratorio `techcorp.local` sobre Windows Server, con un cliente Windows (`CL-STATION01`).

![Windows Server](https://img.shields.io/badge/Windows_Server-AD_DS-0078D4?logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-ActiveDirectory-5391FE?logo=powershell&logoColor=white)

## El reto

Administrar un dominio como en una empresa real:

1. Aplicar restricciones a las estaciones de trabajo **sin afectar al equipo de sistemas**.
2. Exigir **contraseñas más estrictas solo a un grupo**.
3. Repartir **unidades de red** y bloquear la sesión de forma automática.
4. Tener un plan para cuando **cae un controlador de dominio** o alguien borra un objeto por error.

## La solución

### 1. GPO de restricciones con filtrado de seguridad
- GPO `GPO_Restriccions_Estacions`, vinculada a `TechCorp › Departamentos`.
- **Usuario:** acceso prohibido al Panel de control y a Configuración.
- **Equipo:** "Todas las clases de almacenamiento extraíble: denegar acceso a todo".
- **Exclusión:** el grupo `GG_Sistemes` tiene **Denegar** en "Aplicar directiva de grupo" (pestaña Delegación › Opciones avanzadas). La denegación prevalece sobre cualquier permiso.

### 2. Política de contraseñas detallada (PSO)
- Creada con `New-ADFineGrainedPasswordPolicy` y asignada a `GG_Sistemes` con `Add-ADFineGrainedPasswordPolicySubject`.
- Verificada sobre un usuario del grupo con `Get-ADUserResultantPasswordPolicy`.
- Por qué va a un grupo y no a una OU: [docs/conceptos.md](docs/conceptos.md).

### 3. Unidades de red y seguridad de sesión
- Preferencias › Asignaciones de unidades: **S:** y **T:** a `\\DC-TECHCORP\Compartido`. La unidad T: usa **destinatarios de nivel de elemento** para mostrarse solo al grupo `GG_Sistemes`.
- Protector de pantalla obligatorio, con contraseña y **600 segundos** de espera.
- Comprobado en el cliente con `gpupdate /force` y un informe `gpresult /h`.

### 4. Mantenimiento del dominio
- Consulta y **transferencia de los roles FSMO** con `Move-ADDirectoryServerOperationMasterRole`, y procedimiento de **confiscación (seize)** si el DC original no vuelve.
- **Auditoría** del servicio de directorio y seguimiento de eventos.
- **Papelera de reciclaje de AD** activada y restauración de un objeto borrado.
- **Copia del estado del sistema** con `wbadmin` y diferencia entre restauración autoritativa y no autoritativa.
- Salud del dominio con `dcdiag` (NTDS, KDC, NETLOGON, DFSR…).

## Estructura

```
active-directory-gpo-fsmo/
├── scripts/
│   ├── 01_gpo_restricciones.ps1    # Crear y vincular la GPO
│   ├── 02_pso_gg_sistemes.ps1      # PSO para GG_Sistemes
│   ├── 03_fsmo.ps1                 # Consultar, transferir o confiscar roles
│   ├── 04_papelera_y_backup.ps1    # Papelera de AD y estado del sistema
│   └── 05_diagnostico.ps1          # dcdiag, repadmin y gpresult
└── docs/
    ├── conceptos.md                # LSDOU, herencia, PSO, tipos de restauración
    └── capturas/
```

## Verificación

| Prueba | Resultado |
|---|---|
| Usuario de `OU_Desarrollo` intenta abrir el Panel de control | Bloqueado por directiva ✅ |
| Usuario de `GG_Sistemes` en la misma estación | Sin restricciones ✅ |
| `Get-ADUserResultantPasswordPolicy` sobre un usuario de sistemas | Devuelve la PSO ✅ |
| Inicio de sesión en `CL-STATION01` | Unidades S: (y T: para sistemas) montadas ✅ |
| `gpresult /h` | Informe con las GPO aplicadas ✅ |

## Lo que aprendí

- Las GPO no se "ponen" a un usuario: se vinculan a contenedores y se filtran con permisos. Un **Denegar** bien puesto evita crear OU solo para excepciones.
- La regla **LSDOU** explica casi todos los "¿por qué no se aplica mi GPO?".
- Antes de confiscar un rol FSMO hay que estar seguro de que el DC original no volverá, porque si vuelve habrá dos maestros.

## Autoría

Fabrizio Barrial · 2º ASIR, Digitech FP. Dominio y usuarios de laboratorio, todos ficticios.
