**MEMORIA TECNICA**

**Proyecto de Infraestructura de Servidor**

GlaciaNova Distribucion S.L.

|                                |                              |
|--------------------------------|------------------------------|
| **Referencia del proyecto**    | PRY-GLACIANOVA-2026-001      |
| **Cliente**                    | GlaciaNova Distribucion S.L. |
| **Empresa implementadora**     | NorthByte IT Services        |
| **Responsable tecnico**        | Departamento de Sistemas     |
| **Dominio Active Directory**   | glacianova.local             |
| **Rango de red**               | <RED_LAN>/24              |
| **Servidor principal**         | srv-ice01 - <IP_SRV_ICE01>    |
| **Sistema operativo servidor** | Ubuntu Server 24.04 LTS      |
| **Cliente Windows**            | win-ice01 - IP dinamica DHCP |
| **Version del documento**      | 1.0                          |
| **Fecha de elaboracion**       | Marzo 2026                   |
| **Estado**                     | Implementacion completada    |

## 1. INTRODUCCION Y DESCRIPCION DEL PROYECTO
### 1.1 Descripcion general
El presente documento constituye la memoria tecnica del Proyecto 1 de implementacion de infraestructura de servidor para GlaciaNova Distribucion S.L., empresa del sector de distribucion de productos de helado. El proyecto ha sido desarrollado e implementado por NorthByte IT Services con el objetivo de proporcionar al cliente una solucion de tecnologia de la informacion robusta, segura, escalable y centralizada.

La infraestructura implementada se basa en un servidor Ubuntu Server 24.04 LTS configurado como controlador de dominio Active Directory mediante Samba 4, proveyendo servicios de autenticacion centralizada, almacenamiento de archivos compartidos con control de acceso granular, servidor de impresion, monitorizacion de red y acceso remoto seguro.

### 1.2 Objetivos del proyecto
- Implementar un dominio Active Directory en Ubuntu Server 24.04 LTS con Samba para la gestion centralizada de usuarios, equipos y politicas.

- Configurar un sistema de almacenamiento redundante mediante RAID 1 por software con separacion logica de datos operativos y copias de seguridad.

- Crear una estructura organizativa del directorio mediante Unidades Organizativas y Grupos de Seguridad por departamento.

- Integrar clientes Windows 10 Pro en el dominio con acceso a recursos compartidos segun permisos por grupo.

- Implementar un servidor de impresion centralizado accesible para todos los clientes del dominio.

- Configurar acceso remoto seguro mediante SSH restringido al grupo de administradores IT.

- Desplegar un sistema de monitorizacion de red y servicios con alertas automaticas.

- Establecer una politica de copias de seguridad automatizada con procedimiento de restauracion verificado.

### 1.3 Alcance del proyecto
El alcance de este proyecto comprende la totalidad de la infraestructura de servidor de GlaciaNova Distribucion S.L., incluyendo la configuracion del hardware del servidor, el sistema operativo, todos los servicios de red y directorio, la integracion de los equipos cliente y la puesta en marcha de los sistemas de monitorizacion y backup. Queda fuera del alcance la administracion continua del sistema tras la entrega, la cual pasara a ser responsabilidad del departamento IT del cliente o de un contrato de mantenimiento separado.

## 2. DESCRIPCION DE LA INFRAESTRUCTURA
### 2.1 Arquitectura general del sistema
La infraestructura se organiza en torno a un servidor central que actua como punto unico de autenticacion, almacenamiento, impresion y monitorizacion para toda la red de la empresa. Los clientes de la red se unen al dominio Active Directory para recibir acceso a recursos y politicas de forma centralizada.

