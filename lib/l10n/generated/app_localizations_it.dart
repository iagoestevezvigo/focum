// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get preparingPause => 'Prepariamo la tua pausa.';

  @override
  String get setupTitle => 'Configura Focum';

  @override
  String get setupDescription =>
      'Servono solo alcune autorizzazioni per aiutarti a usare il telefono con intenzione.';

  @override
  String get focumReady => 'Focum è pronto';

  @override
  String get focumInactive => 'Focum non è ancora attivo';

  @override
  String get reviewPermissions =>
      'Controlla le autorizzazioni o attivalo quando vuoi.';

  @override
  String get enablePermissions =>
      'Concedi le autorizzazioni necessarie, poi attiva Focum.';

  @override
  String get activateFocum => 'Attiva Focum';

  @override
  String get deactivateFocum => 'Disattiva Focum';

  @override
  String get privacyNotice =>
      'Privacy: salviamo data, ora, categoria e testo finale. L’audio viene elaborato dal servizio di riconoscimento vocale del dispositivo.';

  @override
  String get focumActive => 'Focum è attivo';

  @override
  String get activeDescription =>
      'Focum ti aiuterà ogni volta che sblocchi il telefono.';

  @override
  String get allSet => 'Tutto pronto';

  @override
  String get permissionsGranted =>
      'Le autorizzazioni principali sono state concesse.';

  @override
  String get deactivate => 'Disattiva';

  @override
  String get chooseBeforeEntering =>
      'Scegli il motivo principale prima di continuare.';

  @override
  String get listening => 'Ti ascolto';

  @override
  String get intentionQuestion => 'Per cosa userai il telefono adesso?';

  @override
  String get voiceIdleHint => 'Tocca e di’ il tuo motivo';

  @override
  String get voiceRetryHint => 'Ripeti, non ho capito';

  @override
  String get monitoringStopped => 'Focum disattivato.';

  @override
  String get overlayRequired =>
      'Consenti a Focum di apparire allo sblocco prima di attivarlo.';

  @override
  String get monitoringStarted =>
      'Focum è attivo. Ti accompagnerà a ogni sblocco.';

  @override
  String get microphoneRequired =>
      'Attiva il microfono per usare l’input vocale.';

  @override
  String get speechUnavailable =>
      'Il riconoscimento vocale non è disponibile su questo dispositivo.';

  @override
  String get chooseCategoryOrSpeak =>
      'Scegli una categoria o di’ il tuo motivo.';

  @override
  String get intentionSaved => 'Intenzione salvata.';

  @override
  String get requiredPermission => 'Necessario';

  @override
  String get optionalPermission => 'Facoltativo';

  @override
  String get allowPermission => 'Consenti';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get grantedPermission => 'Concesso';

  @override
  String get overlayPermissionTitle => 'Mostra allo sblocco';

  @override
  String get overlayPermissionDescription =>
      'Necessario perché Focum appaia appena sblocchi il telefono.';

  @override
  String get notificationPermissionTitle => 'Servizio visibile';

  @override
  String get notificationPermissionDescription => 'Mostra che Focum è attivo.';

  @override
  String get microphonePermissionTitle => 'Usa la voce';

  @override
  String get microphonePermissionDescription =>
      'Esprimi la tua intenzione con una breve frase.';

  @override
  String get usagePermissionTitle => 'Vedi l’app in uso';

  @override
  String get usagePermissionDescription =>
      'Permette a Focum di avvisarti se l’app aperta non corrisponde alla tua intenzione.';

  @override
  String get batteryPermissionTitle => 'Attività in background';

  @override
  String get batteryPermissionDescription =>
      'Facoltativo. Aiuta a evitare che Android interrompa Focum automaticamente.';

  @override
  String get manualMode => 'Manuale';

  @override
  String get voiceMode => 'Voce';

  @override
  String get chooseMainReason => 'Scegli il motivo principale.';

  @override
  String get tapAnIcon => 'Tocca un’icona';

  @override
  String get orUseMicrophone => 'o usa il microfono';

  @override
  String get savedInstantly => 'Salvato all’istante';

  @override
  String get categoryLearning => 'Imparare';

  @override
  String get categoryWork => 'Lavoro';

  @override
  String get categoryPersonalGrowth => 'Crescita personale';

  @override
  String get categorySocial => 'Socializzare';

  @override
  String get categoryHealth => 'Salute';

  @override
  String get categoryTravel => 'Viaggi';

  @override
  String get categoryPersonal => 'Personale';

  @override
  String get categoryOther => 'Altro';

  @override
  String get focusMismatchTitle => 'Resta concentrato.';

  @override
  String focusMismatchMessage(String reason, String app) {
    return 'Avevi detto di usare il telefono per $reason, ma ora sei su $app.';
  }

  @override
  String get returnToIntention => 'Torna alla mia intenzione';

  @override
  String get fiveMinutesTitle => 'Sono passati 5 minuti.';

  @override
  String get keepGoing => 'Sto continuando';

  @override
  String reminderPhone(String reason) {
    return 'Stai usando il telefono da 5 minuti per $reason.';
  }

  @override
  String reminderApp(String app, String reason) {
    return 'Sei su $app da 5 minuti per $reason.';
  }

  @override
  String reminderIntention(String reason) {
    return 'Stai usando il telefono da 5 minuti. Avevi detto che era per $reason.';
  }

  @override
  String get reopenFocum => 'Riapri Focum';

  @override
  String get activationReminder =>
      'Android potrebbe aver messo in pausa Focum. Apri l’app e riattiva Focum.';

  @override
  String get statusChannelName => 'Stato di Focum';

  @override
  String get statusChannelDescription =>
      'Promemoria giornalieri per riaprire Focum se Android lo interrompe.';

  @override
  String get remindersChannelName => 'Promemoria Focum';

  @override
  String get remindersChannelDescription =>
      'Promemoria delle intenzioni salvate allo sblocco.';

  @override
  String get monitorChannelName => 'Monitor Focum';

  @override
  String get monitorChannelDescription =>
      'Mantiene attivo il monitor di sblocco di Focum.';

  @override
  String get monitorNotification =>
      'Focum chiederà la tua intenzione allo sblocco.';

  @override
  String get sayBeforeEntering =>
      'Dillo con una breve frase prima di continuare.';
}
