import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's main entrypoint.
///
/// The [LicenseRegistry.addLicense] call cab be ignored by the code coverage
/// tool since it will be tested by integration tests.
void main() {
  // coverage:ignore-start
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  // coverage:ignore-end

  // Running the app
  runApp(const EquationsApp());
}

/// The root widget of the app.
class EquationsApp extends StatelessWidget {
  /// Creates an [EquationsApp] instance.
  const EquationsApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Route management
      onGenerateRoute: RouteGenerator.generateRoute,

      // Localized app title
      onGenerateTitle: (context) => context.l10n.appTitle,

      // Localization setup
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Theme
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.latoTextTheme(),
      ),

      // Hiding the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
