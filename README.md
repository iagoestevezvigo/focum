# Focum

Focum es un MVP en Flutter para Android que introduce una pausa consciente justo despues del desbloqueo del telefono.

## Desarrollo y licencia

El proyecto se distribuye bajo la [licencia Apache 2.0](LICENSE).

Para colaborar, consulta [CONTRIBUTING.md](CONTRIBUTING.md). Envía tus cambios mediante una pull request: su incorporación requiere revisión y aprobación del propietario o de otro administrador autorizado como responsable del código.

Para preparar una copia local, instala Flutter estable y las herramientas de Android y ejecuta:

```sh
git clone https://github.com/iagoestevezvigo/focum.git
cd focum
flutter pub get
flutter run
```

Las compilaciones de desarrollo no requieren la clave privada del mantenedor. Para generar una versión release firmada, crea tu propia clave y configura localmente `android/key.properties` con `storeFile`, `storePassword`, `keyAlias` y `keyPassword`. Ese archivo y las claves de firma están excluidos de Git. No compartas claves, contraseñas, archivos `.env` ni configuraciones de servicios con credenciales.

## Privacidad

Consulta la [Política de privacidad de Focum](PRIVACY.md), que describe el almacenamiento local, el acceso de uso, el dictado, las conexiones de tipografías y la eliminación de datos.

