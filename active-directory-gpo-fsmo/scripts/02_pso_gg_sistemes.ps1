# 02_pso_gg_sistemes.ps1 · Política de contraseñas detallada (Fine-Grained Password Policy)
# Las PSO se aplican a grupos o usuarios, nunca a OU: las OU no son principales de seguridad (no tienen SID).
Import-Module ActiveDirectory

# Valores de ejemplo: sustitúyelos por los que configuraste en tu práctica.
New-ADFineGrainedPasswordPolicy -Name "PSO_GG_Sistemes" `
  -Precedence 1 `
  -MinPasswordLength 12 `
  -ComplexityEnabled $true `
  -PasswordHistoryCount 24 `
  -MaxPasswordAge "30.00:00:00" `
  -MinPasswordAge "1.00:00:00" `
  -LockoutThreshold 3 `
  -LockoutDuration "00:30:00" `
  -LockoutObservationWindow "00:30:00" `
  -ReversibleEncryptionEnabled $false

Add-ADFineGrainedPasswordPolicySubject -Identity "PSO_GG_Sistemes" -Subjects "GG_Sistemes"

# Comprobación sobre un usuario del grupo
Get-ADUserResultantPasswordPolicy -Identity "u_sistemes1"
