M_0378 — Seguridad Informática y Alta Disponibilidad

**Centro de Operaciones de Seguridad (SOC) Escolar**

**Sesión 1: Identificación y Clasificación de Amenazas**

*Informe inicial de clasificación de amenazas y catálogo de riesgos*

|                              |                                                              |
|------------------------------|--------------------------------------------------------------|
| **Alumno**                   | Fabrizio Victor Barrial Taipe                                |
| **Curso**                    | 2º ASIR — Curso 2026/2027                                    |
| **Actividad**                | A2 - RA 2 — Centro de Operaciones de Seguridad (SOC) Escolar |
| **Resultado de aprendizaje** | RA 2 — Implanta mecanismos de seguridad activa               |
| **Fecha de entrega**         | 26 de octubre de 2026                                        |

# 1. Introducción

## 1.1 Contexto del SOC escolar

Este documento es el entregable parcial de la **Sesión 1** de la actividad A2 - RA 2, «Centro de Operaciones de Seguridad (SOC) Escolar», del módulo de Seguridad Informática y Alta Disponibilidad. En la actividad, el grupo asume el papel de operadores y analistas de un SOC cuya misión es proteger la infraestructura TIC de un centro educativo: monitorizar, detectar, clasificar y responder ante incidentes.

Antes de monitorizar tráfico, analizar muestras o configurar antivirus, un SOC necesita un lenguaje común. Hay que saber qué activos se protegen, por dónde pueden llegar los ataques, cómo se llama cada tipo de incidente y qué prioridad tiene. Sin esa base, dos analistas pueden ver la misma alerta y tratarla de forma distinta. Esta primera sesión construye ese marco, que se reutilizará en el resto de la actividad.

## 1.2 Objetivos de la sesión

- Identificar los activos TIC críticos del centro y los vectores de ataque más habituales que pueden afectarlos.

- Clasificar las amenazas detectadas utilizando la taxonomía de referencia nacional publicada por INCIBE-CERT y CCN-CERT.

- Definir una taxonomía propia de incidentes para el SOC escolar, con niveles de severidad y tiempos de respuesta.

- Elaborar un catálogo de riesgos priorizado que sirva de punto de partida para las sesiones 2, 3 y 4.

## 1.3 Metodología y escenario de trabajo

La sesión se ha desarrollado con la metodología de **Aprendizaje Basado en Retos**, trabajando en grupo clase en el aula de informática. El proceso seguido ha sido el siguiente:

1.  Inventario de los activos TIC del centro y valoración de su criticidad.

2.  Análisis de vectores de ataque reales a partir de avisos y guías de INCIBE, OSI y CCN-CERT.

3.  Clasificación de las amenazas según la taxonomía de la Guía Nacional de Notificación y Gestión de Ciberincidentes.

4.  Diseño de la taxonomía y de los niveles de severidad del SOC escolar.

5.  Estimación del riesgo (probabilidad × impacto), siguiendo el enfoque de MAGERIT, y puesta en común.

Como escenario se ha tomado una **infraestructura de referencia** típica de un centro de FP: aulas de informática con equipos Windows 11 y Linux, un controlador de dominio con Active Directory, un servidor Linux de servicios, un NAS de copias de seguridad, la plataforma educativa (Moodle) y el correo corporativo en la nube, red Wi-Fi para alumnado, profesorado e invitados, y un router-cortafuegos perimetral.

# 2. Análisis de vectores de riesgo en infraestructuras TIC

## 2.1 Inventario de activos del centro

El primer paso ha sido identificar qué hay que proteger. La criticidad se ha valorado según el efecto que tendría su pérdida sobre la confidencialidad, la integridad y la disponibilidad, teniendo en cuenta que el centro trata **datos personales de alumnado, en muchos casos menores de edad**.