La política incluye el responsable y contacto y está disponible sin conexión desde «Privacidad y datos» dentro de la aplicación. Para Google Play, utilizar su URL pública y revisar las declaraciones de la versión que se publique. Requisitos de referencia: [Datos de usuario de Google Play](https://support.google.com/googleplay/android-developer/answer/10144311?hl=es).

## Flujo del MVP

1. El usuario abre Focum y concede los permisos clave.
2. Pulsa `ACTIVAR FOCUM`.
3. Focum arranca un `foreground service` nativo en Android.
4. Cuando Android emite `ACTION_USER_PRESENT`, Focum abre la pantalla de intencion.
5. El usuario selecciona una categoria o dicta su motivo por voz.
6. Focum guarda la intencion localmente y permite continuar.

## Permisos y ajustes

- `Mostrar sobre otras apps`: necesario para poder traer la pantalla de Focum al frente tras el desbloqueo.
- `Notificaciones`: recomendado para que el servicio activo sea visible al usuario.
- `Microfono`: opcional, solo para la entrada por voz.
- `Optimizacion de bateria`: opcional, puede mejorar la fiabilidad en algunos fabricantes.

## Arquitectura

### Flutter

- `lib/screens`
  Pantallas principales: configuracion y pregunta de intencion.
- `lib/widgets`
  Widgets reutilizables como `IntentionWheel`, `VoiceInputButton`, `PermissionCard` y `ActivationButton`.
- `lib/services`
  Clasificacion, almacenamiento local, permisos, puente nativo y voz.
- `lib/models`
  Modelos de categorias, permisos e intenciones guardadas.
- `lib/state`
  `AppController` centraliza el flujo y el estado de UI.
- `lib/theme`
  Tema Material 3 y direccion visual de la app.

### Android nativo

- `UnlockMonitorService`
  Servicio en primer plano que escucha desbloqueos con `ACTION_USER_PRESENT`.
- `MainActivity`
  Expone `MethodChannel` y `EventChannel` para enlazar Flutter con Android.
- `BootReceiver`
  Reactiva el servicio tras reinicio si el usuario lo habia dejado activo.
- `DailyActivationReminderReceiver`
  Muestra un recordatorio diario para reabrir Focum si Android ha detenido el servicio.
- `FocumPrefs`
  Persistencia ligera del estado nativo.

## Almacenamiento local

Cada intencion se guarda en `SharedPreferences` como JSON con:

- `timestamp`
- `category`
- `description`
- `inputMethod`

## Limitaciones importantes de Android

- El MVP no intercepta el desbloqueo a nivel de sistema como si fuera la pantalla de bloqueo del launcher o del SO.
- La estrategia implementada depende de un `foreground service` activo, del broadcast `ACTION_USER_PRESENT` y del permiso de superposicion.
- Algunos fabricantes pueden limitar la fiabilidad si aplican politicas agresivas de bateria o cierran servicios en segundo plano.
- La entrada por voz usa exclusivamente el reconocedor local de Android 12 o posterior; si no está disponible o falta el modelo del idioma, se utilizan las categorías manuales. No hay alternativa de dictado en la nube.
- Para una publicacion en Google Play hay que revisar con cuidado el uso de `SYSTEM_ALERT_WINDOW` y del `foreground service` segun la politica vigente.

## Verificacion local

- `flutter test --reporter expanded`
- `android\\gradlew.bat app:assembleDebug --stacktrace --console=plain`

En este entorno la build Android valida correctamente con Java 17 (`Android Studio jbr`).

## Bundle para Google Play

- Identificador de la aplicacion: `com.Focum.app` (respetar las mayusculas).
- Version actual: consultar `pubspec.yaml`.
- Firma de subida: utilizar tu propia clave privada local.
- Credenciales locales: `android/key.properties`. Tanto este archivo como la clave estan excluidos del control de versiones por `android/.gitignore`.

Guardar una copia privada de la clave y de `key.properties` antes de la primera subida. Se necesitan para firmar futuras versiones.

Para generar el Android App Bundle firmado con Java 17 en PowerShell:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
flutter build appbundle --release
```

El archivo se genera en `build/app/outputs/bundle/release/app-release.aab`.
Subirlo desde Google Play Console, en la pista de prueba interna, y configurar los testers y su enlace de acceso.
En cada nueva subida, incrementar el numero despues de `+` en `pubspec.yaml` (por ejemplo, `1.0.0+3`).

## Idiomas

La interfaz sigue automaticamente la lista de idiomas preferidos del dispositivo:
ingles, espanol, frances, aleman, italiano y portugues. Las variantes regionales
(por ejemplo, `es-MX`, `fr-CA` o `pt-BR`) usan el catalogo de su idioma. Si no hay
coincidencia, la interfaz usa ingles. Android 13 y posteriores tambien permiten
elegir el idioma de Focum desde los ajustes de idiomas por aplicacion.

Los catalogos `lib/l10n/app_*.arb` son la fuente de las traducciones de Flutter y
Android. Incluyen pantallas, categorias, permisos, avisos, notificaciones y los
textos de la pantalla nativa de desbloqueo. Las traducciones no usan un servicio
externo. Los textos dictados y los identificadores guardados de las categorias
se conservan; no se traduce el contenido introducido por el usuario.
El bundle incluye todos los idiomas nativos de Android (`enableSplit = false`)
para poder cambiar de idioma sin descargar recursos adicionales de Google Play.

El reconocimiento de voz selecciona un idioma instalado que coincida con las
preferencias del dispositivo, incluyendo variantes regionales. Su disponibilidad
y funcionamiento sin conexion dependen del servicio de voz del dispositivo.
La clasificacion de intenciones incluye vocabulario de los seis idiomas.

Despues de modificar los catalogos:

```powershell
flutter gen-l10n
python tool/sync_android_localizations.py
flutter test
flutter build appbundle --release
```

Para anadir otro idioma, crear su catalogo ARB completo y actualizar
`android/app/src/main/res/xml/locales_config.xml`. Regenerar ambos conjuntos de
recursos antes de compilar.

### Estado de iOS

Este repositorio todavia no tiene un proyecto `ios/` ni implementacion iOS del
puente `focum/native`. Las traducciones y los delegados de Material y Cupertino
estan preparados en Flutter, pero eso no convierte esta build en una app iOS.
Al crear la version iOS se deben declarar `en`, `es`, `fr`, `de`, `it` y `pt` en
`CFBundleLocalizations`, localizar los mensajes de permisos de `Info.plist` y
adaptar las funciones de Android (superposicion y deteccion de desbloqueos) a las
capacidades disponibles en iOS. La compilacion y firma para App Store requieren
el entorno de Apple.

## Revisión de Familias y publicación

Consulta [la revisión de Familias](docs/FAMILIES_REVIEW.md) antes de publicar. Los cambios de privacidad necesitan una nueva compilación; fusionar esta PR no actualiza el bundle ya subido a Play Console.
