import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_analyzer_input.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_analyzer_results.dart';
import 'package:equations_solver/routes/other_page/complex_numbers_body.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'ComplexNumberOtherBody' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NumberSwitcherCubit>(
              create: (_) => NumberSwitcherCubit(min: 2, max: 5),
            ),
            BlocProvider<OtherBloc>(
              create: (_) => OtherBloc(),
            ),
          ],
          child: const ComplexNumberOtherBody(),
        ),
      ));

      expect(find.byType(ComplexNumberOtherBody), findsOneWidget);
      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(ComplexAnalyzerInput), findsOneWidget);
      expect(find.byType(ComplexNumberAnalyzerResult), findsOneWidget);
    });
  });
}
