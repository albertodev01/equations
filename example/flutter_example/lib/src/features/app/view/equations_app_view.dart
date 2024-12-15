import 'package:equations_solver/src/features/app/models/theme.dart';
import 'package:equations_solver/src/features/app/routes/app_router.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

/// The root widget of the application.
class EquationsAppView extends StatelessWidget {
  /// Creates an [EquationsAppView] widget.
  const EquationsAppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      onGenerateTitle: (context) => context.l10n.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: const _CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: appTheme,
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

    // Show scroll bars when scrolling vertically but only on desktop.
    switch (Theme.of(context).platform) {
      // coverage:ignore-start
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
      // coverage:ignore-end
    }
  }
}