| **ID** | **Activo**                                                | **Función**                                          | **Criticidad** |
|--------|-----------------------------------------------------------|------------------------------------------------------|----------------|
| A-01   | Controlador de dominio (Windows Server, Active Directory) | Autenticación de usuarios, directivas de grupo (GPO) | Muy alta       |
| A-02   | Servidor Linux de servicios                               | DNS, DHCP y web interna                              | Alta           |
| A-03   | NAS de copias de seguridad                                | Copias de servidores y datos de secretaría           | Alta           |
| A-04   | Plataforma educativa (Moodle) y correo corporativo        | Entregas, calificaciones y comunicación              | Muy alta       |
| A-05   | Equipos de aula (Windows 11 / Linux)                      | Prácticas del alumnado                               | Media          |
| A-06   | Equipos de secretaría y dirección                         | Expedientes y datos personales                       | Muy alta       |
| A-07   | Red Wi-Fi (alumnado, profesorado, invitados)              | Acceso inalámbrico a la red                          | Media          |
| A-08   | Router-cortafuegos perimetral                             | Conexión a Internet y filtrado                       | Muy alta       |
| A-09   | Dispositivos IoT (impresoras, proyectores, cámaras IP)    | Servicios auxiliares                                 | Baja           |
| A-10   | Dispositivos personales (BYOD)                            | Portátiles y móviles de usuarios                     | Media          |

## 2.2 Vectores de ataque más comunes

A partir de los avisos y guías consultados se han identificado los vectores por los que una amenaza puede llegar a los activos anteriores. Se ha buscado para cada uno un ejemplo realista dentro de un centro educativo.

| **ID** | **Vector**                                         | **Ejemplo en el centro**                                                                 | **Activos**      |
|--------|----------------------------------------------------|------------------------------------------------------------------------------------------|------------------|
| V-01   | Correo electrónico (phishing, adjuntos maliciosos) | Correo que suplanta a Moodle avisando de un «bloqueo de cuenta» para robar la contraseña | A-04, A-06       |
| V-02   | Ingeniería social (teléfono o en persona)          | Llamada de un falso técnico que pide credenciales a secretaría                           | A-06, A-01       |
| V-03   | Medios extraíbles (USB)                            | Memoria USB infectada conectada en un equipo de aula                                     | A-05             |
| V-04   | Descargas y software no autorizado                 | Instalación de cracks, juegos o extensiones de navegador maliciosas                      | A-05, A-10       |
| V-05   | Credenciales débiles o reutilizadas                | Contraseñas por defecto o ataques de fuerza bruta contra RDP/SSH                         | A-01, A-02       |
| V-06   | Vulnerabilidades sin parchear                      | Moodle o plugins desactualizados, firmware antiguo en el router                          | A-04, A-08, A-09 |
| V-07   | Red inalámbrica                                    | Punto de acceso falso (rogue AP) o captura de tráfico en una red sin segmentar           | A-07             |
| V-08   | Servicios expuestos a Internet                     | Escritorio remoto o panel del NAS publicados sin VPN                                     | A-03, A-08       |
| V-09   | Amenaza interna                                    | Alumno que escanea la red o intenta modificar calificaciones                             | A-04, A-05       |
| V-10   | Cadena de suministro / terceros                    | Plugin o proveedor de software comprometido                                              | A-04             |
| V-11   | Acceso físico                                      | Equipo sin bloqueo de sesión o armario de red abierto                                    | A-01, A-08       |

La conclusión principal del análisis es que **el factor humano y las credenciales** están detrás de la mayoría de los vectores (V-01, V-02, V-05 y V-09). En un centro educativo esto se acentúa: hay muchos usuarios, con alta rotación cada curso y con niveles de formación en ciberseguridad muy distintos. El segundo bloque de riesgo son los **servicios expuestos y sin actualizar** (V-06 y V-08), que pueden permitir un ataque sin interacción del usuario.

# 3. Clasificación de amenazas según INCIBE y CCN-CERT

## 3.1 Taxonomía de referencia nacional

Para clasificar las amenazas se ha utilizado la taxonomía de la **Guía Nacional de Notificación y Gestión de Ciberincidentes**, documento común de INCIBE-CERT (sector privado y ciudadanía) y CCN-CERT (sector público). Usar la misma taxonomía que los CERT nacionales permite que, si el SOC escolar tuviera que notificar un incidente, lo haga en un lenguaje que ambos organismos entienden. La tabla resume sus clases principales:

