import 'package:flutter/widgets.dart';
import 'package:focum/l10n/generated/app_localizations.dart';

export 'package:focum/l10n/generated/app_localizations.dart';

extension FocumLocalizations on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Use the same resolution as MaterialApp for services without a BuildContext.
AppLocalizations resolveAppLocalizations(List<Locale> preferredLocales) {
  final locale = basicLocaleListResolution(
    preferredLocales,
    AppLocalizations.supportedLocales,
  );
  return lookupAppLocalizations(locale);
}