|                    |                                                                |
|--------------------|----------------------------------------------------------------|
| **Componente**     | **Descripcion**                                                |
| Servidor principal | srv-ice01 - Ubuntu Server 24.04 LTS - IP fija <IP_SRV_ICE01>    |
| Dominio AD         | glacianova.local - REALM: GLACIANOVA.LOCAL                     |
| Red corporativa    | <RED_LAN>/24 - Gateway: <GATEWAY>                        |
| DHCP pool          | <INICIO_DHCP> - <FIN_DHCP>                                |
| DNS primario       | <IP_SRV_ICE01> (Samba Internal DNS)                             |
| DNS secundario     | <DNS_EXTERNO> (fallback externo)                                     |
| Cliente Windows    | win-ice01 - Windows 10 Pro - IP dinamica por DHCP              |
| Almacenamiento     | RAID 1 por software (mdadm) - 3 arrays: sistema, datos, backup |

### 2.2 Configuracion del almacenamiento RAID
El almacenamiento del servidor se ha implementado con RAID 1 (espejo) por software mediante mdadm, garantizando que ante el fallo de cualquiera de los dos discos fisicos el servidor continua operativo sin perdida de datos. El RAID se configuro antes de la instalacion del sistema operativo para asegurar que el bootloader GRUB queda instalado en ambos discos y el arranque es redundante desde el primer momento.

|               |                                  |                                                                                                     |
|---------------|----------------------------------|-----------------------------------------------------------------------------------------------------|
| **Array**     | **Particiones fisicas**          | **Funcion**                                                                                         |
| md0 - Sistema | /dev/sda2 + /dev/sdb2 (20-30 GB) | Aloja el sistema operativo y todos los binarios y configuraciones del servidor                      |
| md1 - Datos   | /dev/sda3 + /dev/sdb3 (variable) | Almacena los datos operativos: perfiles moviles de usuarios y carpetas compartidas de departamentos |
| md2 - Backup  | /dev/sda4 + /dev/sdb4 (variable) | Destino de las copias de seguridad automaticas nocturnas generadas por rsync                        |
| EFI/Boot      | /dev/sda1 + /dev/sdb1 (512 MB)   | Particion de arranque EFI, replicada en ambos discos para redundancia de arranque                   |

### 2.3 Servicios implementados en el servidor
|                       |                        |                                |                                                     |
|-----------------------|------------------------|--------------------------------|-----------------------------------------------------|
| **Servicio**          | **Paquete/Tecnologia** | **Puerto/Protocolo**           | **Funcion**                                         |
| Active Directory DC   | Samba 4 (samba-ad-dc)  | 389/LDAP, 88/Kerberos, 135/RPC | Controlador de dominio y autenticacion centralizada |
| DNS interno           | Samba Internal DNS     | 53/UDP+TCP                     | Resolucion de nombres del dominio glacianova.local  |
| DHCP                  | isc-dhcp-server        | 67/UDP                         | Asignacion de IPs dinamicas a clientes              |
| Recursos compartidos  | Samba (SMB/CIFS)       | 445/TCP                        | Carpetas compartidas con permisos por grupo AD      |
| Servidor de impresion | CUPS                   | 631/TCP                        | Gestion centralizada de impresoras                  |
| Acceso remoto         | OpenSSH                | 22/TCP                         | Acceso SSH restringido al grupo IT_ADM              |
| Monitorizacion        | Nagios 4               | 80/TCP (web)                   | Monitorizacion de hosts, servicios y alertas        |
| Copias de seguridad   | rsync + cron           | Local (disco RAID)             | Backup nocturno automatico con retencion de 7 dias  |

## 3. ESTRUCTURA DEL DIRECTORIO ACTIVO
### 3.1 Dominio y configuracion Kerberos
|                             |                                             |
|-----------------------------|---------------------------------------------|
| **Parametro**               | **Valor**                                   |
| Nombre NetBIOS del dominio  | GLACIANOVA                                  |
| FQDN del dominio            | glacianova.local                            |
| Realm de Kerberos           | GLACIANOVA.LOCAL                            |
| Controlador de dominio      | srv-ice01.glacianova.local                  |
| Rol del servidor            | Active Directory Domain Controller          |
| Backend DNS                 | SAMBA_INTERNAL                              |
| RFC2307                     | Habilitado (mapeo de atributos POSIX en AD) |
| Nivel funcional del dominio | Windows 2008 R2 (Samba 4 default)           |

