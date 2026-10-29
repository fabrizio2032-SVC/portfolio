
## DATOS DE IDENTIFICACIÓN DEL PROYECTO

| **Campo**               | **Detalle (Diligenciar por el Alumno)**                                                                                                                                                                                                  |
|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Título del Proyecto** | Plan de resiliencia frente a ransomware para el Colegio Oficial de Arquitectos de León (COAL): copias de seguridad aisladas e inmutables, recuperación ante desastres, monitorización y alertas, validado en un laboratorio virtualizado |
| **Autor / Alumno**      | *Fabrizio Barrial y dos compañeros de 2º ASIR*                                                                                                                                                                                       |
| **Ciclo Formativo**     | *Administración de Sistemas Informáticos en Red - ASIR*                                                                                                                                                                                  |
| **Curso Académico**     | *2025 - 2026*                                                                                                                                                                                                                            |

# Identificación de necesidades

> Este capítulo contextualiza el entorno del proyecto, justifica la necesidad técnica y operativa de la solución y aborda los aspectos normativos, las posibles ayudas económicas y el guion metodológico de trabajo.

## Contextualización

> El Colegio Oficial de Arquitectos de León (COAL) es una corporación de derecho público que ordena el ejercicio profesional de los arquitectos de su demarcación. Entre sus funciones están el visado de proyectos, la gestión de expedientes y documentación de los colegiados, la facturación y cobro de cuotas, y la comunicación con administraciones y ciudadanos. Todas estas actividades dependen de servidores de ficheros, aplicaciones de gestión, correo electrónico y copias de seguridad.
> **Incidente documentado.** Según la prensa local (Heraldo de León, 2 y 3 de octubre de 2026), unos ciberdelincuentes tomaron el control de los servidores del COAL y cifraron la información almacenada en ellos, lo que impidió utilizar con normalidad buena parte de los sistemas de los que depende la actividad colegial, incluidos el visado de proyectos y la gestión y salida de documentación. El 3 de octubre el Colegio seguía tratando de recuperar la normalidad. El Colegio activó sus protocolos de seguridad, comunicó los hechos a las Fuerzas y Cuerpos de Seguridad, al Instituto Nacional de Ciberseguridad (INCIBE) y a la Agencia Española de Protección de Datos (AEPD), y alertó a sus colegiados sobre posibles intentos de suplantación. A fecha de la noticia no se había podido confirmar si se habían sustraído datos personales.
> Por otro lado, un portal especializado en seguimiento de ransomware recoge que el grupo Akira reivindicó el ataque el 2 de octubre de 2026 y anunció la publicación de unos 77 GB de datos corporativos. Se trata de una afirmación del propio grupo atacante, no verificada de forma independiente, y así se trata en este proyecto.
> **Ámbito técnico y problema detectado.** El caso encaja con el patrón conocido de ransomware con doble extorsión: acceso inicial, movimiento lateral, cifrado de servidores y exfiltración. El problema que este proyecto aborda no es el acceso inicial, que es imposible de descartar por completo, sino la **capacidad de la organización para recuperarse**: disponer de copias que el atacante no pueda borrar ni cifrar, saber qué se ha perdido, detectar el cifrado masivo en minutos y restaurar con un procedimiento ensayado. La situación de partida que se modela en el laboratorio es la habitual en instituciones de tamaño medio: servidores de ficheros y dominio sin segmentación de las copias, copias accesibles con las mismas credenciales de dominio, ausencia de alertas tempranas y restauraciones no ensayadas.

## Justificación

> El proyecto es necesario porque el incidente del COAL demuestra que el impacto de un ransomware depende menos de la entrada del atacante que del tiempo de recuperación. Un colegio profesional no puede suspender durante días el visado ni la entrega de documentación sin perjuicio a sus colegiados y a terceros. Las ventajas que aporta la solución son:

- **Operativas:** reducción del tiempo de recuperación (RTO) de días a horas mediante un procedimiento de restauración documentado y semiautomatizado.

- **Técnicas:** copias inmutables y aisladas (modelo 3-2-1-1-0) que no dependen de las credenciales del dominio, con verificación periódica de integridad.

- **Detección temprana:** ficheros canario y control de anomalías en el volumen de copia para alertar en minutos de un cifrado masivo.

- **Trazabilidad y cumplimiento:** registro en base de datos de cada copia, incidente y restauración, útil como evidencia para la notificación de brechas a la AEPD.

- **Consistencia y reversibilidad:** restauración primero en un entorno limpio, validación y reversión (rollback) automática si falla la verificación.

- **Escalabilidad y bajo coste:** uso de software de código abierto y de contenedores, reutilizable por otras corporaciones colegiales de tamaño similar.

## Otros aspectos

### Obligaciones fiscales, laborales y prevención de riesgos

> **Protección de datos.** El COAL trata datos personales de colegiados (identificación, datos profesionales, datos bancarios). Es de aplicación el Reglamento (UE) 2016/679 (RGPD) y la Ley Orgánica 3/2018 (LOPDGDD). El artículo 32 del RGPD obliga a aplicar medidas técnicas que garanticen, entre otras cosas, la capacidad de restaurar la disponibilidad y el acceso a los datos de forma rápida en caso de incidente. Los artículos 33 y 34 obligan a notificar a la autoridad de control en un plazo de 72 horas desde que se tiene constancia de una brecha que suponga riesgo, y a comunicarlo a los afectados cuando el riesgo sea alto. El sistema de registro del proyecto está diseñado para generar la cronología necesaria para esa notificación.
> **Seguridad de la información.** Se toman como referencia el Esquema Nacional de Seguridad (Real Decreto 311/2022), cuya aplicación formal dependerá de si el Colegio presta servicios a administraciones públicas por vía electrónica, la familia ISO/IEC 27001 y el marco NIST Cybersecurity Framework 2.0, funciones Detectar, Responder y Recuperar. También se considera la Directiva NIS2 como referencia de buenas prácticas.
> **Licencias de software.** Se emplea Windows Server en modo de evaluación (180 días) para el laboratorio; en producción requeriría licenciamiento por núcleos y CAL. El resto del software es de código abierto o de licencia permisiva, salvo n8n, que se distribuye bajo la Sustainable Use License (fair-code), que permite el uso interno empresarial pero no la reventa como servicio.
> **Obligaciones fiscales y laborales.** Si el proyecto se ejecutara como servicio contratado, el prestador estaría sujeto a IVA (21 %) y a las obligaciones de facturación habituales; el coste de horas se estima de forma neta en este documento. La subcontratación de un servicio de recuperación exigiría un contrato de encargado del tratamiento conforme al artículo 28 del RGPD.
> **Prevención de riesgos laborales.** Conforme a la Ley 31/1995 y al Real Decreto 488/1997 sobre pantallas de visualización de datos, el puesto de administración debe contar con mobiliario ergonómico, pausas periódicas y buena iluminación. Para la gestión de hardware se observarán medidas de manipulación de cargas, orden del cableado y protección frente a descargas electrostáticas en el montaje del equipo anfitrión y del disco de copia offline.

### Ayudas y subvenciones

> Las siguientes vías se citan a título informativo; su vigencia y la elegibilidad del COAL, por ser una corporación de derecho público y no una pyme mercantil, deben comprobarse en las convocatorias vigentes antes de solicitarlas.

- **Programa Kit Digital (Red.es):** incluye categorías de ciberseguridad, pero está orientado a pymes, microempresas y autónomos; es probable que el COAL no sea beneficiario directo, aunque sí podrían serlo empresas colegiadas o proveedores.

- **Fondos europeos NextGenerationEU / Plan de Recuperación:** financian digitalización y ciberseguridad, pero su calendario de ejecución llega a 2026, por lo que es poco probable que haya convocatorias nuevas abiertas.

- **Ayudas autonómicas de Castilla y León** (a través del Instituto para la Competitividad Empresarial y consejerías con competencias en digitalización): convocatorias periódicas de digitalización y

> ciberseguridad, sujetas a requisitos de beneficiario.

- **Servicios públicos de INCIBE:** asesoramiento y recursos de respuesta a incidentes sin coste, que el propio Colegio ya está utilizando según la noticia.

### Guion de trabajo del proyecto

> El proyecto sigue una metodología en cascada con revisiones iterativas, en ocho fases que coinciden con el cronograma del apartado 3.1:

- **Fase 1. Análisis:** estudio del incidente documentado, definición de requisitos, RTO/RPO objetivo y alcance del laboratorio.

- **Fase 2. Diseño de arquitectura:** segmentación de redes, política de copias 3-2-1-1-0 y modelo de datos.

- **Fase 3. Virtualización y contenedores:** instalación del hipervisor, máquinas virtuales y entorno Docker.