| **Clasificación**            | **Tipos de incidente**                                                                              | **Qué describe**                              |
|------------------------------|-----------------------------------------------------------------------------------------------------|-----------------------------------------------|
| Contenido abusivo            | Spam, delito de odio, contenido sexual o violento inadecuado                                        | Contenido no deseado o ilícito                |
| Contenido dañino             | Sistema infectado, servidor C&C, distribución y configuración de malware                            | Presencia o propagación de código malicioso   |
| Obtención de información     | Escaneo de redes, análisis de paquetes (sniffing), ingeniería social                                | Reconocimiento previo a un ataque             |
| Intento de intrusión         | Explotación de vulnerabilidades conocidas, intento de acceso con credenciales, ataque desconocido   | Ataque que todavía no ha tenido éxito         |
| Intrusión                    | Compromiso de cuenta con o sin privilegios, compromiso de aplicaciones, robo                        | Acceso no autorizado conseguido               |
| Disponibilidad               | DoS, DDoS, mala configuración, sabotaje, interrupciones                                             | Pérdida o degradación del servicio            |
| Compromiso de la información | Acceso, modificación o pérdida no autorizada de datos                                               | Afecta a la confidencialidad o integridad     |
| Fraude                       | Uso no autorizado de recursos, derechos de autor, suplantación, phishing                            | Engaño o abuso con beneficio para el atacante |
| Vulnerable                   | Criptografía débil, servicios accesibles no deseados, revelación de información, sistema vulnerable | Debilidades aún no explotadas                 |
| Otros                        | Amenaza persistente avanzada (APT) e incidentes no clasificados                                     | Casos que no encajan en las anteriores        |

## 3.2 Criterios de peligrosidad e impacto

La Guía Nacional valora cada incidente con dos criterios independientes: la **peligrosidad** (lo dañina que es la amenaza en sí) y el **impacto** (el efecto real sobre la organización). Ambos usan una escala de Bajo a Crítico, y los incidentes de nivel Alto o superior son los que conllevan obligación de notificación para las entidades obligadas. Se ha adaptado la escala al contexto del centro:

| **Nivel**    | **Tipo de amenaza**                                      | **Ejemplos**                                                 |
|--------------|----------------------------------------------------------|--------------------------------------------------------------|
| **Crítico**  | Amenaza avanzada, dirigida y persistente                 | APT, sabotaje de infraestructura                             |
| **Muy alto** | Código dañino con capacidad destructiva o de propagación | Ransomware, robo masivo de datos                             |
| **Alto**     | Intrusión o fraude que compromete cuentas o datos        | Phishing con robo de credenciales, cuenta comprometida, DDoS |
| **Medio**    | Intentos de intrusión, malware aislado, uso indebido     | Fuerza bruta, troyano en un equipo, criptominería            |
| **Bajo**     | Actividad molesta o de reconocimiento                    | Spam, escaneo de puertos bloqueado                           |

|                 |                                                                                                  |
|-----------------|--------------------------------------------------------------------------------------------------|
| **Crítico**     | Paraliza el centro (sin plataforma, sin dominio, sin copias) o expone datos de todo el alumnado  |
| **Muy alto**    | Afecta a servicios esenciales durante más de una jornada o a datos personales de muchos usuarios |
| **Alto**        | Afecta a un servidor, a una cuenta privilegiada o a datos de un grupo de alumnos                 |
| **Medio**       | Afecta a varios equipos o a un aula, sin pérdida de datos relevantes                             |
| **Bajo**        | Afecta a un único equipo o usuario y se resuelve sin pérdida de datos                            |
| **Sin impacto** | Evento sin efecto real (por ejemplo, un ataque bloqueado)                                        |

## 3.3 Clasificación de las amenazas identificadas

Con estos criterios se han clasificado las amenazas más relevantes para el centro. La columna «Peligrosidad» recoge la valoración del grupo para el escenario descrito.

