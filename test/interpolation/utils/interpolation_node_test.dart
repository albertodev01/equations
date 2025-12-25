import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('InterpolationNode', () {
    test(
      'Smoke test',
      () {
        const node = InterpolationNode(
          x: 1.5,
          y: 3,
        );

        expect(node.x, equals(1.5));
        expect(node.y, equals(3));
        expect('$node', equals('(1.5; 3.0)'));
      },
    );

    test(
      'toString()',
      () {
        const node = InterpolationNode(
          x: 1.5,
          y: 3.546,
        );

        expect('$node', equals('(1.5; 3.546)'));
        expect(node.toStringAsFixed(2), equals('(1.50, 3.55)'));
      },
    );

    test('Object comparison.', () {
      const node = InterpolationNode(
        x: 1.5,
        y: 3,
      );

      expect(
        node,
        equals(
          const InterpolationNode(
            x: 1.5,
            y: 3,
          ),
        ),
      );

      expect(
        const InterpolationNode(
          x: 1.5,
          y: 3,
        ),
        equals(node),
      );

      expect(
        node ==
            const InterpolationNode(
              x: 1.5,
              y: 3,
            ),
        isTrue,
      );

      expect(
        const InterpolationNode(
              x: 1.5,
              y: 3,
            ) ==
            node,
        isTrue,
      );

      expect(
        node ==
            const InterpolationNode(
              x: 1.5,
              y: -3,
            ),
        isFalse,
      );

      expect(
        node == node,
        isTrue,
      );

      expect(
        node.hashCode,
        equals(
          const InterpolationNode(
            x: 1.5,
            y: 3,
          ).hashCode,
        ),
      );
    });
  });
}
