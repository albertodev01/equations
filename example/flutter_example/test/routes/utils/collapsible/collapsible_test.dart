import 'package:equations_solver/blocs/expansion_cubit/expansion_cubit.dart';
import 'package:equations_solver/routes/utils/collapsible/collapsible.dart';
import 'package:equations_solver/routes/utils/collapsible/primary_region.dart';
import 'package:equations_solver/routes/utils/collapsible/secondary_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'Collapsible' widget.", () {
    testWidgets(
      "Making sure that 'Collapsible' can be rendered",
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<ExpansionCubit>(
              create: (_) => ExpansionCubit(),
              child: const Collapsible(
                header: Text('Header'),
                content: Text('Contents'),
              ),
            ),
          ),
        );

        expect(find.byType(PrimaryRegion), findsOneWidget);
        expect(find.byType(SecondaryRegion), findsOneWidget);
        expect(find.byType(SizeTransition), findsOneWidget);

        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Contents'), findsOneWidget);
      },
    );

    testWidgets("Making sure that 'Collapsible' is tappable", (tester) async {
      final bloc = ExpansionCubit();

      await tester.pumpWidget(
        MockWrapper(
          child: BlocProvider<ExpansionCubit>.value(
            value: bloc,
            child: const Collapsible(
              header: Text('Header'),
              content: Text('Contents'),
            ),
          ),
        ),
      );

      final sizeTransition = tester.widget<SizeTransition>(
        find.byType(SizeTransition),
      );

      expect(bloc.state, isFalse);
      expect(sizeTransition.sizeFactor.value, isZero);

      // Running the animation
      await tester.tap(find.byType(PrimaryRegion));
      await tester.pumpAndSettle();

      // Making sure the secondary region is visible
      expect(bloc.state, isTrue);
      expect(sizeTransition.sizeFactor.value, equals(1));

      // Tapping again to close
      await tester.tap(find.byType(PrimaryRegion));
      await tester.pumpAndSettle();

      // Making sure the secondary region is not visible anymore
      expect(bloc.state, isFalse);
      expect(sizeTransition.sizeFactor.value, isZero);
    });

    testWidgets(
      "Making sure that 'didUpdateWidget' is executed to update the header",
      (tester) async {
        var headerValue = 0;

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<ExpansionCubit>(
              create: (_) => ExpansionCubit(),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Collapsible(
                        header: Text('header-$headerValue'),
                        content: const Text('Contents'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            headerValue = headerValue == 0 ? 1 : 0;
                          });
                        },
                        child: const Text('Rebuild'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('header-0'), findsOneWidget);
        expect(find.text('header-1'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('header-1'), findsOneWidget);
        expect(find.text('header-0'), findsNothing);
      },
    );

    testWidgets(
      "Making sure that 'didUpdateWidget' is executed to update the contents",
      (tester) async {
        var contentValue = 0;

        await tester.pumpWidget(
          MockWrapper(
            child: BlocProvider<ExpansionCubit>(
              create: (_) => ExpansionCubit(),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Collapsible(
                        header: const Text('Header'),
                        content: Text('contents-$contentValue'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            contentValue = contentValue == 0 ? 1 : 0;
                          });
                        },
                        child: const Text('Rebuild'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('contents-0'), findsOneWidget);
        expect(find.text('contents-1'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('contents-1'), findsOneWidget);
        expect(find.text('contents-0'), findsNothing);
      },
    );

    testGoldens('Collapsible', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Closed',
          BlocProvider<ExpansionCubit>(
            create: (_) => ExpansionCubit(),
            child: const Collapsible(
              header: Text('Header'),
              content: Text('Contents'),
            ),
          ),
        )
        ..addScenario(
          'Opened',
          BlocProvider<ExpansionCubit>(
            create: (_) => ExpansionCubit(),
            child: const Collapsible(
              header: Text('Header'),
              content: Text('Contents'),
              initializeOpened: true,
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(150, 250),
      );
      await screenMatchesGolden(tester, 'collapsible');
    });
  });
}