| **Amenaza**                                         | **Tipología**          | **Clasificación**            | **Tipo de incidente**                             | **Peligrosidad** |
|-----------------------------------------------------|------------------------|------------------------------|---------------------------------------------------|------------------|
| Ransomware en equipos de secretaría                 | Malware                | Contenido dañino             | Sistema infectado                                 | **Muy alto**     |
| Fuga de datos personales del alumnado               | Robo de información    | Compromiso de la información | Acceso no autorizado                              | **Muy alto**     |
| Phishing de credenciales de Moodle o correo         | Ingeniería social      | Fraude                       | Phishing                                          | **Alto**         |
| Acceso a la cuenta de un profesor y cambio de notas | Intrusión              | Intrusión                    | Compromiso de cuenta sin privilegios              | **Alto**         |
| DDoS contra la plataforma educativa                 | Denegación de servicio | Disponibilidad               | DDoS                                              | **Alto**         |
| Troyano introducido por USB en un aula              | Malware                | Contenido dañino             | Sistema infectado                                 | **Medio**        |
| Fuerza bruta contra SSH o RDP                       | Ataque a credenciales  | Intento de intrusión         | Intento de acceso con vulneración de credenciales | **Medio**        |
| Criptominería en equipos del aula                   | Malware / abuso        | Fraude                       | Uso no autorizado de recursos                     | **Medio**        |
| Captura de tráfico en la Wi-Fi                      | Reconocimiento         | Obtención de información     | Análisis de paquetes                              | **Medio**        |
| Moodle con versión sin parchear                     | Vulnerabilidad         | Vulnerable                   | Sistema vulnerable                                | **Medio**        |
| Escaneo de puertos desde la red de aulas            | Reconocimiento         | Obtención de información     | Escaneo de redes                                  | **Bajo**         |
| Spam masivo en el correo corporativo                | Contenido no deseado   | Contenido abusivo            | Spam                                              | **Bajo**         |

Hay que destacar que una fuga de datos personales no solo es un incidente técnico: según el artículo 33 del **RGPD**, si supone un riesgo para los derechos de las personas debe notificarse a la Agencia Española de Protección de Datos en un plazo máximo de **72 horas**. Por eso se le asigna la peligrosidad más alta junto con el ransomware.

# 4. Taxonomía de incidentes del SOC escolar

## 4.1 Categorías del SOC

La taxonomía nacional es completa, pero para el trabajo diario del SOC escolar resulta más práctico un conjunto reducido de categorías con un código corto que se pueda usar en los tickets. Cada categoría propia mantiene su equivalencia con la Guía Nacional para poder notificar sin traducir nada.

|             |                      |                                                                    |                                              |
|-------------|----------------------|--------------------------------------------------------------------|----------------------------------------------|
| **SOC-MAL** | Código dañino        | Virus, troyanos, ransomware, criptominería                         | Contenido dañino; Fraude (uso no autorizado) |
| **SOC-PHI** | Ingeniería social    | Phishing, suplantación, llamadas fraudulentas                      | Fraude; Obtención de información             |
| **SOC-REC** | Reconocimiento       | Escaneos de red, sniffing                                          | Obtención de información                     |
| **SOC-ACC** | Acceso no autorizado | Fuerza bruta, explotación, cuentas comprometidas                   | Intento de intrusión; Intrusión              |
| **SOC-DAT** | Datos                | Fuga, alteración o pérdida de información                          | Compromiso de la información                 |
| **SOC-DIS** | Disponibilidad       | Caídas, DoS/DDoS, sabotaje                                         | Disponibilidad                               |
| **SOC-VUL** | Vulnerabilidad       | Software sin parchear, mala configuración                          | Vulnerable                                   |
| **SOC-USO** | Uso indebido         | Software no autorizado, contenido inapropiado, BYOD fuera de norma | Contenido abusivo; Fraude                    |
| **SOC-OTR** | Otros                | Lo que no encaja en lo anterior                                    | Otros                                        |

## 4.2 Niveles de severidad

La severidad decide **con qué rapidez y a quién** se escala un incidente. Se obtiene a partir del mayor de los dos valores (peligrosidad o impacto) y sube un nivel cuando hay datos personales de menores implicados.

