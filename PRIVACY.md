# Política de privacidad de Focum

Última actualización: 30 de octubre de 2026.

Esta política describe la versión con dictado exclusivamente local. Las versiones anteriores podían utilizar el reconocimiento de voz del sistema con conexión y descargar tipografías.

## Responsable y contacto

Focum es un proyecto de código abierto para Android que ayuda a hacer una pausa y elegir una intención antes de utilizar el teléfono.

Responsable de la distribución de esta aplicación: **Iago Estevez Núñez**.

Contacto para consultas de privacidad y ejercicio de derechos: **iagoestevez1025@gmail.com**.

Esta política describe la aplicación de este repositorio. Las versiones modificadas o distribuidas por terceros pueden tener un funcionamiento diferente y deben informar de sus propias prácticas.

## Datos que utiliza la aplicación

Focum no requiere una cuenta. La versión actual no integra publicidad, analítica de terceros ni un servicio propio de almacenamiento en la nube. El equipo de Focum no recibe automáticamente tus intenciones ni tu historial de uso.

La aplicación trata los siguientes datos para ofrecer sus funciones:

- **Intenciones:** fecha y hora, categoría elegida, descripción o texto reconocido por voz cuando lo haya y método de entrada. Se guardan en el almacenamiento privado de la aplicación.
- **Estado y recordatorios:** estado de activación, intención activa, motivo y marcas de tiempo necesarias para mostrar las pausas y programar recordatorios.
- **Desbloqueos:** recibe eventos del sistema para mostrar la pregunta de intención después del desbloqueo. No accede a tu PIN, contraseña ni datos biométricos.
- **Uso de aplicaciones:** si concedes acceso de uso, consulta eventos y estadísticas recientes de Android para identificar la aplicación en primer plano por su identificador y nombre, compararla localmente con tu intención y mostrar recordatorios cuando corresponda. Focum no crea un historial persistente propio de las aplicaciones consultadas ni envía esta información a un servidor propio. No lee el contenido de esas aplicaciones.
- **Idioma y permisos:** consulta las preferencias de idioma del dispositivo y el estado de los permisos para adaptar la interfaz y las funciones disponibles.

La clasificación de las intenciones y la comparación con las aplicaciones se realizan mediante reglas locales; no se envían a un servicio externo de inteligencia artificial.

## Entrada por voz

El micrófono se utiliza cuando activas la entrada por voz y has concedido el permiso correspondiente. Puedes elegir una categoría manualmente sin utilizar el micrófono.

Focum utiliza exclusivamente la API de reconocimiento en el dispositivo de Android 12 o posterior. Si el dispositivo no ofrece ese reconocimiento o no tiene un modelo compatible con tu idioma, debes usar las categorías manuales. No se utiliza un reconocedor en la nube como alternativa. Antes de pedir el permiso de micrófono, la aplicación explica este tratamiento y solicita tu aceptación; rechazarlo permite seguir utilizando las categorías manuales.

Focum no guarda archivos de audio ni los envía a un backend propio. El texto resultante puede conservarse localmente como descripción de la intención y mostrarse en recordatorios.

## Conexiones y servicios de terceros

La versión de distribución utiliza la tipografía del sistema y no solicita el permiso de Internet. No descarga fuentes ni integra SDKs de publicidad, analítica, redes sociales o reconocimiento de voz externo. La política se incluye en la aplicación y se puede consultar sin conexión.

La instalación y actualización desde Google Play, el sistema operativo y la gestión de modelos locales por Android dependen de sus respectivos proveedores. Focum no realiza transferencias de intenciones, audio ni datos de uso a servidores. No vende tus datos ni incorpora seguimiento publicitario.

## Permisos y controles

- **Mostrar sobre otras aplicaciones:** permite presentar la pausa, la intención y los avisos mientras utilizas el teléfono.
- **Acceso de uso:** permite identificar la aplicación en primer plano para los recordatorios relacionados con tu intención.
- **Micrófono:** permite el dictado opcional.
- **Notificaciones:** permite mostrar el servicio activo y los recordatorios.
- **Servicio en primer plano y reinicio:** permiten mantener la función activa y reanudarla después de reiniciar si la habías dejado activada.
- **Vibración:** permite acompañar los avisos.

