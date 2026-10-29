# 04_papelera_y_backup.ps1 · Papelera de reciclaje de AD y copia del estado del sistema
Import-Module ActiveDirectory

# Papelera de reciclaje (irreversible una vez activada)
Enable-ADOptionalFeature -Identity "Recycle Bin Feature" `
  -Scope ForestOrConfigurationSet -Target "techcorp.local" -Confirm:$false

# Recuperar un objeto borrado
Get-ADObject -Filter 'isDeleted -eq $true -and Name -like "*mlopez*"' -IncludeDeletedObjects |
  Restore-ADObject

# Copia del estado del sistema (incluye la base NTDS y SYSVOL). Requiere la característica Windows Server Backup.
Install-WindowsFeature Windows-Server-Backup
wbadmin start systemstatebackup -backupTarget:E: -quiet
