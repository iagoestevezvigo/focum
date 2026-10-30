// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get preparingPause => 'Préparation de votre pause.';

  @override
  String get setupTitle => 'Configurer Focum';

  @override
  String get setupDescription =>
      'Quelques autorisations suffisent pour vous aider à utiliser votre téléphone avec intention.';

  @override
  String get focumReady => 'Focum est prêt';

  @override
  String get focumInactive => 'Focum n’est pas encore actif';

  @override
  String get reviewPermissions =>
      'Vérifiez les autorisations ou activez-le quand vous voulez.';

  @override
  String get enablePermissions =>
      'Accordez les autorisations nécessaires, puis activez Focum.';

  @override
  String get activateFocum => 'Activer Focum';

  @override
  String get deactivateFocum => 'Désactiver Focum';

  @override
  String get privacyNotice =>
      'Confidentialité : nous enregistrons la date, l’heure, la catégorie et le texte final. L’audio est traité par le service de reconnaissance vocale de votre appareil.';

  @override
  String get focumActive => 'Focum est actif';

  @override
  String get activeDescription =>
      'Focum vous accompagnera à chaque déverrouillage de votre téléphone.';

  @override
  String get allSet => 'Tout est prêt';

  @override
  String get permissionsGranted =>
      'Les autorisations principales ont été accordées.';

  @override
  String get deactivate => 'Désactiver';

  @override
  String get chooseBeforeEntering =>
      'Choisissez votre raison principale avant de continuer.';

  @override
  String get listening => 'Je vous écoute';

  @override
  String get intentionQuestion =>
      'Pourquoi allez-vous utiliser votre téléphone maintenant ?';

  @override
  String get voiceIdleHint => 'Appuyez et dites votre raison';

  @override
  String get voiceRetryHint => 'Répétez, je n’ai pas compris';

  @override
  String get monitoringStopped => 'Focum est désactivé.';

  @override
  String get overlayRequired =>
      'Autorisez Focum à s’afficher au déverrouillage avant de l’activer.';

  @override
  String get monitoringStarted =>
      'Focum est actif. Il vous accompagnera à chaque déverrouillage.';

  @override
  String get microphoneRequired =>
      'Activez le microphone pour utiliser la saisie vocale.';

  @override
  String get speechUnavailable =>
      'La reconnaissance vocale n’est pas disponible sur cet appareil.';

  @override
  String get chooseCategoryOrSpeak =>
      'Choisissez une catégorie ou dites votre raison.';

  @override
  String get intentionSaved => 'Intention enregistrée.';

  @override
  String get requiredPermission => 'Nécessaire';

  @override
  String get optionalPermission => 'Facultatif';

  @override
  String get allowPermission => 'Autoriser';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get grantedPermission => 'Accordé';

  @override
  String get overlayPermissionTitle => 'Afficher au déverrouillage';

  @override
  String get overlayPermissionDescription =>
      'Nécessaire pour que Focum apparaisse dès le déverrouillage.';

  @override
  String get notificationPermissionTitle => 'Service visible';

  @override
  String get notificationPermissionDescription =>
      'Indique que Focum est actif.';

  @override
  String get microphonePermissionTitle => 'Utiliser la voix';

  @override
  String get microphonePermissionDescription =>
      'Exprimez votre intention en une courte phrase.';

  @override
  String get usagePermissionTitle => 'Voir l’application utilisée';

  @override
  String get usagePermissionDescription =>
      'Permet à Focum de vous avertir si l’application ouverte ne correspond pas à votre intention.';

  @override
  String get batteryPermissionTitle => 'Activité en arrière-plan';

  @override
  String get batteryPermissionDescription =>
      'Facultatif. Aide à empêcher Android d’arrêter Focum automatiquement.';

  @override
  String get manualMode => 'Manuel';

  @override
  String get voiceMode => 'Voix';

  @override
  String get chooseMainReason => 'Choisissez votre raison principale.';

  @override
  String get tapAnIcon => 'Touchez une icône';

  @override
  String get orUseMicrophone => 'ou utilisez le microphone';

  @override
  String get savedInstantly => 'Enregistré instantanément';

  @override
  String get categoryLearning => 'Apprendre';

  @override
  String get categoryWork => 'Travail';

  @override
  String get categoryPersonalGrowth => 'Développement personnel';

  @override
  String get categorySocial => 'Échanger';

  @override
  String get categoryHealth => 'Santé';

  @override
  String get categoryTravel => 'Voyages';

  @override
  String get categoryPersonal => 'Personnel';

  @override
  String get categoryOther => 'Autre';

  @override
  String get focusMismatchTitle => 'Gardez le cap.';

  @override
  String focusMismatchMessage(String reason, String app) {
    return 'Vous aviez dit utiliser votre téléphone pour $reason, mais vous êtes maintenant sur $app.';
  }

  @override
  String get returnToIntention => 'Revenir à mon intention';

  @override
  String get fiveMinutesTitle => 'Cela fait 5 minutes.';

  @override
  String get keepGoing => 'Je continue';

  @override
  String reminderPhone(String reason) {
    return 'Vous utilisez votre téléphone depuis 5 minutes pour $reason.';
  }

  @override
  String reminderApp(String app, String reason) {
    return 'Vous êtes sur $app depuis 5 minutes pour $reason.';
  }

  @override
  String reminderIntention(String reason) {
    return 'Vous utilisez votre téléphone depuis 5 minutes. Vous aviez dit que c’était pour $reason.';
  }

  @override
  String get reopenFocum => 'Rouvrez Focum';

  @override
  String get activationReminder =>
      'Android a peut-être mis Focum en pause. Ouvrez l’application et réactivez Focum.';

  @override
  String get statusChannelName => 'État de Focum';

  @override
  String get statusChannelDescription =>
      'Rappels quotidiens pour rouvrir Focum si Android l’arrête.';

  @override
  String get remindersChannelName => 'Rappels Focum';

  @override
  String get remindersChannelDescription =>
      'Rappels des intentions enregistrées au déverrouillage.';

  @override
  String get monitorChannelName => 'Suivi Focum';

  @override
  String get monitorChannelDescription =>
      'Maintient le suivi du déverrouillage de Focum actif.';

  @override
  String get monitorNotification =>
      'Focum vous demandera votre intention au déverrouillage.';

  @override
  String get sayBeforeEntering =>
      'Dites-le en une courte phrase avant de continuer.';
}