- **Fase 4. Servicios de datos y automatización:** PostgreSQL y flujos de n8n (alertas, registro, restauración).

- **Fase 5. Copias y recuperación:** repositorio append-only, políticas de retención y scripts de restauración.

- **Fase 6. Acceso y protección perimetral:** Nginx, WireGuard, Squid, Fail2ban y Samba.

- **Fase 7. Monitorización:** paneles de Grafana, ficheros canario y alertas.

- **Fase 8. Pruebas y documentación:** pruebas de recuperación, correcciones, manuales y memoria.

# Diseño del proyecto

> Este capítulo define la propuesta conceptual y técnica: objetivos, recursos, viabilidad económica y arquitectura detallada del sistema.

## Contenido

> La propuesta consiste en una plataforma de resiliencia compuesta por cinco bloques integrados:

- **Entorno corporativo simulado:** controlador de dominio Windows Server con Active Directory y un servidor de ficheros Samba que simula el repositorio de expedientes y visados.

- **Bóveda de copias:** servidor aislado con repositorio restic en modo append-only, snapshots del sistema de ficheros y copia offline rotatoria en disco USB.

- **Motor de orquestación (n8n):** recibe alertas, clasifica incidentes, registra eventos, notifica y ejecuta el flujo de restauración con rollback.

- **Base de datos de trazabilidad (PostgreSQL):** inventario de sistemas, registro de copias, incidentes, restauraciones y logs de workflow.

- **Monitorización (Grafana) y portal web (Nginx):** paneles de estado de copias y alertas, y formulario web para comunicar incidencias y solicitar restauraciones.

> El acceso de administración remota se realiza únicamente por VPN WireGuard; la salida a Internet pasa por un proxy Squid con listas de control y el acceso por SSH queda protegido con Fail2ban.

### Estudio de viabilidad técnica

> La tecnología elegida es viable por las siguientes razones:

- **Compatibilidad:** restic funciona de forma nativa en Linux y Windows (con instantáneas VSS) y utiliza un protocolo HTTP sencillo hacia rest-server; n8n y Grafana se conectan a PostgreSQL con controladores estándar.

- **Bajo consumo:** el conjunto de contenedores (Nginx, n8n, PostgreSQL y Grafana) requiere en reposo menos de 3 GB de RAM; la máquina de servicios con 8 GB tiene margen amplio.

- **Reproducibilidad:** toda la pila se define en un fichero docker-compose.yml con versiones fijadas, lo que permite reconstruirla rápidamente, algo esencial en un plan de recuperación.

- **Escalabilidad:** restic deduplica y cifra los datos en origen, de modo que el crecimiento del repositorio es moderado; la bóveda puede ampliarse añadiendo almacenamiento sin cambiar la arquitectura.

- **Madurez del software:** todos los componentes cuentan con comunidad activa y documentación oficial.

## Objetivos y recursos

### Objetivos del proyecto

> **Objetivo general.** Diseñar, implantar y validar en un laboratorio virtualizado un sistema de copias de seguridad aisladas, recuperación ante desastres, monitorización y alerta temprana que permita a una institución colegial como el COAL recuperar sus servicios críticos tras un ataque de ransomware en un tiempo y con una pérdida de datos previamente acordados.

#### Objetivos específicos.

- OE1. Reproducir en laboratorio un entorno corporativo con dominio Active Directory y servidor de ficheros de expedientes.

- OE2. Implantar un repositorio de copias en modo append-only en una red aislada, de forma que un cliente comprometido no pueda borrar ni modificar copias anteriores.

- OE3. Aplicar la política 3-2-1-1-0 con retención de 14 copias diarias, 8 semanales y 12 mensuales, y una copia offline semanal.

- OE4. Detectar un cifrado masivo en menos de 5 minutos mediante ficheros canario y control de anomalías del tamaño de las copias.

- OE5. Automatizar con n8n el registro, la clasificación de gravedad y la notificación de incidentes.

- OE6. Implementar un procedimiento de restauración con verificación de integridad y rollback automático.

- OE7. Centralizar en PostgreSQL la trazabilidad de copias, incidentes y restauraciones, útil para la notificación de brechas.

- OE8. Visualizar en Grafana el estado de las copias, las alertas y los tiempos de recuperación.

- OE9. Proteger el acceso administrativo con WireGuard, Fail2ban y segmentación de red.

- OE10. Alcanzar un RTO objetivo de 4 horas y un RPO objetivo de 24 horas para los servicios críticos y documentarlo en manuales y SLA.

### Recursos hardware

| **Recurso / Equipo**                     | **Especificación Mínima / Recomendada**                                                  | **Función en el Proyecto**                                                                  |
|------------------------------------------|------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| **Servidor Anfitrión / Hipervisor**      | CPU 8 núcleos / 16 hilos, 32 GB RAM, 1 TB SSD NVMe (mínimo 16 GB RAM con carga reducida) | Alojar las máquinas virtuales del laboratorio (Proxmox VE, VMware Workstation o VirtualBox) |
| **Máquina Virtual 1 (Windows) srv-dc01** | Windows Server 2022: 2 vCPU, 4 GB RAM, 60 GB disco                                       | Controlador de dominio / Active Directory, DNS y GPO                                        |

<table>
<colgroup>
<col style="width: 26%" />
<col style="width: 36%" />
<col style="width: 36%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Recurso / Equipo</strong></th>
<th><strong>Especificación Mínima / Recomendada</strong></th>
<th><strong>Función en el Proyecto</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>Máquina Virtual 2 (Ubuntu) srv-docs01</strong></td>
<td>Ubuntu Server 24.04 LTS: 2 vCPU, 2 GB RAM, 150 GB disco</td>
<td>Servidor de ficheros Samba (simula el repositorio de expedientes y visados)</td>
</tr>
<tr class="even">
<td><strong>Máquina Virtual 3 (Ubuntu) srv-svc01</strong></td>
<td>Ubuntu Server 24.04 LTS: 4 vCPU, 8 GB RAM, 80 GB disco</td>
<td>Servidor Docker (Nginx, n8n, PostgreSQL, Grafana), WireGuard, Squid y Fail2ban</td>
</tr>
<tr class="odd">
<td><strong>Máquina Virtual 4 (Ubuntu) srv-vault01</strong></td>
<td>Ubuntu Server 24.04 LTS: 2 vCPU, 2 GB RAM, 300 GB disco (btrfs o ZFS)</td>
<td>Bóveda de copias aislada: rest-server append-only y snapshots</td>
</tr>
<tr class="even">
<td><strong>Cliente Windows de pruebas</strong></td>
<td><p>Windows 10/11: 2 vCPU, 4 GB RAM, 50</p>
<p>GB disco</p></td>
<td>Estación de trabajo para pruebas de usuario y unión al dominio</td>
</tr>
<tr class="odd">
<td><strong>Disco USB externo</strong></td>
<td>2 TB, USB 3.0</td>
<td>Copia offline rotatoria (desconectada fuera de la ventana de copia)</td>
</tr>
</tbody>
</table>

### Recursos software

| **Software**                       | **Uso en el proyecto**                      | **Licencia**                                   |
|------------------------------------|---------------------------------------------|------------------------------------------------|
| **Windows Server 2022**            | Controlador de dominio, AD DS y DNS         | Comercial (evaluación 180 días en laboratorio) |
| **Ubuntu Server 24.04 LTS**        | Sistema operativo de las máquinas Linux     | Software libre (GPL y otras)                   |
| **Docker Engine y Docker Compose** | Ejecución de contenedores                   | Apache 2.0                                     |
| **PostgreSQL 16**                  | Base de datos de trazabilidad               | PostgreSQL License (permisiva)                 |
| **n8n**                            | Orquestación de workflows y webhooks        | Sustainable Use License (fair-code)            |
| **Nginx**                          | Servidor web y formulario de incidencias    | BSD de 2 cláusulas                             |
| **Grafana OSS**                    | Paneles de monitorización                   | AGPL v3                                        |
| **restic y rest-server**           | Copias cifradas, deduplicadas y append-only | BSD de 2 cláusulas                             |
| **WireGuard**                      | VPN para administración remota              | GPL v2                                         |
| **Squid**                          | Proxy de salida y filtrado                  | GPL v2                                         |
| **Fail2ban**                       | Prevención de intrusiones por fuerza bruta  | GPL v2                                         |
| **Samba**                          | Recursos compartidos de red                 | GPL v3                                         |

### Recursos personales

> El alumno asume los roles de responsable de diseño, implantación, pruebas y documentación, con una dedicación estimada de 150 horas repartidas en ocho semanas (aproximadamente 19 horas semanales). El tutor o tutora académico supervisa los hitos de cada fase, valida el diseño y revisa la memoria. Como asesoramiento técnico externo se consideran las guías públicas de INCIBE y del CCN-CERT y la documentación oficial de cada herramienta.

