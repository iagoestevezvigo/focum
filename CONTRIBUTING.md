# Cómo contribuir a Focum

Puedes colaborar comunicando errores, proponiendo mejoras, traduciendo la interfaz, mejorando la documentación o enviando código. Las contribuciones se revisan antes de incorporarse: abrir una pull request no implica que vaya a ser aceptada.

## Antes de empezar

Busca primero si existe una incidencia o pull request sobre el mismo tema. Para cambios importantes, abre una incidencia que explique el problema y la propuesta antes de implementarla. Para correcciones pequeñas puedes abrir directamente una pull request.

Describe los errores con los pasos para reproducirlos, el resultado esperado y el observado, la versión de Android y la versión de Focum. Oculta cualquier dato personal en capturas y registros. Mantén un trato respetuoso y centra las conversaciones en el problema y la solución.

## Preparar el proyecto

1. Crea un fork de este repositorio en tu cuenta de GitHub.
2. Clona tu fork y crea una rama para el cambio:

   ```sh
   git clone https://github.com/TU_USUARIO/focum.git
   cd focum
   git switch -c mi-contribucion
   flutter pub get
   ```

3. Utiliza Flutter estable, las herramientas de Android y Java 17. Consulta el [README](README.md) para conocer la arquitectura y ejecutar la aplicación.

No necesitas las claves de firma del mantenedor para desarrollar ni para ejecutar los tests. Las versiones de distribución se firman por separado; nunca solicites ni compartas claves privadas.

## Preparar y comprobar los cambios

Mantén cada pull request centrada en un objetivo. Sigue el estilo del código existente y añade o adapta pruebas cuando cambie el comportamiento. Antes de enviar código Dart, ejecuta:

```sh
dart format lib test
flutter analyze
flutter test
```

Si cambias las traducciones, edita los catálogos `lib/l10n/app_*.arb` y regenera los archivos derivados:

```sh
flutter gen-l10n
python tool/sync_android_localizations.py
```

Vuelve a ejecutar las comprobaciones después de regenerar. Si cambias código nativo o permisos de Android, comprueba también la función afectada en un dispositivo o emulador. Indica en la pull request qué has probado y qué no has podido verificar. Para cambios solo de documentación basta con revisar su contenido y enlaces.

## Enviar una pull request

Sube tu rama a tu fork y abre una pull request contra `master` de `iagoestevezvigo/focum`. Explica el problema, el cambio, cómo lo has comprobado y la incidencia relacionada, si existe. Añade capturas si cambia la interfaz y explica cualquier nuevo permiso, dependencia o tratamiento de datos. Puedes abrirla como borrador mientras trabajas.

Los colaboradores externos trabajan mediante forks y pull requests; no necesitan permisos de escritura o administración sobre este repositorio.

## Revisión y aceptación

Los cambios en `master` deben pasar por una pull request y recibir al menos una aprobación. Además, los archivos con responsable en `.github/CODEOWNERS` requieren la aprobación de uno de esos responsables. El propietario actual es **@iagoestevezvigo** para todo el repositorio, incluido el propio archivo CODEOWNERS.

La decisión de aceptar y fusionar corresponde al propietario o a otro administrador autorizado. Los comentarios y revisiones de la comunidad son bienvenidos, pero no sustituyen la aprobación obligatoria del responsable. Si se añaden cambios después de una aprobación, esta se invalida y hace falta una nueva revisión. Las conversaciones de revisión deben resolverse antes de fusionar.

GitHub no permite que el autor apruebe su propia pull request. Por tanto, una PR del propietario necesita la aprobación de otro responsable autorizado. No se prevén excepciones para saltarse las reglas, ni pushes directos, force pushes o borrados de `master`.

Las reglas de GitHub aplican los requisitos de revisión; este documento y CODEOWNERS por sí solos no sustituyen la configuración del repositorio. GitHub utiliza el CODEOWNERS de la rama de destino, por lo que los nuevos responsables entran en vigor cuando ese archivo se incorpora a `master`.

## Incorporar a otro administrador

El propietario decide quién administra el proyecto y concede ese permiso desde la configuración de acceso de GitHub. Para que el nuevo administrador pueda aportar la aprobación obligatoria, debe añadirse su usuario en la misma línea que el propietario en `.github/CODEOWNERS`:

```text
* @iagoestevezvigo @USUARIO_DEL_NUEVO_ADMIN
```

Sustituye el ejemplo por un usuario real con acceso al repositorio. Todos los responsables de aprobación de esa línea deben ser administradores autorizados; revisa también CODEOWNERS cuando retires el acceso a alguien. Dar permisos de administrador y editar CODEOWNERS son operaciones independientes.

## Privacidad y credenciales

Antes de cada commit revisa `git diff --cached`. No incluyas claves de firma, contraseñas, tokens, archivos `.env`, configuraciones locales, datos personales, registros privados ni artefactos de compilación. El `.gitignore` ayuda a excluirlos, pero no detecta secretos pegados en el código ni elimina archivos ya publicados.

No publiques credenciales ni datos de usuarios en incidencias o pull requests. Si se filtra una credencial, revócala o rótala de inmediato: eliminarla del último commit no la borra del historial. Para comunicar una vulnerabilidad, utiliza la opción privada **Report a vulnerability** en la pestaña **Security** del repositorio cuando esté disponible; no reveles detalles sensibles en una incidencia pública.

Consulta también la [política de privacidad](PRIVACY.md). Los cambios en datos, permisos o servicios deben reflejarse en ella cuando corresponda.

## Licencia de las contribuciones

Al enviar una contribución para su incorporación al proyecto, la aportas bajo la [licencia Apache 2.0](LICENSE), conforme a sus condiciones sobre contribuciones. Asegúrate de tener derecho a compartir el código y los recursos que incluyas, y conserva los avisos y atribuciones de terceros que correspondan.
