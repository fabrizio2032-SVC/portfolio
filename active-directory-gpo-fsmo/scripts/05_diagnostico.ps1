# 05_diagnostico.ps1 · Salud del dominio e informe de directivas
dcdiag /v                       # NTDS, DnsCache, DFSR, KDC, w32time, NETLOGON...
repadmin /replsummary           # estado de la replicación entre DC

# En el cliente CL-STATION01, con el usuario de OU_Desarrollo:
gpupdate /force
gpresult /h C:\informe_gpo.html /f