Antes de abrir los ajustes de acceso de uso, Focum explica que consulta eventos en segundo plano y solicita tu aceptación. La consulta requiere tanto esa aceptación como el permiso especial de Android, también si el permiso ya estaba concedido en una versión anterior.

Puedes detener Focum desde la aplicación y revocar permisos o accesos especiales en los ajustes de Android. Revocar un permiso puede impedir la función asociada. Detener el servicio no borra las intenciones ya guardadas.

## Conservación y eliminación

El historial local conserva un máximo de **300 intenciones**. Cuando se supera ese límite, las entradas más antiguas se descartan. No existe un plazo de caducidad por días: las entradas restantes se conservan hasta que se sustituyen o eliminas los datos de la aplicación. El estado nativo y la intención activa se mantienen por separado del historial para gestionar el servicio y sus recordatorios.

Puedes usar **Privacidad y datos → Borrar datos locales** dentro de la aplicación. Se pide confirmación; al aceptar se detiene Focum, se eliminan sus datos, ajustes y consentimientos y se cierra la aplicación. También puedes abrir **Ajustes de Android → Aplicaciones → Focum → Almacenamiento → Borrar datos o Borrar almacenamiento**. Los nombres pueden variar según el dispositivo. Desinstalar la aplicación también elimina sus datos locales habituales. La versión actual no ofrece borrado individual de entradas ni una cuenta remota que deba eliminarse.

La aplicación desactiva las copias de seguridad y excluye sus datos de las transferencias entre dispositivos mediante las reglas de Android. Esto no elimina copias que se hayan creado con versiones anteriores; puedes gestionarlas con tu proveedor de copias de seguridad. Un dispositivo modificado o una herramienta externa con acceso privilegiado puede actuar al margen de estas reglas.

## Protección y visibilidad de los datos

Los datos se guardan mediante las preferencias privadas de la aplicación, bajo las protecciones de acceso de Android. Focum no añade una capa propia de cifrado a esas preferencias. La protección del dispositivo, sus copias y el acceso físico también depende de tu configuración de seguridad.

La intención o el texto dictado pueden aparecer en superposiciones y notificaciones, incluidas las superficies que Android permita mostrar en la pantalla de bloqueo. Puedes ajustar la visibilidad de las notificaciones en Android. Evita incluir información sensible si otras personas pueden ver tu pantalla.

## Menores y familias

Las mismas protecciones se aplican a todos los usuarios, incluidos menores y usuarios de edad desconocida: no hay publicidad, cuentas, compras, funciones sociales ni transmisión de las intenciones. No se solicita fecha de nacimiento ni se crea un perfil de edad. El dictado y el acceso de uso son opcionales y requieren aceptación previa; los permisos de Android no sustituyen el consentimiento parental cuando lo exija la legislación aplicable.

Los padres o tutores pueden acompañar la configuración, desactivar el dictado o el acceso de uso en Android, detener la aplicación y eliminar sus datos. Las intenciones pueden contener información personal: evita nombres, direcciones u otros datos sensibles en el dictado y recuerda que los avisos pueden verse en pantalla. La aplicación no permite enviar esos textos a otros usuarios.

## Consultas y derechos

Puedes utilizar el contacto indicado al principio para consultas de privacidad o para solicitar el ejercicio de los derechos que te correspondan según la normativa aplicable, incluidos acceso, rectificación, eliminación, limitación, oposición y portabilidad cuando procedan. También puedes dirigirte a la autoridad de protección de datos competente.

El equipo no dispone de acceso remoto a las intenciones guardadas únicamente en tu dispositivo; puedes eliminar esos datos siguiendo las instrucciones anteriores. Si escribes al contacto del proyecto, el destinatario recibirá los datos que incluyas en tu mensaje. No publiques intenciones, grabaciones ni otra información personal en incidencias públicas del repositorio.

## Código abierto y cambios

Que el código sea abierto permite inspeccionar cómo funciona la aplicación; no convierte tus intenciones en datos públicos. Esta política no concede una licencia de uso del código: las condiciones de distribución y reutilización se establecen en la licencia Apache 2.0 incluida en el archivo LICENSE del proyecto.

Actualizaremos esta política cuando cambie el tratamiento de datos y modificaremos la fecha de actualización. La política debe revisarse junto con cualquier cambio en permisos, dependencias o servicios externos.
