import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// A wrapper of a [MaterialApp] with localization support to be used in widget
/// tests.
class MockWrapper extends StatelessWidget {
  /// The child to be tested.
  final Widget child;

  /// This is useful when there's the need to make sure that a route is pushed
  /// or popped.
  final List<NavigatorObserver> navigatorObservers;

  /// Creates a [MockWrapper] widget.
  const MockWrapper({
    Key? key,
    required this.child,
    this.navigatorObservers = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: navigatorObservers,
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<TextFieldValuesCubit>(
        create: (_) => TextFieldValuesCubit(),
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }
}