### 3.2 Unidades Organizativas
Se han creado cuatro Unidades Organizativas correspondientes a los departamentos funcionales de la empresa. Cada UO contiene los usuarios y equipos del departamento, facilitando la aplicacion futura de Politicas de Grupo (GPOs) especificas por area:

|                         |                                          |
|-------------------------|------------------------------------------|
| **Unidad Organizativa** | **Ruta LDAP completa**                   |
| Ventas                  | OU=Ventas,DC=glacianova,DC=local         |
| Logistica               | OU=Logistica,DC=glacianova,DC=local      |
| Administracion          | OU=Administracion,DC=glacianova,DC=local |
| IT                      | OU=IT,DC=glacianova,DC=local             |

### 3.3 Grupos de seguridad
|                |                                                                                                          |
|----------------|----------------------------------------------------------------------------------------------------------|
| **Grupo**      | **Proposito y permisos asociados**                                                                       |
| Ventas         | Acceso lectura/escritura a la carpeta compartida \\srv-ice01\ventas                                      |
| Logistica      | Acceso lectura/escritura a la carpeta compartida \\srv-ice01\logistica                                   |
| Administracion | Acceso lectura/escritura a la carpeta compartida \\srv-ice01\administracion                              |
| IT_ADM         | Acceso a todas las carpetas compartidas + acceso SSH al servidor + permisos administrativos de impresion |

### 3.4 Perfiles moviles de usuario
Se han configurado perfiles moviles para todos los usuarios del dominio. Los perfiles se almacenan en el recurso compartido \\srv-ice01\perfiles dentro del disco de datos RAID (/datos/perfiles). Cuando un usuario inicia sesion en cualquier equipo unido al dominio, su perfil se descarga desde el servidor, permitiendo acceder a su escritorio, documentos y configuracion personal independientemente del equipo fisico utilizado.

## 4. RECURSOS COMPARTIDOS Y POLITICA DE PERMISOS
### 4.1 Estructura de carpetas compartidas
Todos los recursos compartidos se ubican en el disco de datos /datos/compartido/, montado sobre el array RAID md1. Esta separacion garantiza que los datos de usuario son independientes del sistema operativo, facilitando su backup y recuperacion:

|                            |                                  |
|----------------------------|----------------------------------|
| **Recurso compartido**     | **Ruta fisica en el servidor**   |
| \\srv-ice01\ventas         | /datos/compartido/ventas         |
| \\srv-ice01\logistica      | /datos/compartido/logistica      |
| \\srv-ice01\administracion | /datos/compartido/administracion |
| \\srv-ice01\comun          | /datos/compartido/comun          |
| \\srv-ice01\perfiles       | /datos/perfiles                  |

### 4.2 Matriz de permisos por grupo
|                |                     |                     |                     |
|----------------|---------------------|---------------------|---------------------|
| **Grupo**      | **\\ventas**        | **\\logistica**     | **\\comun**         |
| Ventas         | Lectura / Escritura | Sin acceso          | Lectura / Escritura |
| Logistica      | Sin acceso          | Lectura / Escritura | Lectura / Escritura |
| Administracion | Sin acceso          | Sin acceso          | Lectura / Escritura |
| IT_ADM         | Lectura / Escritura | Lectura / Escritura | Lectura / Escritura |

|                                                                                                                                                                                                                                                      |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **NOTA TECNICA:** Los permisos se aplican en dos capas: permisos POSIX del sistema de archivos Linux (chmod/chown) y permisos SMB en smb.conf (valid users). Ambas capas deben estar alineadas para que el control de acceso funcione correctamente. |

## 5. POLITICAS DE SEGURIDAD IMPLEMENTADAS
### 5.1 Control de acceso SSH
El acceso remoto por SSH al servidor esta restringido exclusivamente al grupo IT_ADM mediante la directiva AllowGroups en /etc/ssh/sshd_config. Cualquier usuario que no pertenezca a este grupo recibira un error de autenticacion al intentar conectarse, independientemente de si sus credenciales son correctas.