| **Severidad**         | **Criterio**                                                                 | **Ejemplo**                     | **Respuesta**              | **Escalado**                                                         |
|-----------------------|------------------------------------------------------------------------------|---------------------------------|----------------------------|----------------------------------------------------------------------|
| **SEV-1 Crítica**     | Servicios esenciales caídos, propagación activa o datos de menores expuestos | Ransomware cifrando el NAS      | Inmediata (\< 15 min)      | Coordinación TIC y dirección; INCIBE-CERT/CCN-CERT y AEPD si procede |
| **SEV-2 Alta**        | Servidor o cuenta privilegiada afectados, sin propagación                    | Cuenta de profesor comprometida | \< 1 hora                  | Responsable TIC                                                      |
| **SEV-3 Media**       | Uno o pocos equipos de usuario afectados                                     | Troyano en un equipo de aula    | \< 4 horas (misma jornada) | Analista de turno                                                    |
| **SEV-4 Baja**        | Intento fallido o actividad sospechosa sin éxito                             | Escaneo de puertos bloqueado    | \< 24 horas                | Revisión diaria                                                      |
| **SEV-5 Informativa** | Evento registrado sin riesgo                                                 | Falso positivo del antivirus    | Revisión semanal           | Ninguno                                                              |

## 4.3 Procedimiento de clasificación

Cuando llegue una alerta (del IDS, del antivirus o de un aviso de un usuario), el operador del SOC seguirá siempre los mismos pasos:

1.  **Detección:** se recibe la alerta y se comprueba que no es un duplicado.

2.  **Registro:** se abre un ticket con identificador SOC-AAAA-NNN, fecha, hora y origen.

3.  **Categorización:** se asigna el código de la taxonomía (SOC-MAL, SOC-PHI…).

4.  **Valoración:** se estiman la peligrosidad y el impacto según el apartado 3.2.

5.  **Severidad:** se asigna el nivel SEV correspondiente.

6.  **Escalado y notificación:** se avisa a quien indique la tabla anterior.

7.  **Reevaluación:** la clasificación se revisa si cambia la situación durante la gestión.

| **Campo**                  | **Valor**                                                                                      |
|----------------------------|------------------------------------------------------------------------------------------------|
| **Identificador**          | SOC-2026-001                                                                                   |
| **Fecha y hora**           | 26/10/2026 10:42                                                                               |
| **Origen de la alerta**    | Aviso de una profesora: correo sospechoso de «Moodle»                                          |
| **Categoría**              | SOC-PHI — Ingeniería social (Guía Nacional: Fraude / Phishing)                                 |
| **Peligrosidad / Impacto** | Alto / Bajo (nadie introdujo sus credenciales)                                                 |
| **Severidad**              | SEV-2 Alta                                                                                     |
| **Acciones**               | Bloquear el remitente y el enlace, buscar el mismo correo en otros buzones, avisar al claustro |

# 5. Catálogo de riesgos

## 5.1 Método de valoración

Para el catálogo se ha seguido un enfoque simplificado basado en **MAGERIT v3**: el riesgo de cada amenaza sobre un activo se calcula como **Riesgo = Probabilidad × Impacto**, con ambas variables en una escala de 1 a 5.

|       |                                                    |                                                       |
|-------|----------------------------------------------------|-------------------------------------------------------|
| **1** | Muy improbable (menos de una vez cada varios años) | Insignificante                                        |
| **2** | Improbable (una vez cada pocos años)               | Menor: un equipo o usuario                            |
| **3** | Posible (alguna vez al año)                        | Moderado: un aula o un servicio secundario            |
| **4** | Probable (varias veces al año)                     | Grave: servicio importante o datos de un grupo        |
| **5** | Casi seguro (mensual o más)                        | Muy grave: todo el centro o datos de todo el alumnado |

El resultado se agrupa en cuatro niveles: **Bajo** (1 a 4), **Medio** (5 a 9), **Alto** (10 a 14) y **Crítico** (15 a 25).

