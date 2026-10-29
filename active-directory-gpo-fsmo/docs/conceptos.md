# Conceptos clave que trabajé en esta práctica

## Orden de aplicación: regla LSDOU
Las directivas se aplican en este orden: **L**ocal, **S**itio, **D**ominio y **OU**. Si dos directivas chocan, gana la que se aplica después, es decir, la más cercana al objeto.

- **Block Inheritance (bloquear herencia):** se configura en una OU. Impide que las directivas de niveles superiores, como el dominio, se apliquen dentro de esa OU.
- **Enforced (forzado):** se configura en una GPO. Tiene prioridad absoluta y atraviesa cualquier bloqueo de herencia de las OU inferiores.

## Por qué las PSO van a grupos y no a OU
Las OU son contenedores lógicos: no son principales de seguridad y no tienen SID. Los usuarios y los grupos de seguridad globales sí tienen SID y token de acceso.
Aplicar una PSO a un grupo es el único método soportado y además da flexibilidad: dentro de una misma OU puede haber usuarios con políticas de contraseña distintas, por ejemplo claves más largas para el equipo de sistemas.

## Restauración autoritativa y no autoritativa
- **No autoritativa (por defecto):** el DC restaurado arranca con datos antiguos y se pone al día replicando los cambios de los demás DC.
- **Autoritativa:** se usa, por ejemplo, tras borrar por error una OU que ya se ha replicado. Los objetos restaurados se marcan como autoritativos (se incrementa su USN) y los demás DC aceptan esa versión como la buena.

## Fuentes
- Microsoft Learn: procesamiento y herencia de directivas de grupo.
- Microsoft Learn: directivas de contraseña específicas en AD DS y cmdlet `New-ADFineGrainedPasswordPolicy`.
- Microsoft Learn: `gpresult` y destinatarios de nivel de elemento en las preferencias de directiva.