|                        |                                        |
|------------------------|----------------------------------------|
| **Parametro SSH**      | **Valor configurado**                  |
| AllowGroups            | IT_ADM                                 |
| PermitRootLogin        | no                                     |
| MaxAuthTries           | 3                                      |
| LoginGraceTime         | 30 segundos                            |
| PubkeyAuthentication   | yes                                    |
| PasswordAuthentication | yes (puede desactivarse en produccion) |

### 5.2 Politica de contrasenas del dominio
Samba AD aplica por defecto la politica de contrasenas de Windows Active Directory. Se recomienda revisar y endurecer la politica mediante samba-tool domain passwordsettings:

|                          |                                                         |
|--------------------------|---------------------------------------------------------|
| **Parametro**            | **Configuracion**                                       |
| Longitud minima          | 8 caracteres                                            |
| Complejidad              | Habilitada (mayusculas, minusculas, numeros y simbolos) |
| Historial de contrasenas | 24 contrasenas recordadas                               |
| Duracion maxima          | 42 dias (por defecto - se recomienda reducir)           |
| Duracion minima          | 1 dia                                                   |
| Bloqueo de cuenta        | Habilitado tras 5 intentos fallidos                     |

### 5.3 Seguridad de recursos compartidos
- Cada carpeta departamental solo es accesible por los usuarios del grupo correspondiente y por IT_ADM.

- La carpeta de perfiles no es navegable (browseable = No) para evitar que un usuario acceda al perfil de otro.

- Se aplica el bit SETGID (2770) en las carpetas departamentales para que todos los archivos creados hereden el grupo propietario del directorio.

- El acceso anonimo (guest) esta deshabilitado en todos los recursos compartidos.

## 6. SERVIDOR DE IMPRESION
### 6.1 Solucion tecnica
El servidor de impresion se ha implementado con CUPS (Common Unix Printing System), el sistema de impresion estandar en sistemas Linux/Unix. CUPS permite gestionar impresoras locales y de red, publicarlas en la red corporativa y controlar los permisos de impresion por usuario o grupo.

|                         |                                                |
|-------------------------|------------------------------------------------|
| **Aspecto**             | **Configuracion**                              |
| Software                | CUPS (cups y cups-client)                      |
| Puerto de escucha       | <IP>:631 (acceso desde toda la red)         |
| Acceso al panel web     | http://<IP_SRV_ICE01>:631                       |
| Acceso administrativo   | Restringido a la subred <RED_LAN>/24        |
| Permisos de impresion   | Configurados por grupo mediante lpadmin        |
| Integracion con dominio | Autenticacion de usuarios mediante PAM/Winbind |

### 6.2 Publicacion de impresoras
Las impresoras se publican en la red corporativa a traves de CUPS. Los clientes Windows las descubren automaticamente mediante el protocolo de descubrimiento de impresoras de red. Los permisos de impresion se asignan por grupo de seguridad del dominio, garantizando que solo los usuarios autorizados pueden usar cada impresora.

## 7. SISTEMA DE MONITORIZACION
### 7.1 Herramienta de monitorizacion: Nagios 4
La monitorizacion de la infraestructura se ha implementado con Nagios 4, una de las soluciones de monitorizacion de red mas consolidadas del sector. Nagios comprueba periodicamente el estado de los hosts y servicios definidos, generando alertas cuando detecta problemas o cuando los recursos superan umbrales predefinidos.

### 7.2 Hosts y servicios monitorizados
|                            |                                |                                     |
|----------------------------|--------------------------------|-------------------------------------|
| **Host**                   | **Servicio monitorizado**      | **Alerta configurada**              |
| srv-ice01 (<IP_SRV_ICE01>)  | Disponibilidad del host (ping) | Alerta si no responde en 3 intentos |
| srv-ice01                  | Servicio SSH (puerto 22)       | Alerta si SSH no responde           |
| srv-ice01                  | Espacio en /datos (RAID md1)   | Warning al 80%, Critical al 90%     |
| srv-ice01                  | Espacio en /backup (RAID md2)  | Warning al 80%, Critical al 90%     |
| srv-ice01                  | Servicio Samba AD DC           | Alerta si el servicio cae           |
| win-ice01 (<INICIO_DHCP>) | Disponibilidad del host (ping) | Alerta si no responde               |

