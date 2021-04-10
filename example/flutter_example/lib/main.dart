import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:equations_solver/routes.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Registering fonts licences
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Running the app
  runApp(const EquationsApp());
}

/// The root widget of the app.
class EquationsApp extends StatelessWidget {
  /// Creates an [EquationsApp] instance.
  const EquationsApp();

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
      theme: ThemeData.light().copyWith(textTheme: GoogleFonts.latoTextTheme()),

      // Hiding the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
