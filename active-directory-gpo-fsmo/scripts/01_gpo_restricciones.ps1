# 01_gpo_restricciones.ps1 · DC de techcorp.local
# Crea la GPO de restricciones y la vincula a la OU de departamentos.
# Las directivas concretas se editaron en gpmc.msc (ver README):
#   - Usuario > Plantillas administrativas > Panel de control: prohibir el acceso al Panel de control y a Configuración
#   - Equipo  > Plantillas administrativas > Sistema > Acceso a almacenamiento extraíble: denegar todo
Import-Module GroupPolicy

$Gpo = "GPO_Restriccions_Estacions"
$Ou  = "OU=Departamentos,OU=TechCorp,DC=techcorp,DC=local"   # ajusta a tu estructura

New-GPO -Name $Gpo -Comment "Restricciones de estaciones de trabajo" | Out-Null
New-GPLink -Name $Gpo -Target $Ou -LinkEnabled Yes

# Exclusión de GG_Sistemes: en la pestaña Delegación > Opciones avanzadas se añade el grupo
# y se marca DENEGAR en "Aplicar directiva de grupo". La denegación tiene prioridad sobre el permiso.
Get-GPPermission -Name $Gpo -All | Format-Table Trustee, Permission, Denied -AutoSize
