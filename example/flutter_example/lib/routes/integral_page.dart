import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/blocs/plot_zoom/plot_zoom.dart';
import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page contains a series of integral evaluation algorithms. There only
/// is a single page where the user simply writes the equation and then the
/// algorithm evaluates the integral.
///
/// The function is also plotted and the area is highlighted on the chart.
class IntegralPage extends StatelessWidget {
  /// Creates a [IntegralPage] widget.
  const IntegralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IntegralBloc>(
          create: (_) => IntegralBloc(),
        ),
        BlocProvider<PlotZoomCubit>(
          create: (_) => PlotZoomCubit(
            minValue: 2,
            maxValue: 10,
            initial: 3,
          ),
        ),
        BlocProvider<DropdownCubit>(
          create: (_) => DropdownCubit(
            initialValue: IntegralDropdownItems.simpson.asString(),
          ),
        ),
        BlocProvider<TextFieldValuesCubit>(
          create: (_) => TextFieldValuesCubit(),
        ),
      ],
      child: const EquationScaffold(
        body: IntegralBody(),
      ),
    );
  }
}
