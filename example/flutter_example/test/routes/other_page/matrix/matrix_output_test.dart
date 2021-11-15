import 'package:equations/equations.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_output.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'MatrixOutput' widget", () {
    testWidgets(
      'Making sure that the widget renders ',
      (tester) async {
        await tester.pumpWidget(MockWrapper(
          child: MatrixOutput(
            matrix: RealMatrix.diagonal(rows: 2, columns: 2, diagonalValue: 3),
            description: 'Demo',
          ),
        ));

        expect(find.byType(MatrixOutput), findsOneWidget);
        expect(find.text('Demo'), findsOneWidget);
        expect(find.byType(Table), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(4));
      },
    );

    testWidgets(
      "Making sure that 'didUpdateWidget' is executed",
      (tester) async {
        var matrixSize = 2;

        await tester.pumpWidget(MockWrapper(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MatrixOutput(
                    matrix: RealMatrix.diagonal(
                      rows: matrixSize,
                      columns: matrixSize,
                      diagonalValue: 3,
                    ),
                    description: 'Demo',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        matrixSize = matrixSize == 2 ? 3 : 2;
                      });
                    },
                    child: const Text('Rebuild'),
                  ),
                ],
              );
            },
          ),
        ));

        expect(find.byType(TextFormField), findsNWidgets(4));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsNWidgets(9));
      },
    );

    testGoldens('MatrixOutput', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          '1x1 matrix',
          MatrixOutput(
            matrix: RealMatrix.diagonal(rows: 1, columns: 1, diagonalValue: 3),
            description: '1x1',
          ),
        )
        ..addScenario(
          '2x2 matrix',
          MatrixOutput(
            matrix: RealMatrix.fromFlattenedData(
              rows: 2,
              columns: 2,
              data: [1.01, 2.456, 3.0254, -4.2],
            ),
            description: '2x2',
          ),
        )
        ..addScenario(
          '2x2 matrix (no decimals)',
          MatrixOutput(
            matrix: RealMatrix.fromFlattenedData(
              rows: 2,
              columns: 2,
              data: [1.01, 2.456, 3.0254, -4.2],
            ),
            description: '2x2',
            decimalDigits: 1,
          ),
        )
        ..addScenario(
          '3x3 matrix',
          MatrixOutput(
            matrix: RealMatrix.fromFlattenedData(
              rows: 3,
              columns: 3,
              data: [6, -7, 3, 5, -6, 0, -1, 2, 8],
            ),
            description: '3x3',
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(350, 800),
      );
      await screenMatchesGolden(tester, 'matrix_output_widget');
    });
  });
}
