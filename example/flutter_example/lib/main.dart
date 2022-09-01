import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's main entrypoint.
///
/// The [LicenseRegistry.addLicense] call can be ignored by the code coverage
/// tool since it will be tested by integration tests.
void main() {
  // coverage:ignore-start
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  // coverage:ignore-end

  // Running the app
  runApp(
    const EquationsApp(),
  );
}

/// The root widget of the app.
class EquationsApp extends StatelessWidget {
  static final _appRouter = generateRouter();

  /// The current app version. This is shown in the home page.
  static const version = '1.0.0';

  /// Creates an [EquationsApp] instance.
  const EquationsApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Route management
      routerDelegate: _appRouter.routerDelegate,
      routeInformationParser: _appRouter.routeInformationParser,
      routeInformationProvider: _appRouter.routeInformationProvider,

      // Localized app title
      onGenerateTitle: (context) => context.l10n.appTitle,

      // Localization setup
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Theme
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.latoTextTheme(),
      ),

      // Hides scroll bars on mobile but always shows them on desktop
      scrollBehavior: const _CustomScrollBehavior(),

      // Hiding the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}

/// This custom implementation of [MaterialScrollBehavior] makes the scroll bar
/// **always** visible on desktop platforms.
///
/// On mobile devices, the scroll bar never appears.
class _CustomScrollBehavior extends MaterialScrollBehavior {
  /// Creates a [_CustomScrollBehavior] configuration.
  const _CustomScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // No scroll bars in the horizontal axis
    if (axisDirectionToAxis(details.direction) == Axis.horizontal) {
      return child;
    }

    // Show scroll bars when scrolling vertically but only on desktop
    switch (Theme.of(context).platform) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return Scrollbar(
          controller: details.controller,
          thumbVisibility: true,
          child: child,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return child;
    }
  }
}
