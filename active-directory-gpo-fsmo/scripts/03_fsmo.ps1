# 03_fsmo.ps1 · Consulta y movimiento de los roles FSMO
Import-Module ActiveDirectory

# ¿Quién tiene cada rol?
netdom query fsmo
Get-ADDomain | Select-Object PDCEmulator, RIDMaster, InfrastructureMaster
Get-ADForest | Select-Object SchemaMaster, DomainNamingMaster

# Transferencia controlada (los dos DC se ven en la red):
Move-ADDirectoryServerOperationMasterRole -Identity "DC-SECUNDARI" `
  -OperationMasterRole PDCEmulator, RIDMaster, InfrastructureMaster, SchemaMaster, DomainNamingMaster

# Emergencia: el DC original ha caído y no volverá. Se CONFISCAN (seize) añadiendo -Force.
# Un DC al que se le han confiscado los roles no debe volver a conectarse a la red.
# Move-ADDirectoryServerOperationMasterRole -Identity "DC-SECUNDARI" -OperationMasterRole ... -Force