## 5.2 Catálogo de riesgos priorizado

*Tabla 11. Catálogo de riesgos ordenado por nivel*

| **ID**   | **Riesgo (amenaza sobre activo)**                               | **P** | **I** | **R**  | **Nivel**   | **Contramedida principal**                                            |
|----------|-----------------------------------------------------------------|-------|-------|--------|-------------|-----------------------------------------------------------------------|
| **R-02** | Robo de credenciales del profesorado por phishing (V-01)        | 4     | 4     | **16** | **Crítico** | MFA en correo y Moodle, filtro antiphishing, formación                |
| **R-01** | Ransomware que cifra servidores y el NAS de copias (V-01, V-08) | 3     | 5     | **15** | **Crítico** | Copias 3-2-1 con una copia desconectada, EDR, segmentar el NAS        |
| **R-04** | Fuerza bruta contra RDP/SSH expuestos (V-05, V-08)              | 3     | 4     | **12** | **Alto**    | No publicar RDP, acceso por VPN, fail2ban, claves SSH                 |
| **R-05** | Explotación de una vulnerabilidad en Moodle (V-06)              | 3     | 4     | **12** | **Alto**    | Gestión de parches, revisión de plugins, escaneo de vulnerabilidades  |
| **R-03** | Fuga de datos personales del alumnado (V-05, V-09)              | 2     | 5     | **10** | **Alto**    | Permisos por rol, cifrado, registro de accesos                        |
| **R-09** | Interceptación de tráfico en la Wi-Fi (V-07)                    | 3     | 3     | **9**  | **Medio**   | WPA2/WPA3-Enterprise, SSID separados, aislamiento de clientes         |
| **R-06** | Malware introducido por USB en equipos de aula (V-03)           | 4     | 2     | **8**  | **Medio**   | Antivirus con análisis de extraíbles, autorun desactivado por GPO     |
| **R-07** | Instalación de software no autorizado (V-04)                    | 4     | 2     | **8**  | **Medio**   | Usuarios sin privilegios de administrador, listas blancas (AppLocker) |
| **R-08** | Escaneos y ataques internos desde la red de aulas (V-09)        | 4     | 2     | **8**  | **Medio**   | VLAN de aulas aislada, IDS (Snort/Suricata), normas de uso            |
| **R-10** | Acceso físico a equipos o al armario de red (V-11)              | 2     | 4     | **8**  | **Medio**   | Rack con llave, bloqueo automático de sesión, contraseña de BIOS      |
| **R-11** | Denegación de servicio sobre la plataforma educativa (V-08)     | 2     | 3     | **6**  | **Medio**   | Protección DDoS del proveedor, plan de continuidad                    |
| **R-12** | Compromiso de un dispositivo IoT (V-06)                         | 3     | 2     | **6**  | **Medio**   | Cambiar credenciales por defecto, VLAN de IoT, actualizar firmware    |
| **R-13** | Spam y contenido no deseado en el correo (V-01)                 | 4     | 1     | **4**  | **Bajo**    | Filtros antispam del proveedor de correo                              |

## 5.3 Mapa de calor

El mapa de calor sitúa cada riesgo según su probabilidad (columnas) y su impacto (filas), lo que permite ver de un vistazo dónde se concentran los riesgos más graves.

|                      |       |          |                |                      |       |
|----------------------|-------|----------|----------------|----------------------|-------|
| **Impacto \\ Prob.** | **1** | **2**    | **3**          | **4**                | **5** |
| **5**                |       | **R-03** | **R-01**       |                      |       |
| **4**                |       | **R-10** | **R-04, R-05** | **R-02**             |       |
| **3**                |       | **R-11** | **R-09**       |                      |       |
| **2**                |       |          | **R-12**       | **R-06, R-07, R-08** |       |
| **1**                |       |          |                | **R-13**             |       |

## 5.4 Priorización y relación con las siguientes sesiones

Los dos riesgos críticos, **R-01 (ransomware)** y **R-02 (robo de credenciales por phishing)**, deben tratarse primero, y comparten una parte de la solución: si el phishing tiene éxito, es la puerta de entrada más habitual del ransomware. Les siguen tres riesgos altos (R-03, R-04 y R-05) relacionados con accesos no autorizados y servicios vulnerables.

