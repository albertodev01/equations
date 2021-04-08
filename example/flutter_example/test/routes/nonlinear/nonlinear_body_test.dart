import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../bloc_mocks.dart';
import '../mock_wrapper.dart';

void main() {
  setUpAll(() {
    registerFallbackValue<NonlinearEvent>(MockNonlinearEvent());
    registerFallbackValue<NonlinearState>(MockNonlinearState());
  });

  group("Testing the 'NonlinearBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NonlinearBloc>(
          create: (_) => NonlinearBloc(NonlinearType.singlePoint),
          child: const Scaffold(body: NonlinearBody()),
        ),
      ));

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(NonlinearDataInput), findsOneWidget);
      expect(find.byType(NonlinearResults), findsOneWidget);
    });

    testWidgets(
        'Making sure that the widget is responsive - small screens '
        'test', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: BlocProvider<NonlinearBloc>(
          create: (_) => NonlinearBloc(NonlinearType.singlePoint),
          child: const Scaffold(
            body: SizedBox(
              width: 800,
              child: NonlinearBody(),
            ),
          ),
        ),
      ));

      expect(
        find.byKey(const Key('SingleChildScrollView-mobile-responsive')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('SingleChildScrollView-desktop-responsive')),
        findsNothing,
      );
    });
  });
}
