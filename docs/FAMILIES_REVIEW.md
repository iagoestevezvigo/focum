# Revisión de Familias de Google Play

Revisión del código realizada el 30 de octubre de 2026. El propietario indicó que seleccionó todas las edades y aceptó mostrar el compromiso de Familias. Esta revisión identifica cambios técnicos y tareas de publicación; no es una certificación de Google ni una verificación jurídica de todas las jurisdicciones.

## Hallazgos y cambios

| Área | Hallazgo previo | Cambio |
| --- | --- | --- |
| Dictado | El reconocedor por defecto podía procesar audio en servidores externos; el SDK también podía recurrir a ese reconocedor | Se elimina speech_to_text y se usa exclusivamente createOnDeviceSpeechRecognizer en ambas rutas, Flutter y superposición nativa. Android anterior a 12, modelos ausentes y errores mantienen la selección manual |
| Fuentes y red | Google Fonts descargaba tipografías y requería Internet | Se elimina google_fonts y se usa la fuente del sistema. La versión release no solicita Internet; los manifiestos de desarrollo conservan la conexión para las herramientas de Flutter |
| Información y aceptación | Los permisos no estaban precedidos de una explicación explícita del tratamiento | Avisos localizados para micrófono y eventos de uso, con aceptar o rechazar. El acceso efectivo exige aceptación además del permiso del sistema; rechazar o cerrar no la concede |
| Copias | No había exclusiones explícitas | Se desactiva backup y se excluyen los datos de copia y transferencia Android |
| Política | Contenía campos pendientes y solo existía en el repositorio | Responsable y contacto reales, tratamiento actualizado y consulta completa dentro de la app sin conexión. El texto completo está en español; la navegación, avisos y nota del idioma están en los seis idiomas |
| Eliminación | Solo desde ajustes Android | Se añade borrado de todos los datos locales con confirmación, además de los ajustes del sistema |
| Publicidad, identificadores, cuentas y social | Sin publicidad, monetización, login, analítica, identificadores publicitarios, ubicación, Bluetooth ni funciones de compartir | Se conserva la ausencia de esas funciones; no se añade una pantalla de edad porque todos reciben las mismas protecciones |
| Intenciones y uso | Hasta 300 intenciones y consulta local de apps | Se mantiene el límite y el tratamiento local. El acceso de uso requiere aceptación previa incluso para instalaciones con permiso ya concedido |

El nombre y correo del responsable son información pública de contacto proporcionada para la política. No son credenciales. Las claves de firma y configuraciones locales continúan excluidas de Git.

## Pendiente antes de publicar

La validación automática incluye tests de localización y privacidad, compilaciones Android debug y AAB release, y comprobación del manifiesto y la política dentro del bundle final. No aparecen permisos de Internet, identificador publicitario, ubicación precisa ni Bluetooth en el AAB. El análisis de Flutter no detecta errores ni advertencias; conserva cinco avisos informativos previos de estilo en el constructor de AppController. No se han realizado pruebas de reconocimiento en un dispositivo real ni una evaluación de usabilidad infantil.

1. **Revisar las edades reales.** Seleccionar todas implica que se ha diseñado para cada franja, incluida «Hasta 5 años». La app actual depende de lectura, comprensión de intenciones y ajustes avanzados de Android: no se ha validado su adecuación para preescolares. Elegir las edades para las que realmente se diseñó; no seleccionar todas solo para que todos puedan descargarla. Esto no se puede resolver cambiando una frase o añadiendo una insignia.
2. **Consentimiento parental y países.** Revisar las obligaciones de los países de distribución y de las edades elegidas. Los avisos y permisos de esta app no verifican la identidad de un adulto ni sustituyen el consentimiento parental legal cuando proceda. La ausencia de transferencias reduce exposición, pero no certifica cumplimiento de COPPA, RGPD u otras leyes.
3. **Probar dispositivos reales.** Comprobar rechazo y cierre de cada aviso, permisos previamente concedidos sin aceptación, dictado con modo avión, falta de modelo, Android anterior a 12, cancelación, bloqueo de pantalla, revocación de permisos y borrado. Revisar legibilidad y comprensión con las edades elegidas. La compilación y los tests automatizados no sustituyen estas pruebas.
4. **Actualizar Seguridad de los datos.** El uso local de intenciones, audio y datos de apps debe describirse en la política. Bajo la definición del formulario, «recogida» se refiere normalmente a transmisión fuera del dispositivo: revisar la guía de Google y el bundle final antes de declarar que no se recogen ni comparten datos. No marcar «cifrado en tránsito» por el mero uso de SharedPreferences. Los mensajes enviados voluntariamente al correo de soporte son externos a la app.
5. **Actualizar la ficha y políticas.** Declarar ausencia de anuncios, compras, cuentas y funciones sociales; contestar IARC según el contenido real. Mantener pública la URL de PRIVACY.md, comprobar sus datos de contacto y que coincida con la versión publicada. Revisar también los requisitos de superposición, servicio en primer plano y acceso de uso; Familias no exime del resto de políticas.
6. **Subir un nuevo bundle.** El código incrementa la versión a 1.0.0+4. Generar y revisar el AAB final antes de enviarlo. El bundle anterior conserva sus conexiones y comportamiento anteriores aunque se fusione esta PR. No se ha modificado Play Console ni se ha enviado un release automáticamente.

Si se mantiene marcada la insignia de compromiso, completar estas verificaciones antes de enviar a revisión. Esta PR no elimina por sí sola las dudas sobre adecuación por edad o consentimiento parental.

## Fuentes oficiales

- [Políticas de Familias de Google Play](https://support.google.com/googleplay/android-developer/answer/9893335?hl=es): contenido adecuado, declaraciones precisas, datos de sensores, identificadores, APIs/SDKs, funciones sociales y obligaciones legales.
- [Contenido y audiencia objetivo](https://support.google.com/googleplay/android-developer/answer/9867159?hl=es): elegir solo las edades para las que se ha diseñado la aplicación y evaluar las obligaciones de menores.
- [Datos de usuario](https://support.google.com/googleplay/android-developer/answer/10144311?hl=es): política, avisos destacados y consentimiento antes del acceso no esperado a datos sensibles.
- [Formulario Seguridad de los datos](https://support.google.com/googleplay/android-developer/answer/10787469?hl=es): definiciones de recogida, uso local y compromiso con Familias.
- [SpeechRecognizer de Android](https://developer.android.com/reference/android/speech/SpeechRecognizer): API de reconocimiento local disponible desde Android 12.
- [Copias de seguridad Android](https://developer.android.com/identity/data/autobackup): reglas de exclusión y diferencias entre backup y transferencia.