Este catálogo marca el trabajo de las siguientes sesiones:

- **Sesión 2 (laboratorio seguro):** el análisis de una muestra en sandbox servirá para obtener IoC (hashes e IP) de amenazas de la categoría SOC-MAL, relacionadas con R-01 y R-06.

- **Sesión 3 (contramedidas y antivirus):** la protección en tiempo real, el análisis de extraíbles y la cuarentena reducen R-01, R-06 y R-07.

- **Sesión 4 (IDS y Wireshark):** la monitorización del tráfico permitirá detectar R-04, R-08 y R-09 y registrar los incidentes con la taxonomía definida aquí.

# 6. Conclusiones

En esta sesión se ha construido la base de trabajo del SOC escolar. El inventario de activos muestra que lo más valioso del centro no son los equipos de las aulas, sino los **datos personales del alumnado** y los servicios que los gestionan (Active Directory, Moodle, secretaría y copias de seguridad).

El análisis de vectores confirma que la mayoría de los ataques empiezan por las personas: un correo de phishing o una contraseña débil abren la puerta a amenazas mucho más graves. Por eso las contramedidas técnicas que se configurarán más adelante deben ir acompañadas de MFA y de formación a los usuarios.

Adoptar la taxonomía de la Guía Nacional de INCIBE-CERT y CCN-CERT, adaptada con códigos cortos y cinco niveles de severidad, da al SOC un criterio común para clasificar cualquier alerta y saber a quién avisar y en qué plazo. El catálogo de riesgos, por último, ordena las prioridades: ransomware y robo de credenciales primero, después los accesos no autorizados y los servicios sin parchear.

# 7. Bibliografía y fuentes consultadas

1.  INCIBE-CERT y CCN-CERT. **Guía Nacional de Notificación y Gestión de Ciberincidentes.** Consejo Nacional de Ciberseguridad, 2020.

2.  CCN-CERT. **CCN-STIC 817: Gestión de ciberincidentes.** Centro Criptológico Nacional. https://www.ccn-cert.cni.es

3.  Ministerio de Hacienda y Administraciones Públicas. **MAGERIT v3: Metodología de Análisis y Gestión de Riesgos de los Sistemas de Información.** 2012.

4.  **Real Decreto 311/2022**, de 3 de mayo, por el que se regula el Esquema Nacional de Seguridad.

5.  **Reglamento (UE) 2016/679** (RGPD), artículo 33: notificación de violaciones de seguridad a la autoridad de control.

6.  INCIBE. **Guías y avisos de seguridad.** https://www.incibe.es

7.  INCIBE. **Oficina de Seguridad del Internauta (OSI).** https://www.osi.es

8.  MITRE. **ATT&CK: tácticas y técnicas de adversarios.** https://attack.mitre.org8. Declaración de uso responsable de Inteligencia Artificial

En cumplimiento del marco metodológico del módulo, se incluye la declaración de uso de herramientas de IA en este entregable:

| **Campo**                                                     | **Declaración**                                                                                                                                                                                                                                                           |
|---------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Herramientas de IA consultadas**                            | Claude                                                                                                                                                                                                                                                                    |
| **Finalidad de uso**                                          | Apoyo en la estructuración y redacción del informe y en la maquetación del documento (portada, índice, tablas y formato)                                                                                                                                                  |
| **Prompts o consultas principales**                           | «Desarrollar la Sesión 1 de la guía A2 - RA 2 (identificación y clasificación de amenazas) como alumno de 2º de ASIR, con portada, índice y logo de Digitech, en fuente Aptos 12»                                                                                         |
| **Validación técnica y verificación realizada por el alumno** | Contraste de la taxonomía y de los niveles de peligrosidad e impacto con la Guía Nacional de Notificación y Gestión de Ciberincidentes; revisión de los valores de probabilidad e impacto del catálogo según la realidad del centro; lectura y corrección final del texto |
