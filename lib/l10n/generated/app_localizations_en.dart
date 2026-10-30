// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get preparingPause => 'Preparing your pause.';

  @override
  String get setupTitle => 'Set up Focum';

  @override
  String get setupDescription =>
      'We just need a few permissions to help you use your phone with intention.';

  @override
  String get focumReady => 'Focum is ready';

  @override
  String get focumInactive => 'Focum is not active yet';

  @override
  String get reviewPermissions =>
      'Review permissions or activate it whenever you like.';

  @override
  String get enablePermissions =>
      'Allow the required permissions, then activate Focum.';

  @override
  String get activateFocum => 'Activate Focum';

  @override
  String get deactivateFocum => 'Deactivate Focum';

  @override
  String get privacyNotice =>
      'Privacy: intentions stay on this device. Voice is on-device only. App-use access is optional. Read the privacy policy below.';

  @override
  String get focumActive => 'Focum is active';

  @override
  String get activeDescription =>
      'Focum will help you each time you unlock your phone.';

  @override
  String get allSet => 'All set';

  @override
  String get permissionsGranted => 'The main permissions have been granted.';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get chooseBeforeEntering =>
      'Choose your main reason before continuing.';

  @override
  String get listening => 'I’m listening';

  @override
  String get intentionQuestion =>
      'What are you going to use your phone for now?';

  @override
  String get voiceIdleHint => 'Tap and say your reason';

  @override
  String get voiceRetryHint => 'Please repeat, I didn’t catch that';

  @override
  String get monitoringStopped => 'Focum deactivated.';

  @override
  String get overlayRequired =>
      'Allow Focum to appear when you unlock your phone before activating it.';

  @override
  String get monitoringStarted =>
      'Focum is active. It will be with you every time you unlock.';

  @override
  String get microphoneRequired => 'Enable the microphone to use voice input.';

  @override
  String get speechUnavailable =>
      'On-device speech is unavailable. Choose a category manually.';

  @override
  String get chooseCategoryOrSpeak => 'Choose a category or say your reason.';

  @override
  String get intentionSaved => 'Intention saved.';

  @override
  String get requiredPermission => 'Required';

  @override
  String get optionalPermission => 'Optional';

  @override
  String get allowPermission => 'Allow';

  @override
  String get openSettings => 'Open settings';

  @override
  String get grantedPermission => 'Granted';

  @override
  String get overlayPermissionTitle => 'Show when unlocking';

  @override
  String get overlayPermissionDescription =>
      'Required for Focum to appear as soon as you unlock.';

  @override
  String get notificationPermissionTitle => 'Visible service';

  @override
  String get notificationPermissionDescription => 'Shows that Focum is active.';

  @override
  String get microphonePermissionTitle => 'Use your voice';

  @override
  String get microphonePermissionDescription =>
      'Say your intention in a short sentence.';

  @override
  String get usagePermissionTitle => 'See the app in use';

  @override
  String get usagePermissionDescription =>
      'Lets Focum remind you if the open app doesn’t match your intention.';

  @override
  String get batteryPermissionTitle => 'Background activity';

  @override
  String get batteryPermissionDescription =>
      'Optional. Helps prevent Android from automatically stopping Focum.';

  @override
  String get manualMode => 'Manual';

  @override
  String get voiceMode => 'Voice';

  @override
  String get chooseMainReason => 'Choose your main reason.';

  @override
  String get tapAnIcon => 'Tap an icon';

  @override
  String get orUseMicrophone => 'or use the microphone';

  @override
  String get savedInstantly => 'Saved instantly';

  @override
  String get categoryLearning => 'Learning';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryPersonalGrowth => 'Personal growth';

  @override
  String get categorySocial => 'Social';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryOther => 'Other';

  @override
  String get focusMismatchTitle => 'Stay focused.';

  @override
  String focusMismatchMessage(String reason, String app) {
    return 'You said you would use your phone for $reason, but now you’re in $app.';
  }

  @override
  String get returnToIntention => 'Return to my intention';

  @override
  String get fiveMinutesTitle => 'It’s been 5 minutes.';

  @override
  String get keepGoing => 'I’m still on it';

  @override
  String reminderPhone(String reason) {
    return 'You’ve been using your phone for 5 minutes for $reason.';
  }

  @override
  String reminderApp(String app, String reason) {
    return 'You’ve spent 5 minutes in $app for $reason.';
  }

  @override
  String reminderIntention(String reason) {
    return 'You’ve been using your phone for 5 minutes. You said it was for $reason.';
  }

  @override
  String get reopenFocum => 'Reopen Focum';

  @override
  String get activationReminder =>
      'Android may have paused Focum. Open the app and activate Focum again.';

  @override
  String get statusChannelName => 'Focum status';

  @override
  String get statusChannelDescription =>
      'Daily reminders to reopen Focum if Android stops it.';

  @override
  String get remindersChannelName => 'Focum reminders';

  @override
  String get remindersChannelDescription =>
      'Reminders for saved unlock intentions.';

  @override
  String get monitorChannelName => 'Focum monitor';

  @override
  String get monitorChannelDescription =>
      'Keeps Focum’s unlock monitor active.';

  @override
  String get monitorNotification =>
      'Focum will ask your intention when you unlock.';

  @override
  String get sayBeforeEntering =>
      'Say it in a short sentence before continuing.';

  @override
  String get privacyTitle => 'Privacy and data';

  @override
  String get consentAccept => 'Allow';

  @override
  String get consentDecline => 'Not now';

  @override
  String get microphoneDisclosure =>
      'Focum uses the microphone only during voice input. Audio is processed on this device, never by a cloud recognizer. The final text, category and time are saved locally (up to 300 entries) and may appear in reminders. Voice needs Android 12 or later and an installed on-device model. You can choose a category without using the microphone. Do you agree?';

  @override
  String get usageDisclosure =>
      'While Focum is active, including in the background, it reads recent app-use events to identify the app in the foreground and compare it with your intention for reminders. This stays on the device: app-use history is not saved by Focum or sent to a server. This access is optional; you can continue without it and revoke it in Android settings. Do you agree?';

  @override
  String get deleteData => 'Delete local data';

  @override
  String get deleteDataMessage =>
      'This stops Focum, deletes intentions, reminders, settings and consent choices, and closes the app. This cannot be undone.';

  @override
  String get privacyLanguageNote =>
      'The full privacy policy below is in Spanish. Contact and data deletion instructions are included.';

  @override
  String get privacyLoadError =>
      'Could not load the privacy policy. You can find it in the public Focum repository.';
}
