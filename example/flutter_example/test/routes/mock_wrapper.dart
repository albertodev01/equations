import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/expansion_cubit/expansion_cubit.dart';
import 'package:equations_solver/blocs/integral_solver/bloc/bloc.dart';
import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/blocs/nonlinear_solver/bloc/bloc.dart';
import 'package:equations_solver/blocs/nonlinear_solver/models/nonlinear_types.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/bloc/bloc.dart';
import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/blocs/precision_slider/precision_slider.dart';
import 'package:equations_solver/blocs/system_solver/bloc/bloc.dart';
import 'package:equations_solver/blocs/system_solver/models/system_types.dart';
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

  /// The initial value of the [DropdownCubit].
  ///
  /// By default, this is an empty string.
  final String dropdownInitial;

  /// Creates a [MockWrapper] widget.
  const MockWrapper({
    super.key,
    required this.child,
    this.navigatorObservers = const [],
    this.dropdownInitial = '',
  });

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DropdownCubit>(
            create: (_) => DropdownCubit(
              initialValue: dropdownInitial,
            ),
          ),
          BlocProvider<ExpansionCubit>(
            create: (_) => ExpansionCubit(),
          ),
          BlocProvider<IntegralBloc>(
            create: (_) => IntegralBloc(),
          ),
          BlocProvider<NavigationCubit>(
            create: (_) => NavigationCubit(),
          ),
          BlocProvider<NonlinearBloc>(
            create: (_) => NonlinearBloc(NonlinearType.singlePoint),
          ),
          BlocProvider<NumberSwitcherCubit>(
            create: (_) => NumberSwitcherCubit(
              min: 1,
              max: 10,
            ),
          ),
          BlocProvider<OtherBloc>(
            create: (_) => OtherBloc(),
          ),
          BlocProvider<PlotZoomCubit>(
            create: (_) => PlotZoomCubit(
              maxValue: 10,
              minValue: 1,
              initial: 4,
            ),
          ),
          BlocProvider<PrecisionSliderCubit>(
            create: (_) => PrecisionSliderCubit(
              minValue: 1,
              maxValue: 10,
            ),
          ),
          BlocProvider<SystemBloc>(
            create: (_) => SystemBloc(SystemType.factorization),
          ),
          BlocProvider<TextFieldValuesCubit>(
            create: (_) => TextFieldValuesCubit(),
          ),
        ],
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }
}
