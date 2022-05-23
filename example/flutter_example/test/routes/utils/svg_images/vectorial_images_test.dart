import 'package:equations_solver/routes/utils/svg_images/svg_image.dart';
import 'package:equations_solver/routes/utils/svg_images/types/vectorial_images.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group('Golden tests - vectorial images', () {
    testWidgets('ArrowUpSvg', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ArrowUpSvg(
            size: 500,
          ),
        ),
      );
      await expectLater(
        find.byType(SvgImage),
        matchesGoldenFile('goldens/vectorial_arrow_up.png'),
      );
    });
  });
}
