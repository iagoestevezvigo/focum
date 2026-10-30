import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @preparingPause.
  ///
  /// In en, this message translates to:
  /// **'Preparing your pause.'**
  String get preparingPause;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up Focum'**
  String get setupTitle;

  /// No description provided for @setupDescription.
  ///
  /// In en, this message translates to:
  /// **'We just need a few permissions to help you use your phone with intention.'**
  String get setupDescription;

  /// No description provided for @focumReady.
  ///
  /// In en, this message translates to:
  /// **'Focum is ready'**
  String get focumReady;

  /// No description provided for @focumInactive.
  ///
  /// In en, this message translates to:
  /// **'Focum is not active yet'**
  String get focumInactive;

  /// No description provided for @reviewPermissions.
  ///
  /// In en, this message translates to:
  /// **'Review permissions or activate it whenever you like.'**
  String get reviewPermissions;

  /// No description provided for @enablePermissions.
  ///
  /// In en, this message translates to:
  /// **'Allow the required permissions, then activate Focum.'**
  String get enablePermissions;

  /// No description provided for @activateFocum.
  ///
  /// In en, this message translates to:
  /// **'Activate Focum'**
  String get activateFocum;

  /// No description provided for @deactivateFocum.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Focum'**
  String get deactivateFocum;

  /// No description provided for @privacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Privacy: we store the date, time, category and final text. Audio is processed by your device’s speech recognition service.'**
  String get privacyNotice;

  /// No description provided for @focumActive.
  ///
  /// In en, this message translates to:
  /// **'Focum is active'**
  String get focumActive;

  /// No description provided for @activeDescription.
  ///
  /// In en, this message translates to:
  /// **'Focum will help you each time you unlock your phone.'**
  String get activeDescription;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'All set'**
  String get allSet;

  /// No description provided for @permissionsGranted.
  ///
  /// In en, this message translates to:
  /// **'The main permissions have been granted.'**
  String get permissionsGranted;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @chooseBeforeEntering.
  ///
  /// In en, this message translates to:
  /// **'Choose your main reason before continuing.'**
  String get chooseBeforeEntering;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'I’m listening'**
  String get listening;

  /// No description provided for @intentionQuestion.
  ///
  /// In en, this message translates to:
  /// **'What are you going to use your phone for now?'**
  String get intentionQuestion;

  /// No description provided for @voiceIdleHint.
  ///
  /// In en, this message translates to:
  /// **'Tap and say your reason'**
  String get voiceIdleHint;

  /// No description provided for @voiceRetryHint.
  ///
  /// In en, this message translates to:
  /// **'Please repeat, I didn’t catch that'**
  String get voiceRetryHint;

  /// No description provided for @monitoringStopped.
  ///
  /// In en, this message translates to:
  /// **'Focum deactivated.'**
  String get monitoringStopped;

  /// No description provided for @overlayRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow Focum to appear when you unlock your phone before activating it.'**
  String get overlayRequired;

  /// No description provided for @monitoringStarted.
  ///
  /// In en, this message translates to:
  /// **'Focum is active. It will be with you every time you unlock.'**
  String get monitoringStarted;

  /// No description provided for @microphoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enable the microphone to use voice input.'**
  String get microphoneRequired;

  /// No description provided for @speechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device.'**
  String get speechUnavailable;

  /// No description provided for @chooseCategoryOrSpeak.
  ///
  /// In en, this message translates to:
  /// **'Choose a category or say your reason.'**
  String get chooseCategoryOrSpeak;

  /// No description provided for @intentionSaved.
  ///
  /// In en, this message translates to:
  /// **'Intention saved.'**
  String get intentionSaved;

  /// No description provided for @requiredPermission.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredPermission;

  /// No description provided for @optionalPermission.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalPermission;

  /// No description provided for @allowPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allowPermission;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @grantedPermission.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get grantedPermission;

  /// No description provided for @overlayPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Show when unlocking'**
  String get overlayPermissionTitle;

  /// No description provided for @overlayPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Required for Focum to appear as soon as you unlock.'**
  String get overlayPermissionDescription;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Visible service'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Shows that Focum is active.'**
  String get notificationPermissionDescription;

  /// No description provided for @microphonePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Use your voice'**
  String get microphonePermissionTitle;

  /// No description provided for @microphonePermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Say your intention in a short sentence.'**
  String get microphonePermissionDescription;

  /// No description provided for @usagePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'See the app in use'**
  String get usagePermissionTitle;

  /// No description provided for @usagePermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Lets Focum remind you if the open app doesn’t match your intention.'**
  String get usagePermissionDescription;

  /// No description provided for @batteryPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Background activity'**
  String get batteryPermissionTitle;

  /// No description provided for @batteryPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional. Helps prevent Android from automatically stopping Focum.'**
  String get batteryPermissionDescription;

  /// No description provided for @manualMode.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manualMode;

  /// No description provided for @voiceMode.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceMode;

  /// No description provided for @chooseMainReason.
  ///
  /// In en, this message translates to:
  /// **'Choose your main reason.'**
  String get chooseMainReason;

  /// No description provided for @tapAnIcon.
  ///
  /// In en, this message translates to:
  /// **'Tap an icon'**
  String get tapAnIcon;

  /// No description provided for @orUseMicrophone.
  ///
  /// In en, this message translates to:
  /// **'or use the microphone'**
  String get orUseMicrophone;

  /// No description provided for @savedInstantly.
  ///
  /// In en, this message translates to:
  /// **'Saved instantly'**
  String get savedInstantly;

  /// No description provided for @categoryLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get categoryLearning;

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categoryPersonalGrowth.
  ///
  /// In en, this message translates to:
  /// **'Personal growth'**
  String get categoryPersonalGrowth;

  /// No description provided for @categorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get categorySocial;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @focusMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay focused.'**
  String get focusMismatchTitle;

  /// No description provided for @focusMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'You said you would use your phone for {reason}, but now you’re in {app}.'**
  String focusMismatchMessage(String reason, String app);

  /// No description provided for @returnToIntention.
  ///
  /// In en, this message translates to:
  /// **'Return to my intention'**
  String get returnToIntention;

  /// No description provided for @fiveMinutesTitle.
  ///
  /// In en, this message translates to:
  /// **'It’s been 5 minutes.'**
  String get fiveMinutesTitle;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'I’m still on it'**
  String get keepGoing;

  /// No description provided for @reminderPhone.
  ///
  /// In en, this message translates to:
  /// **'You’ve been using your phone for 5 minutes for {reason}.'**
  String reminderPhone(String reason);

  /// No description provided for @reminderApp.
  ///
  /// In en, this message translates to:
  /// **'You’ve spent 5 minutes in {app} for {reason}.'**
  String reminderApp(String app, String reason);

  /// No description provided for @reminderIntention.
  ///
  /// In en, this message translates to:
  /// **'You’ve been using your phone for 5 minutes. You said it was for {reason}.'**
  String reminderIntention(String reason);

  /// No description provided for @reopenFocum.
  ///
  /// In en, this message translates to:
  /// **'Reopen Focum'**
  String get reopenFocum;

  /// No description provided for @activationReminder.
  ///
  /// In en, this message translates to:
  /// **'Android may have paused Focum. Open the app and activate Focum again.'**
  String get activationReminder;

  /// No description provided for @statusChannelName.
  ///
  /// In en, this message translates to:
  /// **'Focum status'**
  String get statusChannelName;

  /// No description provided for @statusChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders to reopen Focum if Android stops it.'**
  String get statusChannelDescription;

  /// No description provided for @remindersChannelName.
  ///
  /// In en, this message translates to:
  /// **'Focum reminders'**
  String get remindersChannelName;

  /// No description provided for @remindersChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders for saved unlock intentions.'**
  String get remindersChannelDescription;

  /// No description provided for @monitorChannelName.
  ///
  /// In en, this message translates to:
  /// **'Focum monitor'**
  String get monitorChannelName;

  /// No description provided for @monitorChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Keeps Focum’s unlock monitor active.'**
  String get monitorChannelDescription;

  /// No description provided for @monitorNotification.
  ///
  /// In en, this message translates to:
  /// **'Focum will ask your intention when you unlock.'**
  String get monitorNotification;

  /// No description provided for @sayBeforeEntering.
  ///
  /// In en, this message translates to:
  /// **'Say it in a short sentence before continuing.'**
  String get sayBeforeEntering;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
