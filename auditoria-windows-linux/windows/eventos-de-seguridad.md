# Eventos de seguridad usados en la práctica (Visor de eventos › Seguridad)

| ID | Qué indica | Cómo lo generé |
|---|---|---|
| 4624 | Inicio de sesión correcto | Entrar con un usuario del dominio |
| 4625 | Error de inicio de sesión | Escribir mal la contraseña |
| 4740 | Cuenta bloqueada | Dos intentos fallidos seguidos |
| 4767 | Cuenta desbloqueada | Desbloqueo por el administrador |
| 4720 | Cuenta de usuario creada | Alta de un usuario de prueba |
| 4726 | Cuenta de usuario eliminada | Baja del usuario de prueba |
| 4663 | Intento de acceso a un objeto | Abrir el fichero auditado `topsecurity.txt` |

## Configuración en la Default Domain Policy
- **Directiva de bloqueo de cuenta:** umbral de 2 intentos y duración 0 (solo el administrador desbloquea).
- **Auditoría:** inicio de sesión, administración de cuentas y acceso a objetos, en correcto y en error.
- **Fichero auditado:** `C:\Auditoria\topsecurity.txt` › Propiedades › Seguridad › Opciones avanzadas › Auditoría, para *Domain Users* en correcto y en error.
- Aplicar con `gpupdate /force`.

## Filtro rápido en PowerShell
```powershell
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625,4740,4767} -MaxEvents 20 |
  Select-Object TimeCreated, Id, Message
```
