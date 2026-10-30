// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get preparingPause => 'Deine Pause wird vorbereitet.';

  @override
  String get setupTitle => 'Focum einrichten';

  @override
  String get setupDescription =>
      'Wir brauchen ein paar Berechtigungen, damit du dein Handy bewusst nutzen kannst.';

  @override
  String get focumReady => 'Focum ist bereit';

  @override
  String get focumInactive => 'Focum ist noch nicht aktiv';

  @override
  String get reviewPermissions =>
      'Prüfe die Berechtigungen oder aktiviere es, wenn du möchtest.';

  @override
  String get enablePermissions =>
      'Erteile die nötigen Berechtigungen und aktiviere dann Focum.';

  @override
  String get activateFocum => 'Focum aktivieren';

  @override
  String get deactivateFocum => 'Focum deaktivieren';

  @override
  String get privacyNotice =>
      'Datenschutz: Absichten bleiben auf diesem Gerät. Spracheingabe erfolgt nur lokal. App-Nutzungszugriff ist freiwillig. Lesen Sie die Richtlinie unten.';

  @override
  String get focumActive => 'Focum ist aktiv';

  @override
  String get activeDescription =>
      'Focum hilft dir jedes Mal, wenn du dein Handy entsperrst.';

  @override
  String get allSet => 'Alles bereit';

  @override
  String get permissionsGranted =>
      'Die wichtigsten Berechtigungen wurden erteilt.';

  @override
  String get deactivate => 'Deaktivieren';

  @override
  String get chooseBeforeEntering =>
      'Wähle deinen Hauptgrund, bevor du weitermachst.';

  @override
  String get listening => 'Ich höre zu';

  @override
  String get intentionQuestion => 'Wofür möchtest du dein Handy jetzt nutzen?';

  @override
  String get voiceIdleHint => 'Tippe und nenne deinen Grund';

  @override
  String get voiceRetryHint =>
      'Bitte wiederhole das, ich habe dich nicht verstanden';

  @override
  String get monitoringStopped => 'Focum wurde deaktiviert.';

  @override
  String get overlayRequired =>
      'Erlaube Focum, beim Entsperren zu erscheinen, bevor du es aktivierst.';

  @override
  String get monitoringStarted =>
      'Focum ist aktiv und begleitet dich bei jedem Entsperren.';

  @override
  String get microphoneRequired =>
      'Aktiviere das Mikrofon für die Spracheingabe.';

  @override
  String get speechUnavailable =>
      'Lokale Spracherkennung ist nicht verfügbar. Wählen Sie eine Kategorie manuell.';

  @override
  String get chooseCategoryOrSpeak =>
      'Wähle eine Kategorie oder nenne deinen Grund.';

  @override
  String get intentionSaved => 'Absicht gespeichert.';

  @override
  String get requiredPermission => 'Erforderlich';

  @override
  String get optionalPermission => 'Optional';

  @override
  String get allowPermission => 'Erlauben';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get grantedPermission => 'Erteilt';

  @override
  String get overlayPermissionTitle => 'Beim Entsperren anzeigen';

  @override
  String get overlayPermissionDescription =>
      'Damit Focum direkt beim Entsperren erscheinen kann.';

  @override
  String get notificationPermissionTitle => 'Sichtbarer Dienst';

  @override
  String get notificationPermissionDescription =>
      'Zeigt an, dass Focum aktiv ist.';

  @override
  String get microphonePermissionTitle => 'Spracheingabe nutzen';

  @override
  String get microphonePermissionDescription =>
      'Nenne deine Absicht in einem kurzen Satz.';

  @override
  String get usagePermissionTitle => 'Genutzte App erkennen';

  @override
  String get usagePermissionDescription =>
      'Focum kann dich erinnern, wenn die geöffnete App nicht zu deiner Absicht passt.';

  @override
  String get batteryPermissionTitle => 'Hintergrundaktivität';

  @override
  String get batteryPermissionDescription =>
      'Optional. Hilft zu verhindern, dass Android Focum automatisch beendet.';

  @override
  String get manualMode => 'Manuell';

  @override
  String get voiceMode => 'Sprache';

  @override
  String get chooseMainReason => 'Wähle deinen Hauptgrund.';

  @override
  String get tapAnIcon => 'Tippe auf ein Symbol';

  @override
  String get orUseMicrophone => 'oder nutze das Mikrofon';

  @override
  String get savedInstantly => 'Sofort gespeichert';

  @override
  String get categoryLearning => 'Lernen';

  @override
  String get categoryWork => 'Arbeit';

  @override
  String get categoryPersonalGrowth => 'Persönliche Entwicklung';

  @override
  String get categorySocial => 'Soziales';

  @override
  String get categoryHealth => 'Gesundheit';

  @override
  String get categoryTravel => 'Reisen';

  @override
  String get categoryPersonal => 'Privates';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get focusMismatchTitle => 'Bleib bei deiner Absicht.';

  @override
  String focusMismatchMessage(String reason, String app) {
    return 'Du wolltest dein Handy für $reason nutzen, bist aber jetzt in $app.';
  }

  @override
  String get returnToIntention => 'Zurück zu meiner Absicht';

  @override
  String get fiveMinutesTitle => '5 Minuten sind vergangen.';

  @override
  String get keepGoing => 'Ich bin noch dabei';

  @override
  String reminderPhone(String reason) {
    return 'Du nutzt dein Handy seit 5 Minuten für $reason.';
  }

  @override
  String reminderApp(String app, String reason) {
    return 'Du bist seit 5 Minuten in $app für $reason.';
  }

  @override
  String reminderIntention(String reason) {
    return 'Du nutzt dein Handy seit 5 Minuten. Du wolltest es für $reason nutzen.';
  }

  @override
  String get reopenFocum => 'Focum erneut öffnen';

  @override
  String get activationReminder =>
      'Android hat Focum möglicherweise angehalten. Öffne die App und aktiviere Focum erneut.';

  @override
  String get statusChannelName => 'Focum-Status';

  @override
  String get statusChannelDescription =>
      'Tägliche Erinnerungen, Focum erneut zu öffnen, wenn Android es beendet.';

  @override
  String get remindersChannelName => 'Focum-Erinnerungen';

  @override
  String get remindersChannelDescription =>
      'Erinnerungen an die beim Entsperren gespeicherten Absichten.';

  @override
  String get monitorChannelName => 'Focum-Überwachung';

  @override
  String get monitorChannelDescription =>
      'Hält die Entsperrüberwachung von Focum aktiv.';

  @override
  String get monitorNotification =>
      'Focum fragt dich beim Entsperren nach deiner Absicht.';

  @override
  String get sayBeforeEntering =>
      'Nenne deinen Grund in einem kurzen Satz, bevor du weitermachst.';

  @override
  String get privacyTitle => 'Datenschutz und Daten';

  @override
  String get consentAccept => 'Zustimmen';

  @override
  String get consentDecline => 'Jetzt nicht';

  @override
  String get microphoneDisclosure =>
      'Focum verwendet das Mikrofon nur beim Diktieren. Audio wird auf diesem Gerät verarbeitet, niemals in der Cloud. Der fertige Text, die Kategorie und die Uhrzeit werden lokal gespeichert (bis zu 300 Einträge) und können in Erinnerungen erscheinen. Spracheingabe erfordert Android 12 oder neuer und ein installiertes lokales Modell. Kategorien können ohne Mikrofon gewählt werden. Stimmen Sie zu?';

  @override
  String get usageDisclosure =>
      'Während Focum aktiv ist, auch im Hintergrund, liest es aktuelle Nutzungsereignisse, um die App im Vordergrund mit Ihrer Absicht für Erinnerungen abzugleichen. Diese Daten bleiben auf dem Gerät: Focum speichert keinen App-Verlauf und sendet ihn nicht an einen Server. Der Zugriff ist freiwillig und kann in Android widerrufen werden. Stimmen Sie zu?';

  @override
  String get deleteData => 'Lokale Daten löschen';

  @override
  String get deleteDataMessage =>
      'Dies beendet Focum, löscht Absichten, Erinnerungen, Einstellungen und Einwilligungen und schließt die App. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get privacyLanguageNote =>
      'Die vollständige Richtlinie unten ist auf Spanisch und enthält Kontakt und Löschanleitung.';

  @override
  String get privacyLoadError =>
      'Die Richtlinie konnte nicht geladen werden. Sie finden sie im öffentlichen Focum-Repository.';
}
