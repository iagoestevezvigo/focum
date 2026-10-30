// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get preparingPause => 'Preparando tu pausa.';

  @override
  String get setupTitle => 'Configura Focum';

  @override
  String get setupDescription =>
      'Solo necesitamos unos permisos para ayudarte a usar el móvil con intención.';

  @override
  String get focumReady => 'Focum está preparado';

  @override
  String get focumInactive => 'Focum aún no está activo';

  @override
  String get reviewPermissions =>
      'Revisa los permisos o actívalo cuando quieras.';

  @override
  String get enablePermissions =>
      'Activa los permisos necesarios y después enciéndelo.';

  @override
  String get activateFocum => 'Activar Focum';

  @override
  String get deactivateFocum => 'Desactivar Focum';

  @override
  String get privacyNotice =>
      'Privacidad: las intenciones permanecen en este dispositivo. La voz es solo local. El acceso al uso de apps es opcional. Lee la política a continuación.';

  @override
  String get focumActive => 'Focum activo';

  @override
  String get activeDescription =>
      'Focum te ayudará cada vez que desbloquees tu teléfono.';

  @override
  String get allSet => 'Todo listo';

  @override
  String get permissionsGranted =>
      'Los permisos principales ya están concedidos.';

  @override
  String get deactivate => 'Desactivar';

  @override
  String get chooseBeforeEntering =>
      'Elige el motivo principal antes de entrar.';

  @override
  String get listening => 'Te escucho';

  @override
  String get intentionQuestion => '¿Para qué vas a usar el móvil ahora?';

  @override
  String get voiceIdleHint => 'Pulsa y di tu motivo';

  @override
  String get voiceRetryHint => 'Repítelo, no te he entendido';

  @override
  String get monitoringStopped => 'Focum desactivado.';

  @override
  String get overlayRequired =>
      'Permite que Focum aparezca al desbloquear para poder activarlo.';

  @override
  String get monitoringStarted =>
      'Focum está activo. Te acompañará cada vez que desbloquees.';

  @override
  String get microphoneRequired =>
      'Activa el micrófono para usar la entrada por voz.';

  @override
  String get speechUnavailable =>
      'El dictado local no está disponible. Elige una categoría manualmente.';

  @override
  String get chooseCategoryOrSpeak => 'Elige una categoría o dilo con tu voz.';

  @override
  String get intentionSaved => 'Intención registrada.';

  @override
  String get requiredPermission => 'Necesario';

  @override
  String get optionalPermission => 'Opcional';

  @override
  String get allowPermission => 'Permitir';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get grantedPermission => 'Concedido';

  @override
  String get overlayPermissionTitle => 'Mostrar al desbloquear';

  @override
  String get overlayPermissionDescription =>
      'Necesario para que Focum aparezca justo al desbloquear.';

  @override
  String get notificationPermissionTitle => 'Servicio visible';

  @override
  String get notificationPermissionDescription =>
      'Mantiene visible que Focum está activo.';

  @override
  String get microphonePermissionTitle => 'Usar la voz';

  @override
  String get microphonePermissionDescription =>
      'Te deja decir tu intención con una frase corta.';

  @override
  String get usagePermissionTitle => 'Ver app en uso';

  @override
  String get usagePermissionDescription =>
      'Permite avisarte si la app abierta no encaja con tu intención.';

  @override
  String get batteryPermissionTitle => 'Segundo plano';

  @override
  String get batteryPermissionDescription =>
      'Opcional. Ayuda a evitar cierres automáticos de Android.';

  @override
  String get manualMode => 'Manual';

  @override
  String get voiceMode => 'Voz';

  @override
  String get chooseMainReason => 'Elige el motivo principal.';

  @override
  String get tapAnIcon => 'Toca un icono';

  @override
  String get orUseMicrophone => 'o usa el micro';

  @override
  String get savedInstantly => 'Se guarda al instante';

  @override
  String get categoryLearning => 'Aprender';

  @override
  String get categoryWork => 'Trabajo';

  @override
  String get categoryPersonalGrowth => 'Desarrollo personal';

  @override
  String get categorySocial => 'Socializar';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryTravel => 'Viajes';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryOther => 'Otros';

  @override
  String get focusMismatchTitle => 'No pierdas el tiempo.';

  @override
  String focusMismatchMessage(String reason, String app) {
    return 'Dijiste que ibas a usar el móvil para $reason, pero ahora estás en $app.';
  }

  @override
  String get returnToIntention => 'Volver a lo que dije';

  @override
  String get fiveMinutesTitle => 'Llevas 5 minutos.';

  @override
  String get keepGoing => 'Sigo con ello';

  @override
  String reminderPhone(String reason) {
    return 'Llevas 5 minutos con el móvil para $reason.';
  }

  @override
  String reminderApp(String app, String reason) {
    return 'Llevas 5 minutos en $app para $reason.';
  }

  @override
  String reminderIntention(String reason) {
    return 'Llevas 5 minutos con el móvil. Dijiste que era para $reason.';
  }

  @override
  String get reopenFocum => 'Reabre Focum';

  @override
  String get activationReminder =>
      'Android puede haber pausado Focum. Abre la app y activa Focum otra vez.';

  @override
  String get statusChannelName => 'Estado de Focum';

  @override
  String get statusChannelDescription =>
      'Recordatorios diarios para reabrir Focum si Android lo detiene.';

  @override
  String get remindersChannelName => 'Recordatorios de Focum';

  @override
  String get remindersChannelDescription =>
      'Recordatorios de las intenciones guardadas al desbloquear.';

  @override
  String get monitorChannelName => 'Monitor de Focum';

  @override
  String get monitorChannelDescription =>
      'Mantiene activo el monitor de desbloqueo de Focum.';

  @override
  String get monitorNotification =>
      'Focum preguntará tu intención al desbloquear.';

  @override
  String get sayBeforeEntering => 'Dilo en una frase corta antes de entrar.';

  @override
  String get privacyTitle => 'Privacidad y datos';

  @override
  String get consentAccept => 'Aceptar';

  @override
  String get consentDecline => 'Ahora no';

  @override
  String get microphoneDisclosure =>
      'Focum usa el micrófono solo durante el dictado. El audio se procesa en este dispositivo, nunca con un reconocedor en la nube. El texto final, la categoría y la hora se guardan localmente (hasta 300 entradas) y pueden aparecer en recordatorios. La voz necesita Android 12 o posterior y un modelo local instalado. Puedes elegir una categoría sin usar el micrófono. ¿Aceptas?';

  @override
  String get usageDisclosure =>
      'Mientras Focum está activo, también en segundo plano, lee eventos recientes de uso para identificar la app en primer plano y compararla con tu intención en los recordatorios. Estos datos permanecen en el dispositivo: Focum no guarda el historial de apps ni lo envía a un servidor. Este acceso es opcional; puedes continuar sin él y revocarlo en los ajustes de Android. ¿Aceptas?';

  @override
  String get deleteData => 'Borrar datos locales';

  @override
  String get deleteDataMessage =>
      'Esto detiene Focum, borra intenciones, recordatorios, ajustes y consentimientos, y cierra la aplicación. No se puede deshacer.';

  @override
  String get privacyLanguageNote =>
      'La política completa se muestra a continuación en español e incluye el contacto y las instrucciones de borrado.';

  @override
  String get privacyLoadError =>
      'No se pudo cargar la política. Puedes consultarla en el repositorio público de Focum.';
}
