import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Exporting the 'AppLocalizations' type so that the user can reference only
// this file to get access to all of the localization facilities
export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension method on [BuildContext] which reduces the boilerplate code needed
/// to localize the text in the app. Rather than writing...
///
/// ```dart
/// final text = AppLocalizations?.of(context)!.appTitle;
/// ```
///
/// ... there's the possibility to use a shorter syntax:
///
/// ```dart
/// final text = context.l10n.appTitle;
/// ```
extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}