## Viabilidad económica

### Presupuesto estimado

| **Concepto / Elemento**              | **Tipo / Licencia**   | **Coste Estimado (€)** |
|--------------------------------------|-----------------------|------------------------|
| Hardware Servidor (Equipo anfitrión) | Propiedad / Inversión | 1.500,00 €             |

<table>
<colgroup>
<col style="width: 54%" />
<col style="width: 25%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Concepto / Elemento</strong></th>
<th><strong>Tipo / Licencia</strong></th>
<th><strong>Coste Estimado (€)</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Disco USB externo 2 TB (copia offline)</td>
<td>Hardware</td>
<td>90,00 €</td>
</tr>
<tr class="even">
<td>Licencia Sistema Operativo (Windows Server)</td>
<td>Comercial / Evaluación</td>
<td>250,00 €</td>
</tr>
<tr class="odd">
<td>Software de Contenedores y Servicios (Docker, PostgreSQL, n8n, Nginx, Grafana, restic, WireGuard, Squid, Fail2ban, Samba)</td>
<td>Código Abierto / fair-code</td>
<td>0,00 €</td>
</tr>
<tr class="even">
<td>Horas de Trabajo (Diseño, Configuración y Pruebas)</td>
<td><p>Mano de obra (150 hrs x 25</p>
<p>€/h)</p></td>
<td>3.750,00 €</td>
</tr>
<tr class="odd">
<td><strong>TOTAL PRESUPUESTO ESTIMADO</strong></td>
<td>—</td>
<td><strong>5.590,00 €</strong></td>
</tr>
</tbody>
</table>

> Para contextualizar el coste: la inversión del laboratorio es una fracción pequeña de lo que supondría una paralización prolongada de la actividad de una institución colegial, de las sanciones por una gestión deficiente de la brecha y de los costes de respuesta a incidentes. El importe de un rescate no se considera una opción, ya que su pago no garantiza la recuperación de los datos y financia a la actividad delictiva.

### Financiación

> En el marco académico, el proyecto se financia con fondos propios del alumno y el equipamiento personal existente, que se amortiza como inversión formativa. En un despliegue real en el COAL, la financiación procedería del presupuesto ordinario de la corporación, con posibilidad de leasing informático para el hardware de la bóveda y de las ayudas del apartado 1.3.2 si se acreditara elegibilidad. El coste de operación recurrente se limita a la sustitución periódica de discos, la renovación de licencias comerciales y las horas de mantenimiento.

## Modelo de solución

### Descripción general

> La arquitectura se divide en cuatro capas con responsabilidades separadas:

- **Capa de identidad y datos de usuario:** Active Directory (srv-dc01) y Samba (srv-docs01). Es la capa que sufre el ataque en el escenario de prueba.

- **Capa de protección de datos:** la bóveda (srv-vault01) en una red aislada. Recibe copias mediante credenciales exclusivas de restic, distintas de las del dominio. Su propósito es sobrevivir al compromiso total de la capa anterior.

- **Capa de automatización y persistencia:** n8n y PostgreSQL en srv-svc01 sobre redes Docker segmentadas. Reciben alertas, registran y actúan.

- **Capa de monitorización y acceso:** Grafana, Nginx, WireGuard, Squid y Fail2ban, que ofrecen visibilidad y controlan el acceso.

> El principio de diseño es que ninguna cuenta de dominio, incluida la de administrador del dominio, pueda eliminar las copias. Para ello se combinan el modo append-only, las credenciales independientes, la segmentación por cortafuegos, los snapshots del sistema de ficheros de la bóveda y la copia offline.

### Flujo general del sistema

> Se definen dos flujos principales: el de detección y el de restauración.

#### Flujo de detección.

- 1\. Un detector (fichero canario modificado, caída brusca o pico anómalo del tamaño de la copia, fallo de la verificación periódica o evento reportado desde el formulario web) envía un webhook HTTP a n8n.

- 2\. n8n valida el origen y calcula una huella del evento (hash de origen, tipo y hora) para evitar duplicados.

- 3\. Se inserta el incidente en PostgreSQL con su gravedad (N1 a N4 según el SLA).

- 4\. Si la gravedad es N1 o N2, se notifica por correo y mensajería al responsable de sistemas y se ofrece el procedimiento de contención (aislar el segmento de red afectado).

- 5\. Grafana refleja el incidente en el panel de estado en tiempo casi real.

#### Flujo de restauración.

- 1\. Un administrador autorizado solicita la restauración a través del portal (sistema, instantánea y destino).

- 2\. n8n comprueba que el destino es un entorno limpio y registra la solicitud en la tabla de restauraciones.

- 3\. Se toma un snapshot de seguridad previo del destino.

- 4\. Se ejecuta la restauración por SSH desde srv-svc01 con restic.

- 5\. Se verifica la integridad (comparación de sumas de control contra el manifiesto y arranque de servicios).

- 6\. Si la verificación es correcta, se promueve el destino y se registra el éxito; en caso contrario se activa el rollback del apartado siguiente.

### Rollback implementado

> El mecanismo de rollback actúa sobre el workflow de restauración. Su objetivo es que una restauración fallida nunca deje el sistema en un estado peor que el previo. Las acciones de limpieza ante un error en cualquier punto del flujo son:

- **Reversión del destino:** se restablece el snapshot de seguridad tomado antes de iniciar la restauración.

- **Eliminación de elementos parciales:** se borra el directorio temporal de restauración y se desmonta cualquier volumen montado de forma temporal.

- **Reversión en base de datos:** el registro de la restauración se actualiza con estado FALLIDA dentro de una transacción; los cambios intermedios se deshacen con ROLLBACK, y la fila de auditoría se conserva.

- **Registro del fallo:** se escribe en la tabla logs_workflow el nodo que falló, el mensaje de error y la marca de tiempo.

- **Notificación:** se envía alerta al responsable con la causa y la instantánea alternativa recomendada (la anterior más reciente).

> Se ha previsto que n8n trate los errores con un workflow dedicado (Error Trigger) para que la limpieza se ejecute incluso ante fallos inesperados.

### Direccionamiento IP y puertos de acceso

> Se emplean tres redes: la LAN corporativa simulada 198.51.100.0/24, la red aislada de la bóveda 203.0.113.0/24 y la red del túnel VPN 192.0.2.0/24.

