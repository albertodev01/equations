import 'package:equations_solver/blocs/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:equations_solver/routes.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Running the app
  runApp(const EquationsApp());
}

/// The root widget of the app
class EquationsApp extends StatelessWidget {
  const EquationsApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        // Manages the theme state of the app
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),

      ],
      child: const _MaterialWidget(),
    );
  }
}

/// The material widget containing the whole app. It also applies the "light" or
/// "dark" theme, which is determined by the state of the bloc.
class _MaterialWidget extends StatelessWidget {
  const _MaterialWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return MaterialApp(
          // Route management
          onGenerateRoute: RouteGenerator.generateRoute,

          // Localized app title
          onGenerateTitle: (context) => context.l10n.appTitle,

          // Localization setup
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // The dynamic theming
          theme: state.themeData,

          // Hiding the debug banner
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}