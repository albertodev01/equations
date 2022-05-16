import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyze_results.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyzer_input.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'MatrixOtherBody' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NumberSwitcherCubit>(
                create: (_) => NumberSwitcherCubit(min: 2, max: 5),
              ),
              BlocProvider<OtherBloc>(
                create: (_) => OtherBloc(),
              ),
            ],
            child: const MatrixOtherBody(),
          ),
        ),
      );

      expect(find.byType(MatrixOtherBody), findsOneWidget);
      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(MatrixAnalyzerInput), findsOneWidget);
      expect(find.byType(MatrixAnalyzerResults), findsOneWidget);
    });
  });
}