### 7.3 Acceso al panel de monitorizacion
|                        |                                   |
|------------------------|-----------------------------------|
| **Parametro**          | **Valor**                         |
| URL de acceso          | http://<IP_SRV_ICE01>/nagios4      |
| Usuario                | nagiosadmin                       |
| Acceso permitido desde | Red corporativa <RED_LAN>/24   |
| Frecuencia de chequeos | Cada 5 minutos (por defecto)      |
| Notificaciones         | Configurables por email o webhook |

## 8. POLITICA DE COPIAS DE SEGURIDAD
### 8.1 Estrategia de backup
La politica de copias de seguridad se ha disenado con el principio de que el backup debe ser automatico, verificable y con rotacion para no consumir espacio indefinidamente. Se utiliza rsync para la sincronizacion incremental y cron para la programacion automatica.

### 8.2 Datos incluidos en el backup
|                                       |                    |                           |
|---------------------------------------|--------------------|---------------------------|
| **Dato protegido**                    | **Origen**         | **Destino en /backup**    |
| Carpetas compartidas de departamentos | /datos/compartido/ | /backup/compartido_FECHA/ |
| Perfiles moviles de usuarios          | /datos/perfiles/   | /backup/perfiles_FECHA/   |
| Configuracion de Samba                | /etc/samba/        | /backup/samba_conf_FECHA/ |

### 8.3 Parametros de la politica
|               |                                                   |
|---------------|---------------------------------------------------|
| **Parametro** | **Valor**                                         |
| Herramienta   | rsync con opcion --delete (sincronizacion exacta) |
| Frecuencia    | Diaria automatica a las 02:00 AM                  |
| Programacion  | cron del usuario root                             |
| Retencion     | 7 copias (7 dias)                                 |
| Destino       | Array RAID md2 montado en /backup                 |
| Log de backup | /var/log/backup_glacianova.log                    |
| Script        | /usr/local/bin/backup_glacianova.sh               |

### 8.4 Procedimiento de restauracion
Para restaurar datos desde el backup, el administrador debe localizar el directorio de backup con la fecha deseada en /backup/ y copiar los archivos necesarios a su ubicacion original usando rsync o cp. El procedimiento ha sido verificado durante la implementacion copiando un archivo de prueba, ejecutando el backup, eliminando el archivo y restaurandolo exitosamente desde el backup.

## 9. PRUEBAS DE VALIDACION Y RESULTADOS
Una vez completada la implementacion, se han ejecutado las siguientes pruebas de validacion para confirmar el correcto funcionamiento de todos los servicios:

|                            |                                                         |                                                     |            |
|----------------------------|---------------------------------------------------------|-----------------------------------------------------|------------|
| **Prueba**                 | **Descripcion**                                         | **Resultado**                                       | **Estado** |
| RAID operativo             | cat /proc/mdstat - todos los arrays muestran \[UU\]     | Ambos discos activos en md0, md1 y md2              | OK         |
| IP estatica                | ip a - interfaz con <IP_SRV_ICE01>/24                    | IP correctamente asignada y persistente             | OK         |
| DNS dominio                | host glacianova.local <IP_SRV_ICE01>                     | Resuelve correctamente a <IP_SRV_ICE01>              | OK         |
| Kerberos                   | kinit administrator - obtencion de ticket               | Ticket Kerberos obtenido sin errores                | OK         |
| Login Windows              | Inicio sesion con GLACIANOVA\jgomez en win-ice01        | Autenticacion correcta, perfil movil cargado        | OK         |
| Perfil movil               | Archivos de perfil en /datos/perfiles/jgomez tras login | Carpeta de perfil creada automaticamente            | OK         |
| Acceso \ventas - permitido | Usuario jgomez accede a \\srv-ice01\ventas              | Acceso concedido con lectura/escritura              | OK         |
| Acceso \ventas - denegado  | Usuario mperez (Logistica) accede a \\srv-ice01\ventas  | Acceso denegado correctamente                       | OK         |
| SSH IT_ADM                 | SSH con alopez (IT_ADM) desde cliente                   | Conexion SSH establecida correctamente              | OK         |
| SSH bloqueado              | SSH con jgomez (Ventas) desde cliente                   | Conexion rechazada: Permission denied               | OK         |
| Impresion CUPS             | Impresion de pagina de prueba desde Windows             | Trabajo procesado y enviado correctamente           | OK         |
| Backup manual              | Ejecucion manual del script de backup                   | Directorios creados en /backup/ con datos correctos | OK         |
| Restauracion               | Restauracion de archivo de prueba desde /backup/        | Archivo recuperado sin perdida de datos             | OK         |
| Nagios hosts               | Panel web: estado de todos los hosts                    | Todos los hosts en estado OK (verde)                | OK         |
| DHCP asignacion            | ipconfig /all en win-ice01                              | IP en rango .100-.200, DNS = <IP_SRV_ICE01>          | OK         |

