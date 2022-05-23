import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group('Testing vectorial images', () {
    testWidgets('ArrowUpSvg', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ArrowUpSvg(),
        ),
      );

      expect(find.byType(ArrowUpSvg), findsOneWidget);
      expect(const ArrowUpSvg().assetName, equals('arrow_up'));
    });

    testWidgets('OtherComplexNumbers', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: OtherComplexNumbers(),
        ),
      );

      expect(find.byType(OtherComplexNumbers), findsOneWidget);
      expect(const OtherComplexNumbers().assetName, equals('tools_imaginary'));
    });

    testWidgets('OtherMatrix', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: OtherMatrix(),
        ),
      );

      expect(find.byType(OtherMatrix), findsOneWidget);
      expect(const OtherMatrix().assetName, equals('tools_matrix'));
    });

    testWidgets('SquareMatrix', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: SquareMatrix(),
        ),
      );

      expect(find.byType(SquareMatrix), findsOneWidget);
      expect(const SquareMatrix().assetName, equals('square_matrix'));
    });

    testWidgets('SquareRoot', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: SquareRoot(),
        ),
      );

      expect(find.byType(SquareRoot), findsOneWidget);
      expect(const SquareRoot().assetName, equals('square-root-simple'));
    });

    testWidgets('HalfRightAngle', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: HalfRightAngle(),
        ),
      );

      expect(find.byType(HalfRightAngle), findsOneWidget);
      expect(const HalfRightAngle().assetName, equals('angle'));
    });

    testWidgets('PlotIcon', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: PlotIcon(),
        ),
      );

      expect(find.byType(PlotIcon), findsOneWidget);
      expect(const PlotIcon().assetName, equals('plot'));
    });

    testWidgets('EquationSolution', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: EquationSolution(),
        ),
      );

      expect(find.byType(EquationSolution), findsOneWidget);
      expect(const EquationSolution().assetName, equals('solutions'));
    });

    testWidgets('Atoms', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Atoms(),
        ),
      );

      expect(find.byType(Atoms), findsOneWidget);
      expect(const Atoms().assetName, equals('atoms'));
    });

    testWidgets('UrlError', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: UrlError(),
        ),
      );

      expect(find.byType(UrlError), findsOneWidget);
      expect(const UrlError().assetName, equals('url_error'));
    });
  });
}