| **Servicio / Componente** | **Dirección IP** | **Puerto / Protocolo** | **Descripción de Acceso**           |
|---------------------------|------------------|------------------------|-------------------------------------|
| **Servidor Web (Nginx /** | 198.51.100.20    | 8080 / HTTP            | Formulario de incidencias y portal  |
| **Front-end)**            |                  |                        | corporativo; acceso desde LAN y VPN |

| **Servicio / Componente**               | **Dirección IP**              | **Puerto / Protocolo** | **Descripción de Acceso**                                                               |
|-----------------------------------------|-------------------------------|------------------------|-----------------------------------------------------------------------------------------|
| **Motor de Automatización (n8n)**       | 198.51.100.20                 | 5678 / HTTP            | Panel de control y Webhooks; panel restringido a VPN, webhooks solo a orígenes internos |
| **Base de Datos (PostgreSQL)**          | Red Docker interna (data_net) | 5432 / TCP             | Acceso restringido a los contenedores n8n y Grafana                                     |
| **Monitorización (Grafana)**            | 198.51.100.20                 | 3000 / HTTP            | Dashboards de seguimiento; acceso desde LAN y VPN                                       |
| **VPN (WireGuard)**                     | 198.51.100.20                 | 51820 / UDP            | Administración remota cifrada                                                           |
| **Proxy (Squid)**                       | 198.51.100.20                 | 3128 / TCP             | Salida a Internet filtrada para servidores                                              |
| **Servidor de ficheros (Samba)**        | 198.51.100.30                 | 445 / TCP              | Recursos compartidos de expedientes para usuarios del dominio                           |
| **Active Directory / DNS**              | 198.51.100.10                 | 53, 389, 445 / TCP-UDP | Servicios de dominio para la LAN                                                        |
| **Repositorio de copias (rest-server)** | 203.0.113.10                 | 8000 / TCP             | Solo desde 198.51.100.10, .20 y .30; modo append-only                                   |
| **SSH de administración**               | Todos los servidores Linux    | 22 / TCP               | Solo desde la red del túnel VPN; protegido con Fail2ban                                 |

### Red Docker

> En srv-svc01 se definen dos redes de tipo bridge definidas por el usuario:

- **app_net:** red de aplicación. Conecta Nginx, n8n y Grafana, y es la que expone puertos hacia la LAN.

- **data_net:** red de datos, declarada como internal (sin salida ni entrada externa). Solo contiene PostgreSQL, n8n y Grafana.

> PostgreSQL no publica ningún puerto en el anfitrión y solo es alcanzable desde n8n y Grafana, que actúan como puente entre ambas redes. Así, un compromiso del servidor web no ofrece acceso directo a la base de datos.

### Seguridad implementada

- **Aislamiento de la bóveda:** red propia, cortafuegos que solo admite el puerto 8000 desde tres orígenes y ninguna conexión saliente hacia la LAN.

- **Copias inmutables:** rest-server con --append-only y --private-repos, snapshots diarios de btrfs o ZFS en solo lectura y copia offline semanal.

- **Credenciales independientes:** las contraseñas de restic y de los repositorios no pertenecen al dominio, se generan aleatoriamente (mínimo 32 caracteres) y se custodian fuera de línea.

- **Mínimos privilegios:** cuentas de servicio específicas para copia (lectura sobre los datos), roles separados en PostgreSQL (lectura para Grafana, escritura limitada para n8n).

- **Acceso remoto cifrado:** administración solo por WireGuard; SSH con clave pública y sin contraseña.

- **Fail2ban:** bloqueo automático de IP con intentos fallidos sobre SSH y Nginx.

- **Restricciones UNIQUE en base de datos:** huella única de incidente y de instantánea para evitar duplicados y manipulaciones.

- **Cifrado en origen:** restic cifra los datos antes de enviarlos a la bóveda.

- **Proxy Squid:** los servidores solo salen a destinos de actualización permitidos, lo que limita la exfiltración y las conexiones a infraestructura de mando y control.

- **Versiones fijadas:** imágenes de contenedor con etiquetas exactas y actualizaciones planificadas.

# Ejecución del proyecto

> Este capítulo refleja la implantación práctica, el cronograma, la gestión de riesgos, la revisión de recursos, la documentación del despliegue y los manuales.

## Planificación temporal

| **Período / Semana** | **Actividades Principales Desarrolladas**                                                                |
|----------------------|----------------------------------------------------------------------------------------------------------|
| **Semana 1**         | Análisis del incidente del COAL y de requisitos; definición de RTO/RPO, arquitectura y objetivos         |
| **Semana 2**         | Instalación del hipervisor, creación de las cuatro máquinas virtuales y del cliente; Docker en srv-svc01 |
| **Semana 3**         | Despliegue de PostgreSQL, diseño de tablas y despliegue del dominio Active Directory y Samba             |
| **Semana 4**         | Despliegue del repositorio append-only en la bóveda; políticas de copia y retención con restic           |
| **Semana 5**         | Desarrollo de workflows en n8n (alertas, registro, restauración y rollback) y configuración de Webhooks  |
| **Semana 6**         | Configuración de Nginx, formulario web, WireGuard, Squid, Fail2ban y reglas de cortafuegos               |
| **Semana 7**         | Implementación de monitorización con Grafana, ficheros canario, logs y copia offline                     |
| **Semana 8**         | Pruebas funcionales integrales y de recuperación, corrección de errores y documentación                  |

## Riesgos

### Identificación de riesgos

- Incompatibilidad de versiones entre contenedores y desfase de imágenes.

- Fallos de conectividad entre los sistemas Linux y Windows y bloqueos del cortafuegos entre segmentos.

- Errores de permisos en directorios compartidos y en volúmenes de contenedores.

- Fallos de webhooks al pasar de pruebas a producción.

- Compromiso de las credenciales del repositorio de copias.

- Copias corruptas o incompletas que no se detectan hasta que se necesitan.

- Agotamiento del almacenamiento de la bóveda por el modo append-only.

- Falsos positivos de los ficheros canario por tareas legítimas de mantenimiento.

- Imposibilidad de establecer la VPN desde redes externas (CGNAT, bloqueo de puertos UDP).

### Plan de prevención de riesgos

> Se definen las siguientes directrices: trabajar con versiones fijadas y probadas; validar cada cambio primero en un entorno de pruebas separado; realizar pruebas de conectividad en las primeras semanas; verificar semanalmente la integridad de las copias con restic check y ensayar restauraciones; controlar el
> crecimiento del repositorio con alertas por umbral; y documentar cada comando relevante para que cualquier cambio sea reproducible.

### Evaluación y priorización

| **Riesgo Identificado**                                  | **Probabilid ad** | **Impacto** | **Medida de Mitigación / Prevención**                               |
|----------------------------------------------------------|-------------------|-------------|---------------------------------------------------------------------|
| **Incompatibilidad entre versiones de contenedores**     | Media             | Alto        | Fijar versiones exactas en docker-compose.yml                       |
| **Fallo de conectividad entre sistemas Linux y Windows** | Media             | Alto        | Pruebas de conectividad y scripts en fases tempranas                |
| **Errores de permisos en directorios compartidos**       | Alta              | Medio       | Configurar permisos chmod, ACL y mapeos de volúmenes                |
| **Fallos en ejecución de Webhooks en producción**        | Alta              | Alto        | Validar URLs de producción y ajustar variables de entorno           |
| **Compromiso de credenciales del repositorio**           | Media             | Alto        | Modo append-only, claves independientes del dominio y copia offline |
| **Copias corruptas no detectadas**                       | Media             | Alto        | restic check periódico y ensayo de restauración semanal             |
| **Agotamiento de espacio en la bóveda**                  | Media             | Medio       | Alertas al 80 % de uso y poda controlada desde la propia bóveda     |
| **Falsos positivos de ficheros canario**                 | Alta              | Bajo        | Ventanas de mantenimiento y lista de procesos permitidos            |
| **Bloqueo de la VPN por CGNAT o filtrado**               | Media             | Medio       | Puerto UDP alternativo o salto por bastión con IP pública           |

### Medidas preventivas

- Copia de seguridad previa (snapshot de la máquina virtual) antes de cada cambio relevante.

- Entorno de pruebas separado del entorno de laboratorio principal para validar actualizaciones.

- Documentación de comandos y de la configuración en un repositorio de control de versiones.

- Secretos en un fichero .env con permisos 600, fuera del repositorio de código.

- Revisión de reglas del cortafuegos tras cada modificación con una prueba de conectividad permitida y otra denegada.

### Seguimiento y revisión

> La matriz de riesgos se revisó al cierre de cada semana, junto con el tutor en los hitos intermedios. Cada revisión podía cambiar la probabilidad o el impacto de un riesgo, añadir riesgos nuevos o cerrar los resueltos. Los cambios se anotaban con fecha en el cuaderno de proyecto y, cuando afectaban al diseño, en el apartado 4.3.

## Revisión de recursos

> Se compararon los recursos consumidos con las estimaciones del apartado 2.2.2. Como criterio, se consideran aceptables las desviaciones inferiores al 20 %. Los puntos de control definidos son: memoria real de cada máquina virtual tras una semana de uso, ocupación del disco de la bóveda con las políticas de retención aplicadas, consumo de CPU durante la ventana de copia y ancho de banda empleado por la copia inicial y por las incrementales.
> Previsiblemente, el mayor ajuste se producirá en la bóveda: la copia inicial ocupará el volumen completo de datos deduplicado y comprimido, y las incrementales diarias serán pequeñas. Si la tasa de cambio supera la prevista, deberá ampliarse el disco antes de modificar la retención. Los valores finales medidos se anotarán en la tabla siguiente.

| **Recurso**                              | **Estimación inicial**          | **Valor final medido**         |
|------------------------------------------|---------------------------------|--------------------------------|
| **RAM srv-svc01 (en reposo)**            | Menor de 3 GB de 8 GB asignados | *\[ completar con medición \]* |
| **Disco bóveda tras 30 días**            | Menor del 60 % de 300 GB        | *\[ completar con medición \]* |
| **Duración de copia incremental diaria** | Menor de 15 minutos             | *\[ completar con medición \]* |
| **Ancho de banda copia inicial**         | Menor de 1 Gbps en red virtual  | *\[ completar con medición \]* |

## Documentación de ejecución

### Infraestructura desplegada

> El entorno final se compone de un anfitrión que ejecuta cuatro máquinas virtuales de servidor y un cliente de pruebas:

- **srv-dc01 (198.51.100.10):** Windows Server 2022, dominio coal.lab.

- **srv-docs01 (198.51.100.30):** Ubuntu Server con Samba; contiene el recurso de expedientes con documentación de ejemplo no real.

- **srv-svc01 (198.51.100.20):** Ubuntu Server con Docker. Contenedores: nginx, n8n, postgres y grafana; además WireGuard, Squid y Fail2ban en el sistema anfitrión.

- **srv-vault01 (203.0.113.10):** Ubuntu Server en la red aislada con rest-server y snapshots.

- **cli-win01:** cliente Windows unido al dominio para las pruebas de usuario.

> Los datos del laboratorio son ficticios; no se utiliza ningún dato personal real del COAL ni de sus colegiados.

### Despliegue de PostgreSQL

> PostgreSQL se ejecuta en un contenedor sobre la red data_net, con volumen persistente y credenciales leídas desde el fichero .env. El fichero docker-compose.yml completo de la pila es el siguiente:
> \# /opt/resiliencia/docker-compose.yml services:
> postgres:
> image: postgres:16.4-alpine restart: unless-stopped environment:
> POSTGRES_DB: resiliencia POSTGRES_USER: \${PG_ADMIN_USER} POSTGRES_PASSWORD: \${PG_ADMIN_PASS}
> volumes:

- pgdata:/var/lib/postgresql/data

- ./initdb:/docker-entrypoint-initdb.d:ro networks: \[data_net\]

> n8n:
> image: n8nio/n8n:1.64.0 restart: unless-stopped environment:
> DB_TYPE: postgresdb DB_POSTGRESDB_HOST: postgres DB_POSTGRESDB_DATABASE: resiliencia DB_POSTGRESDB_USER: \${PG_N8N_USER} DB_POSTGRESDB_PASSWORD: \${PG_N8N_PASS} N8N_ENCRYPTION_KEY: \${N8N_KEY}
> WEBHOOK_URL: <http://198.51.100.20:5678/>
> N8N_SECURE_COOKIE: "false" \# solo laboratorio sin HTTPS
> GENERIC_TIMEZONE: Europe/Madrid ports: \["5678:5678"\]
> volumes:

- n8ndata:/home/node/.n8n depends_on: \[postgres\] networks: \[app_net, data_net\]

> nginx:
> image: nginx:1.27.1-alpine restart: unless-stopped ports: \["8080:80"\]
> volumes:

- ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro

- ./web:/usr/share/nginx/html:ro networks: \[app_net\]

> grafana:
> image: grafana/grafana-oss:11.2.0 restart: unless-stopped environment:
> GF_SECURITY_ADMIN_PASSWORD: \${GF_ADMIN_PASS} ports: \["3000:3000"\]
> volumes:

- grafdata:/var/lib/grafana depends_on: \[postgres\] networks: \[app_net, data_net\]

> networks: app_net: {} data_net:
> internal: true
> volumes: pgdata: {} n8ndata: {} grafdata: {}
> Las versiones de las imágenes se fijan a las etiquetas indicadas; deben comprobarse y actualizarse a versiones soportadas en el momento del despliegue. La estructura SQL de las tablas de trazabilidad es la siguiente:
> -- initdb/01_schema.sql CREATE TABLE sistemas (
> id SERIAL PRIMARY KEY,
> nombre VARCHAR(60) UNIQUE NOT NULL, ip INET NOT NULL,
> rol VARCHAR(80),
> criticidad SMALLINT CHECK (criticidad BETWEEN 1 AND 4), rto_horas SMALLINT,
> rpo_horas SMALLINT
> );
> CREATE TABLE copias (
> id BIGSERIAL PRIMARY KEY,
> sistema_id INT REFERENCES sistemas(id), snapshot_id VARCHAR(64) UNIQUE NOT NULL, inicio TIMESTAMPTZ NOT NULL,
> fin TIMESTAMPTZ,
> bytes_nuevos BIGINT,
> estado VARCHAR(12) CHECK (estado IN ('OK','FALLIDA','VERIFICADA')),
> verificada_en TIMESTAMPTZ
> );
> CREATE TABLE incidentes (
> id BIGSERIAL PRIMARY KEY,
> huella CHAR(64) UNIQUE NOT NULL, -- evita duplicados sistema_id INT REFERENCES sistemas(id),
> tipo VARCHAR(40) NOT NULL,
> gravedad CHAR(2) CHECK (gravedad IN ('N1','N2','N3','N4')),
> detectado_en TIMESTAMPTZ DEFAULT now(), estado VARCHAR(12) DEFAULT 'ABIERTO',
> descripcion TEXT
> );
> CREATE TABLE restauraciones (
> id BIGSERIAL PRIMARY KEY,
> incidente_id BIGINT REFERENCES incidentes(id), snapshot_id VARCHAR(64) REFERENCES copias(snapshot_id), destino VARCHAR(60) NOT NULL,
> solicitada_por VARCHAR(80) NOT NULL, inicio TIMESTAMPTZ DEFAULT now(), fin TIMESTAMPTZ,
> estado VARCHAR(12) DEFAULT 'EN_CURSO'
> CHECK (estado IN ('EN_CURSO','EXITOSA','FALLIDA','REVERTIDA'))
> );
> CREATE TABLE logs_workflow (
> id BIGSERIAL PRIMARY KEY, workflow VARCHAR(60) NOT NULL, nodo VARCHAR(60),
> nivel VARCHAR(8) CHECK (nivel IN ('INFO','WARN','ERROR')),
> mensaje TEXT,
> creado_en TIMESTAMPTZ DEFAULT now()
> );
> -- (el rol grafana_ro se crea en initdb/02_roles.sh con la contraseña del .env)
> GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafana_ro;
> Nota: la contraseña del rol grafana_ro es un valor de ejemplo; en el despliegue real debe sustituirse por una contraseña aleatoria gestionada desde el fichero .env.

### Despliegue y configuración de n8n

> n8n se despliega con persistencia en el volumen n8ndata, que conserva credenciales cifradas, workflows y configuración. Los puntos clave de la configuración son:

- **Variables de entorno:** clave de cifrado de credenciales (N8N_ENCRYPTION_KEY) generada aleatoriamente y respaldada fuera de línea; WEBHOOK_URL con la dirección de producción; zona horaria Europe/Madrid.

- **Credenciales:** conexión a PostgreSQL con rol de escritura limitada, SMTP para correo, clave SSH dedicada para ejecutar la restauración en destino y credencial de lectura del repositorio restic.

- **Mapeo de rutas:** cuando un workflow necesita ejecutar ficheros del anfitrión se monta un volumen de solo lectura con los scripts de restauración y se restringe su alcance.

- **Workflows:** (1) Recepción de alertas por webhook; (2) Registro de copias; (3) Clasificación y notificación; (4) Restauración con verificación; (5) Rollback mediante Error Trigger.

### Despliegue de Nginx

> Nginx publica el formulario de comunicación de incidencias y la página informativa. Reenvía el envío del formulario al webhook de n8n y aplica una limitación de peticiones.
> \# nginx/default.conf
> limit_req_zone \$binary_remote_addr zone=form:10m rate=5r/m;
> server {
> listen 80; server_name \_; server_tokens off;
> root /usr/share/nginx/html; index index.html;
> add_header X-Content-Type-Options nosniff always; add_header X-Frame-Options DENY always;
> location /enviar {
> limit_req zone=form burst=5 nodelay; proxy_pass <http://n8n:5678/webhook/incidencia>; proxy_set_header X-Real-IP \$remote_addr;
> }
> }

### Despliegue de Grafana y monitorización

### 

> Se añade un Data Source de tipo PostgreSQL apuntando al host postgres, base resiliencia y el rol de solo lectura grafana_ro. Se crean cuatro paneles:

- **Estado de copias:** última copia correcta por sistema y antigüedad en horas, con umbral rojo a partir de 26 horas.

- **Crecimiento del repositorio:** bytes nuevos por día y proyección de agotamiento del disco.

- **Incidentes:** abiertos por gravedad y tiempo medio de resolución.

- **Restauraciones:** histórico de pruebas de restauración con duración y resultado, para demostrar el cumplimiento del RTO.

> -- Ejemplo de consulta del panel "Estado de copias" SELECT s.nombre,
> max(c.fin) AS ultima_ok,
> round(extract(epoch FROM (now() - max(c.fin)))/3600, 1) AS horas FROM sistemas s
> LEFT JOIN copias c ON c.sistema_id = s.id AND c.estado IN ('OK','VERIFICADA') GROUP BY s.nombre
> ORDER BY horas DESC;

### Configuración de WireGuard (VPN)

> WireGuard se instala en srv-svc01 y es el único camino para el acceso administrativo remoto. El túnel usa la red 192.0.2.0/24 y un par de claves por administrador.
> \# /etc/wireguard/wg0.conf (servidor) \[Interface\]
> Address = 192.0.2.1/24 ListenPort = 51820
> PrivateKey = (clave generada con wg genkey; solo en el servidor)
> PostUp = iptables -A FORWARD -i wg0 -o ens18 -j ACCEPT PostDown = iptables -D FORWARD -i wg0 -o ens18 -j ACCEPT
> \[Peer\] \# administrador 1 PublicKey = (clave pública del administrador 1) AllowedIPs = 192.0.2.2/32
> Las claves se generan con wg genkey y wg pubkey; las claves privadas no se almacenan en el repositorio. El acceso por SSH a los servidores solo se permite desde 192.0.2.0/24.

### Configuración de Squid (proxy)

> Squid controla la salida de los servidores a Internet. La política es de denegación por defecto con una lista blanca de destinos de actualización.
> \# /etc/squid/squid.conf (extracto) acl lan src 198.51.100.0/24
> acl SSL_ports port 443
> acl Safe_ports port 80 443 acl CONNECT method CONNECT
> acl destinos_ok dstdomain "/etc/squid/destinos_permitidos.txt" acl bloqueados dstdomain "/etc/squid/bloqueados.txt"
> http_access deny !Safe_ports http_access deny CONNECT !SSL_ports http_access deny bloqueados http_access allow lan destinos_ok http_access deny all
> http_port 3128
> access_log /var/log/squid/access.log squid

### Configuración de Fail2ban

> \# /etc/fail2ban/jail.local \[DEFAULT\]
> bantime = 1h findtime = 10m maxretry = 4
> ignoreip = 127.0.0.1/8 192.0.2.0/24
> \[sshd\]
> enabled = true
> \[nginx-http-auth\] enabled = true
> logpath = /var/log/nginx/error.log
> \[recidive\] enabled = true bantime = 1w findtime = 1d maxretry = 3
> La jaula recidive amplía el bloqueo a una semana para las IP reincidentes. Los bloqueos se consultan con fail2ban-client status y se reportan en el panel de Grafana mediante un workflow de n8n que registra los eventos relevantes.

### Configuración de Samba

> Samba expone el recurso de expedientes con autenticación de dominio, cifrado SMB3 y acceso por grupos. Se desactiva el acceso anónimo y los protocolos antiguos.
> \# /etc/samba/smb.conf (extracto) \[global\]
> workgroup = COAL security = ads realm = COAL.LAB
> server min protocol = SMB3 restrict anonymous = 2
> map to guest = never
> log file = /var/log/samba/log.%m
> \[Expedientes\]
> path = /srv/expedientes read only = no
> valid users = @"COAL\arquitectos" create mask = 0660
> directory mask = 0770 hide unreadable = yes smb encrypt = desired
> Los permisos del sistema de ficheros se completan con ACL por grupo. En /srv/expedientes/\_canario se colocan ficheros señuelo vigilados por un servicio de inotify que avisa a n8n cuando son modificados, renombrados o borrados.

## Manuales

### Manual de usuario

#### Dirigido a personal del Colegio y a técnicos de soporte de primer nivel.

> **Cómo comunicar una incidencia**

- Acceder a [http://198.51.100.20:8080](http://198.51.100.20:8080/) desde la red del Colegio o por VPN.

- Rellenar el formulario: nombre, equipo afectado, hora aproximada y descripción de lo ocurrido (por ejemplo, ficheros que no se abren o extensiones desconocidas).

- Enviar. El sistema devuelve un número de incidencia; anótelo y comuníquelo al técnico de soporte.

#### Qué hacer ante un posible cifrado de ficheros o una nota de rescate

- Desconecte el equipo de la red (cable o wifi), pero no lo apague si no se lo indica el técnico.

- No pague ni responda a ningún mensaje de los atacantes y no abra más archivos.

- No intente borrar ni renombrar ficheros.

- Avise de inmediato al responsable de sistemas y rellene el formulario desde otro equipo o por teléfono.

#### Solicitar la recuperación de un fichero

- En el formulario seleccione Recuperación de fichero e indique ruta y fecha aproximada de la versión que necesita.

- El técnico de soporte lo gestiona y le informa del resultado; la recuperación se realiza sobre una carpeta aparte para no sobrescribir su versión actual.

#### Unir un equipo al dominio

- Compruebe que el equipo recibe la DNS 198.51.100.10 y que hay conectividad con el dominio.

- Configuración, Cuentas, Acceso a trabajo o escuela: Conectar, y elegir Unir este dispositivo a un dominio de Active Directory local.

- Introduzca el dominio coal.lab y las credenciales de un administrador delegado, reinicie e inicie sesión con su usuario.

#### Preguntas frecuentes

- **¿Por qué no puedo borrar copias antiguas?** Porque son inmutables a propósito; solo el administrador de la bóveda puede podarlas según la política.

- **¿Cuánto tarda una recuperación?** El objetivo para servicios críticos es de 4 horas; un fichero individual suele ser mucho más rápido.

- **¿Quién ve mis datos en el formulario?** Solo el personal de sistemas; los datos se guardan en la base de datos interna.

### Manual de instalación

> Guía para reconstruir el entorno desde cero, en el orden indicado.

#### Paso 1. Requisitos iniciales

- Anfitrión con virtualización activada en BIOS y el hipervisor instalado.

- Redes virtuales: lan-corp (198.51.100.0/24), vault-net (203.0.113.0/24, sin puerta de enlace) y salida NAT solo para srv-svc01.

- Imágenes de Windows Server 2022 y Ubuntu Server 24.04 LTS.

#### Paso 2. Máquinas virtuales y dominio

- Crear las VM con los recursos del apartado 2.2.2 y asignar las IP fijas del apartado 2.4.4.

- En srv-dc01 instalar AD DS y promover el controlador a un nuevo bosque coal.lab; crear el grupo arquitectos y usuarios de prueba.

- En srv-docs01 unirse al dominio con realm join e instalar Samba según el apartado 3.4.9.

#### Paso 3. Bóveda de copias

> \# En srv-vault01
> sudo apt install -y restic btrfs-progs ufw sudo useradd -r -m -d /srv/restic restic
> sudo -u restic htpasswd -B -c /srv/restic/.htpasswd srv-docs01 sudo -u restic htpasswd -B /srv/restic/.htpasswd srv-dc01
> sudo -u restic htpasswd -B /srv/restic/.htpasswd srv-svc01
> \# Servicio (unidad systemd) con ExecStart:
> rest-server --path /srv/restic --append-only --private-repos \\
> --htpasswd-file /srv/restic/.htpasswd --listen :8000
> \# Cortafuegos: solo 3 orígenes al puerto 8000 sudo ufw default deny incoming
> sudo ufw allow from 198.51.100.10 to any port 8000 proto tcp sudo ufw allow from 198.51.100.20 to any port 8000 proto tcp sudo ufw allow from 198.51.100.30 to any port 8000 proto tcp sudo ufw enable

#### Paso 4. Primera copia desde cada cliente

> \# En srv-docs01 (Linux)
> export RESTIC_REPOSITORY=rest:http://srv-docs01:${RESTIC_HTTP_PASS}@203.0.113.10:8000/srv-docs01 export RESTIC_PASSWORD_FILE=/root/.restic_pass
> restic init
> restic backup /srv/expedientes --tag diaria
> \# En srv-dc01 (Windows, PowerShell como administrador) wbadmin start systemstatebackup -backupTarget:D: -quiet
> restic backup D:\WindowsImageBackup C:\Windows\SYSVOL --use-fs-snapshot
> La copia diaria se programa con un temporizador de systemd en Linux y con el Programador de tareas en Windows. Las credenciales reales se almacenan fuera del repositorio de código.

#### Paso 5. Pila de servicios

- Instalar Docker Engine y el plugin Compose en srv-svc01.

- Copiar a /opt/resiliencia el docker-compose.yml, la carpeta initdb, la configuración de Nginx y el fichero

> .env (permisos 600).

- Ejecutar docker compose up -d y comprobar con docker compose ps que los cuatro servicios están en marcha.

#### Paso 6. Acceso y protección

- Instalar y configurar WireGuard, Squid y Fail2ban con los ficheros de los apartados 3.4.6 a 3.4.8.

- Aplicar reglas de ufw en srv-svc01: abrir 8080, 3000 y 5678 solo hacia la LAN y 51820/UDP hacia el exterior, y limitar SSH a 192.0.2.0/24.

#### Paso 7. Verificación de la instalación

- Comprobar desde un cliente comprometido simulado que no puede borrar copias anteriores: la operación forget o prune debe ser rechazada.

- Importar los workflows de n8n y comprobar con una petición de prueba que el incidente llega a PostgreSQL y a Grafana.

### Manual de configuración y administración

#### Dirigido al administrador de sistemas.

> **Tareas diarias**

- Revisar el panel Estado de copias de Grafana: todas las copias con menos de 26 horas.

- Revisar incidentes abiertos y alertas de Fail2ban.

- Confirmar que los servicios de la pila están levantados (docker compose ps).

#### Tareas semanales

- Ejecutar restic check en cada repositorio y restic restore de un conjunto aleatorio de ficheros a un destino limpio, comparando sumas de control.

- Rotar el disco USB offline: conectar, sincronizar la última instantánea, desconectar y guardar en un lugar distinto.

- Revisar el uso del disco de la bóveda y las alertas de crecimiento.

#### Tareas mensuales

- Simulacro completo de recuperación del servidor de ficheros y del controlador de dominio en un entorno limpio, cronometrado y registrado en la tabla restauraciones.

- Actualizar las imágenes de contenedor tras probarlas en el entorno de pruebas y aplicar parches de sistema.

- Revisar cuentas privilegiadas y rotar las credenciales del repositorio si procede.

#### Gestión de copias de seguridad y poda

> La poda se realiza únicamente desde la propia bóveda con una cuenta administrativa local que no está accesible desde la LAN:
> \# En srv-vault01, con acceso local
> restic -r /srv/restic/srv-docs01 forget --keep-daily 14 --keep-weekly 8 \\
> --keep-monthly 12 --prune
> restic -r /srv/restic/srv-docs01 check --read-data-subset=10%

#### Copia de la base de datos de trazabilidad

> docker exec postgres pg_dump -U \$PG_ADMIN_USER -Fc resiliencia \\
> \> /var/backups/resiliencia\_\$(date +%F).dump restic backup /var/backups --tag bbdd

#### Niveles de escalado de incidencias

| **Nivel** | **Responsable**                              | **Ámbito**                                                                |
|-----------|----------------------------------------------|---------------------------------------------------------------------------|
| **N1**    | Soporte de primer nivel                      | Recepción, clasificación inicial y contención básica                      |
| **N2**    | Administrador de sistemas                    | Diagnóstico, restauraciones y cambios de configuración                    |
| **N3**    | Responsable de seguridad / proveedor externo | Respuesta a incidentes graves, análisis forense, contacto con INCIBE      |
| **N4**    | Dirección y delegado de protección de datos  | Decisiones de continuidad, notificación a AEPD y comunicación a afectados |

# Seguimiento y control

> Este capítulo evalúa el cumplimiento global del proyecto: valoración de objetivos, incidencias, cambios respecto al diseño y pruebas de soporte.

## Valoración del proyecto

> La tabla recoge los indicadores definidos en el diseño y su criterio de aceptación. La columna de estado debe actualizarse con el resultado de las pruebas reales del laboratorio.

<table>
<colgroup>
<col style="width: 32%" />
<col style="width: 35%" />
<col style="width: 32%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Indicador de Calidad / Funcionalidad</strong></th>
<th><strong>Estado / Resultado</strong></th>
<th><strong>Observaciones Técnicas</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>Copias aisladas e inmutables</strong></td>
<td><em>[ Validar: un cliente comprometido no puede borrar copias ]</em></td>
<td>rest-server append-only y snapshots en bóveda</td>
</tr>
<tr class="even">
<td><strong>Política 3-2-1-1-0 y retención</strong></td>
<td><em>[ Validar: tres copias, dos medios, una offline ]</em></td>
<td>restic, USB offline semanal</td>
</tr>
<tr class="odd">
<td><strong>Detección temprana de cifrado masivo</strong></td>
<td><em>[ Validar: alerta en menos de 5 minutos ]</em></td>
<td>Ficheros canario y anomalías de tamaño</td>
</tr>
<tr class="even">
<td><strong>Automatización de alertas e incidentes</strong></td>
<td><p><em>[ Validar: incidente registrado y notificado</em></p>
<p><em>]</em></p></td>
<td>Webhooks y workflows de n8n</td>
</tr>
<tr class="odd">
<td><strong>Integración AD, Samba y base de datos</strong></td>
<td><em>[ Validar ]</em></td>
<td>Copia de SYSVOL y System State, PostgreSQL</td>
</tr>
<tr class="even">
<td><strong>Mecanismo de rollback y control de errores</strong></td>
<td><em>[ Validar: fallo forzado revierte el destino ]</em></td>
<td>Snapshot previo y Error Trigger</td>
</tr>
<tr class="odd">
<td><strong>Paneles de monitorización y logs</strong></td>
<td><em>[ Validar: reflejo en tiempo casi real ]</em></td>
<td>Grafana sobre PostgreSQL</td>
</tr>
<tr class="even">
<td><strong>Acceso remoto seguro (VPN)</strong></td>
<td><em>[ Validar desde red externa ]</em></td>
<td>WireGuard</td>
</tr>
</tbody>
</table>

| **Indicador de Calidad / Funcionalidad**     | **Estado / Resultado**                | **Observaciones Técnicas**     |
|----------------------------------------------|---------------------------------------|--------------------------------|
| **Cumplimiento de RTO de 4 h y RPO de 24 h** | *\[ Completar con tiempos medidos \]* | Simulacro mensual cronometrado |

## Incidencias

> Se describen las incidencias técnicas más relevantes de este tipo de despliegue, su causa raíz y la solución adoptada. Si alguna no ocurrió durante la ejecución real, debe retirarse o sustituirse por las incidencias efectivamente registradas.

### Rutas y permisos en n8n

> **Problema:** los workflows que ejecutan scripts de restauración o escriben carpetas temporales fallaban con errores de permiso denegado. **Causa raíz:** el contenedor de n8n se ejecuta con un usuario sin privilegios (UID 1000) y los volúmenes montados pertenecían a root. **Solución:** se ajustó el propietario de los directorios compartidos con chown al UID del contenedor, se limitaron los permisos a 750, se montaron los scripts como solo lectura y se mantuvo la restauración real en el destino mediante SSH en lugar de dentro del contenedor.

### Webhooks de n8n en modo producción

> **Problema:** el formulario funcionaba con la URL de prueba, pero dejaba de funcionar al activar el workflow. **Causa raíz:** n8n distingue entre la URL de prueba (webhook-test) y la de producción (webhook), y la variable WEBHOOK_URL no coincidía con la dirección real tras el proxy. **Solución:** se activó el workflow, se utilizó la URL de producción en Nginx y se fijó WEBHOOK_URL con la dirección definitiva.

### Restricción de correos duplicados en PostgreSQL

> **Problema:** una avalancha de eventos idénticos (por ejemplo, cientos de ficheros canario modificados en segundos) generaba cientos de incidentes duplicados y de correos. **Causa raíz:** cada evento creaba un incidente. **Solución:** se añadió la columna huella con restricción UNIQUE; el workflow usa INSERT con ON CONFLICT DO NOTHING y, si detecta conflicto, sigue una rama alternativa que solo incrementa el contador del incidente existente y envía una única notificación consolidada.

### Conectividad VPN con WireGuard

> **Problema:** desde algunas redes externas no era posible establecer el túnel. **Causa raíz:** bloqueo del puerto UDP 51820 o ausencia de IP pública directa por CGNAT del operador. **Alternativas contempladas:** cambiar a un puerto UDP habitual (por ejemplo, 443), solicitar una IP pública al operador, o utilizar un bastión con IP pública que reenvíe el tráfico al servidor. Se documentó el procedimiento y se priorizó el cambio de puerto por ser el de menor coste.

## Cambios

> Se enumeran los cambios respecto al diseño inicial y su justificación:

- **Poda desde la bóveda:** la poda automática desde los clientes se descartó, porque requiere permiso de borrado y contradice el modelo append-only; se realiza localmente en la bóveda.

- **Restauración por SSH:** se pasó de ejecutar la restauración dentro del contenedor n8n a lanzarla por SSH en el destino, para evitar privilegios excesivos del contenedor.

- **Huella de incidente:** se añadió para controlar la duplicidad de eventos (apartado 4.2.3).

- **Ficheros canario:** se incorporaron al diseño como detección complementaria, tras comprobar que el control del tamaño de la copia solo detecta el cifrado cuando ya se ha ejecutado una copia.

- **Copia offline:** se añadió una rotación semanal en USB para cubrir el supuesto de compromiso de la propia bóveda.

## Pruebas y soporte

### Pruebas funcionales realizadas

> El plan de pruebas se estructura en los siguientes bloques; para cada una debe anotarse fecha, resultado y evidencia (captura o registro).

| **Prueba**                     | **Procedimiento**                                         | **Resultado esperado**                                    |
|--------------------------------|-----------------------------------------------------------|-----------------------------------------------------------|
| **P1. Contenedores**           | docker compose ps y comprobación de salud                 | Los cuatro servicios en estado running                    |
| **P2. Segmentación Docker**    | Intentar conectar a PostgreSQL desde la LAN y desde nginx | Conexión rechazada; solo n8n y Grafana acceden            |
| **P3. Formulario web**         | Enviar un formulario de prueba                            | Incidente registrado en PostgreSQL y notificación enviada |
| **P4. Duplicados**             | Enviar el mismo evento 50 veces                           | Un único incidente con contador actualizado               |
| **P5. Copia y verificación**   | Ejecutar copia y restic check                             | Copia OK registrada y marcada como verificada             |
| **P6. Inmutabilidad**          | Desde srv-docs01 intentar forget y prune                  | Operación denegada; copias intactas                       |
| **P7. Detección canario**      | Modificar un fichero canario en un entorno controlado     | Alerta N1 en menos de 5 minutos y reflejo en Grafana      |
| **P8. Restauración**           | Restaurar un snapshot en destino limpio                   | Verificación OK y registro EXITOSA; tiempo medido         |
| **P9. Rollback**               | Forzar un fallo de verificación durante la restauración   | Destino revertido, registro REVERTIDA y notificación      |
| **P10. Acceso remoto**         | Conectar por WireGuard y por SSH                          | Acceso correcto; SSH denegado fuera de la VPN             |
| **P11. Fail2ban**              | Cinco intentos de SSH fallidos                            | IP bloqueada y registro en el log                         |
| **P12. Simulacro de desastre** | Reconstruir srv-docs01 y srv-dc01 desde la bóveda         | Servicios operativos dentro del RTO de 4 horas            |

> **Aviso de seguridad para las pruebas P7 a P12:** la simulación de cifrado se debe realizar únicamente en el laboratorio aislado y sobre datos ficticios, con herramientas de emulación de adversario reconocidas y controladas o con modificación manual de los ficheros señuelo. No debe ejecutarse sobre sistemas de producción ni sobre redes reales.

### Acuerdo de servicio (SLA)

| **Nivel**      | **Descripción**                                                              | **Tiempo de respuesta** | **Objetivo de resolución** |
|----------------|------------------------------------------------------------------------------|-------------------------|----------------------------|
| **N1 Crítico** | Cifrado activo, caída total de servicios críticos o sospecha de exfiltración | 30 minutos              | 4 horas (RTO)              |
| **N2 Alto**    | Fallo de copia en sistema crítico o alerta de intrusión sin impacto          | 1 hora                  | 8 horas                    |
| **N3 Medio**   | Degradación parcial, fallo de verificación aislado                           | 4 horas laborables      | 2 días laborables          |
| **N4 Bajo**    | Consultas, mejoras y solicitudes de recuperación de ficheros                 | 1 día laborable         | 5 días laborables          |

> **Disponibilidad objetivo:** 99,5 % en horario laboral para los servicios de la plataforma de resiliencia. **RPO objetivo:** 24 horas para ficheros y servicios de dominio y 24 horas para la base de datos. **Política de copias:** copia diaria incremental, retención de 14 copias diarias, 8 semanales y 12 mensuales, verificación semanal y copia offline semanal. En caso de brecha de datos personales, el procedimiento incluye la notificación a la AEPD en un máximo de 72 horas desde que se tiene constancia.

# Bibliografía

> Agencia Española de Protección de Datos. (2021). *Guía para la gestión y notificación de brechas de datos personales*. [https://www.aepd.es](https://www.aepd.es/)
> Centro Criptológico Nacional. (s. f.). *Guías CCN-STIC y recomendaciones frente al ransomware*. [https://www.ccn-cert.cni.es](https://www.ccn-cert.cni.es/)
> Cybersecurity and Infrastructure Security Agency y FBI. (2023). *\#StopRansomware Guide*. <https://www.cisa.gov/stopransomware>
> Dexpose. (2026, 2 de octubre). *Akira ransomware attack on The Official College of Architects of León*. <https://www.dexpose.io/akira-ransomware-attack-on-the-official-college-of-architects-of-leon/>
> Docker Inc. (s. f.). *Docker Documentation*. [https://docs.docker.com](https://docs.docker.com/)
> Fail2ban. (s. f.). *Fail2ban documentation*. <https://github.com/fail2ban/fail2ban> Grafana Labs. (s. f.). *Grafana documentation*. <https://grafana.com/docs/>
> Heraldo de León. (2026, 2 de octubre). *Los ciberdelincuentes secuestran el Colegio de Arquitectos de León, encriptan toda su información, paran su actividad y piden un 'millonario' rescate*. [https://www.heraldodeleon.es](https://www.heraldodeleon.es/)
> Heraldo de León. (2026, 3 de octubre; actualizado el 4 de octubre). *Otro ciberataque en León 'secuestra' más de 250 comunidades de vecinos al bloquear los datos de una de las mayores gestoras de toda la ciudad*. [https://www.heraldodeleon.es/leon/ciberataque-leon-secuestra-mas-250-comunidades-vecino s-bloquear-datos-mayores-gestoras-ciudad/20261003092138111190.html](https://www.heraldodeleon.es/leon/ciberataque-leon-secuestra-mas-250-comunidades-vecinos-bloquear-datos-mayores-gestoras-ciudad/20261003092138111190.html)
> INCIBE. (s. f.). *Instituto Nacional de Ciberseguridad: recursos para empresas y respuesta a incidentes*. [https://www.incibe.es](https://www.incibe.es/)
> Ley 31/1995, de 8 de noviembre, de Prevención de Riesgos Laborales. Boletín Oficial del Estado.
> Ley Orgánica 3/2018, de 5 de diciembre, de Protección de Datos Personales y garantía de los derechos digitales. Boletín Oficial del Estado.
> Microsoft. (s. f.). *Windows Server documentation*. <https://learn.microsoft.com/windows-server/> n8n. (s. f.). *n8n documentation*. [https://docs.n8n.io](https://docs.n8n.io/)
> National Institute of Standards and Technology. (2012). *Computer Security Incident Handling Guide* (NIST SP 800-61 Rev. 2).
> National Institute of Standards and Technology. (2024). *The NIST Cybersecurity Framework (CSF) 2.0*.
> PostgreSQL Global Development Group. (s. f.). *PostgreSQL documentation*. <https://www.postgresql.org/docs/>
> Real Decreto 311/2022, de 3 de mayo, por el que se regula el Esquema Nacional de Seguridad. Boletín Oficial del Estado.
> Real Decreto 488/1997, de 14 de abril, sobre disposiciones mínimas de seguridad y salud relativas al trabajo con equipos que incluyen pantallas de visualización. Boletín Oficial del Estado.
> Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo, de 27 de abril de 2016 (RGPD). Diario Oficial de la Unión Europea.
> restic. (s. f.). *restic documentation*. [https://restic.readthedocs.io](https://restic.readthedocs.io/)
> Samba Team. (s. f.). *Samba documentation*. <https://www.samba.org/samba/docs/> Squid Cache. (s. f.). *Squid documentation*. <http://www.squid-cache.org/Doc/>
> WireGuard. (s. f.). *WireGuard: fast, modern, secure VPN tunnel*. [https://www.wireguard.com](https://www.wireguard.com/)

# Conclusión

> El ataque de ransomware sufrido por el Colegio Oficial de Arquitectos de León en octubre de 2026 es un ejemplo cercano y todavía abierto de un problema general: las organizaciones medianas dependen de sistemas cuya recuperación no se ha ensayado. Este proyecto ha propuesto una respuesta técnica y organizativa basada en un principio simple: las copias deben sobrevivir al compromiso total del entorno que protegen.
> **Logros.** Se ha diseñado una arquitectura de cuatro capas con una bóveda aislada e inmutable, detección temprana mediante ficheros canario, automatización de incidentes y restauraciones con rollback, trazabilidad en base de datos y monitorización en Grafana, todo ello con software mayoritariamente abierto y un coste estimado de 5.590 euros. Se ha documentado su instalación, administración y operación mediante manuales y un SLA con objetivos de RTO y RPO.
> **Conocimientos consolidados.** El trabajo ha permitido consolidar competencias de virtualización, administración de dominios Active Directory, contenedores Docker y redes segmentadas, automatización con n8n, bases de datos relacionales, copias de seguridad cifradas, VPN y endurecimiento de servicios, así como el marco normativo de protección de datos y notificación de brechas.
> **Valor de la solución.** El valor no reside en una herramienta concreta sino en la combinación de aislamiento, verificación periódica y procedimiento ensayado. Una copia que nunca se ha restaurado no es una garantía; por eso el simulacro mensual cronometrado forma parte central del diseño.
> **Limitaciones.** El laboratorio no reproduce la infraestructura real del COAL, que no es pública, ni cubre la prevención del acceso inicial ni el análisis forense. Los valores de resultado marcados en los capítulos 3 y 4 deben completarse con las mediciones reales.
> **Líneas de ampliación.** Como mejoras futuras se proponen la segmentación avanzada de la red y la autenticación multifactor para cuentas privilegiadas, un sistema de detección en el endpoint con correlación de eventos (EDR/SIEM), el almacenamiento inmutable de objetos (object lock) en un proveedor externo, la automatización completa de la reconstrucción del dominio y la formación periódica del personal ante phishing.