## 10. DIAGRAMA DE RED Y ARQUITECTURA
|                                                                                                                                                                                                                                                                  |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **DESCRIPCION:** La arquitectura de red de GlaciaNova Distribucion S.L. esta basada en una red plana de clase C (<RED_LAN>/24) con el servidor actuando como punto central de todos los servicios. A continuacion se detalla la topologia logica del sistema. |

### 10.1 Topologia logica de la red
|                                    |                                                         |
|------------------------------------|---------------------------------------------------------|
| **Dispositivo / Servicio**         | **Direccion IP y funcion**                              |
| Gateway / Router                   | <GATEWAY> - Salida a Internet                        |
| srv-ice01 - Servidor principal     | <IP_SRV_ICE01> - DC, DNS, DHCP, Samba, CUPS, Nagios, SSH |
| win-ice01 - Cliente Windows 10 Pro | <INICIO_DHCP>-200 (dinamica) - Equipo unido al dominio |
| Pool DHCP disponible               | <INICIO_DHCP> - <FIN_DHCP> - Para futuros clientes |
| Broadcast de red                   | <IP>                                          |

### 10.2 Flujo de autenticacion de un cliente
- El cliente arranca y solicita IP al servidor DHCP (srv-ice01:67/UDP).

- El servidor DHCP asigna IP dinamica + DNS = <IP_SRV_ICE01> + dominio = glacianova.local.

- El cliente resuelve srv-ice01.glacianova.local mediante DNS (<IP_SRV_ICE01>:53).

- El usuario introduce credenciales de dominio -\> el cliente contacta el DC en <IP_SRV_ICE01>:88 (Kerberos) y <IP_SRV_ICE01>:389 (LDAP).

- Kerberos valida las credenciales y emite un ticket de sesion.

- El perfil movil del usuario se carga desde \\srv-ice01\perfiles\usuario (puerto 445).

- El usuario puede acceder a los recursos compartidos de su departamento mediante SMB/CIFS (445/TCP).

## 11. INVENTARIO DE SOFTWARE Y VERSIONES
|                 |                                      |                                                                |
|-----------------|--------------------------------------|----------------------------------------------------------------|
| **Software**    | **Version / Paquete**                | **Funcion**                                                    |
| Ubuntu Server   | 24.04 LTS (Noble Numbat)             | Sistema operativo base del servidor                            |
| Samba           | 4.x (samba, samba-tool)              | Controlador de dominio Active Directory y servidor de archivos |
| Winbind         | libnss-winbind, libpam-winbind       | Integracion de cuentas de dominio en el sistema Linux          |
| Kerberos        | krb5-user                            | Autenticacion de red del dominio Active Directory              |
| isc-dhcp-server | isc-dhcp-server                      | Servidor DHCP para asignacion de IPs a clientes                |
| OpenSSH         | openssh-server (integrado en Ubuntu) | Servidor SSH para acceso remoto seguro                         |
| CUPS            | cups, cups-client                    | Servidor de impresion                                          |
| Nagios          | nagios4, nagios-plugins              | Monitorizacion de red y servicios                              |
| rsync           | rsync (integrado)                    | Herramienta de sincronizacion para copias de seguridad         |
| mdadm           | mdadm (integrado en Ubuntu Server)   | Gestion del RAID por software                                  |
| ACL             | acl                                  | Soporte de listas de control de acceso extendidas en ext4      |
| Windows 10 Pro  | Build reciente                       | Sistema operativo del cliente unido al dominio                 |

## 12. RECOMENDACIONES DE MANTENIMIENTO
### 12.1 Tareas periodicas recomendadas
|                     |                                     |                                                                                          |
|---------------------|-------------------------------------|------------------------------------------------------------------------------------------|
| **Frecuencia**      | **Tarea**                           | **Procedimiento**                                                                        |
| Diario (automatico) | Copia de seguridad nocturna         | El cron ejecuta backup_glacianova.sh a las 02:00. Revisar /var/log/backup_glacianova.log |
| Semanal             | Revision de estado RAID             | cat /proc/mdstat - verificar que todos los arrays muestran \[UU\]                        |
| Semanal             | Revision de logs Samba              | journalctl -u samba-ad-dc --since '7 days ago'                                           |
| Mensual             | Actualizaciones de seguridad        | sudo apt update && sudo apt upgrade -y. Reiniciar si hay actualizacion de kernel         |
| Mensual             | Revision de cuentas inactivas       | sudo samba-tool user list y verificar usuarios que ya no estan en la empresa             |
| Trimestral          | Prueba de restauracion de backup    | Restaurar archivos de prueba desde /backup/ para verificar integridad                    |
| Anual               | Revision de politica de contrasenas | Revisar y actualizar si es necesario con samba-tool domain passwordsettings              |

### 12.2 Procedimiento ante fallo de un disco RAID
- El sistema seguira funcionando con un solo disco. Nagios alertara del fallo detectado.

- Sustituir fisicamente el disco defectuoso por uno del mismo tamano o mayor.

- Agregar el disco al array con: sudo mdadm /dev/md0 --add /dev/sdb2 (y repetir para md1 y md2).

- mdadm sincronizara automaticamente el nuevo disco. El progreso se ve en /proc/mdstat.

- El proceso de sincronizacion puede tardar horas segun el tamano del disco.

## 13. CONCLUSIONES
El Proyecto 1 de implementacion de infraestructura de servidor para GlaciaNova Distribucion S.L. ha sido completado satisfactoriamente en todos sus aspectos. La solucion entregada proporciona al cliente una plataforma de IT centralizada, robusta y segura que cubre la totalidad de los requisitos definidos en el alcance del proyecto.

La decision de implementar RAID 1 antes de la instalacion del sistema operativo ha garantizado la redundancia de almacenamiento desde el primer momento, con el bootloader instalado en ambos discos y los tres arrays (sistema, datos y backup) completamente sincronizados. La separacion logica de los datos en particiones independientes facilita enormemente las operaciones de mantenimiento, backup y eventual recuperacion ante desastres.

La integracion de Samba 4 como controlador de dominio Active Directory ofrece al cliente una experiencia de gestion centralizada equivalente a la de un entorno Windows Server, con la ventaja de los costes de licenciamiento cero del software de codigo abierto. Los clientes Windows 10 Pro se unen al dominio de forma nativa y tienen acceso transparente a todos los recursos compartidos, perfiles moviles e impresoras de red.

El sistema de monitorizacion Nagios y la politica de copias de seguridad automatizadas con rsync proporcionan las garantias operacionales necesarias para que el equipo IT del cliente pueda gestionar la infraestructura con confianza, detectando problemas de forma proactiva y disponiendo de copias de los datos en todo momento.

Documento elaborado por **NorthByte IT Services** \| Proyecto: PRY-GLACIANOVA-2026-001 \| Marzo 2026
