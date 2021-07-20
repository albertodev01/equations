import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the 'InterpolationNode' type", () {
    test(
        "Making sure that a 'InterpolationNode' object is properly constructed",
        () {
      const node = InterpolationNode(
        x: 1.5,
        y: 3,
      );

      expect(node.x, equals(1.5));
      expect(node.y, equals(3));
    });

    test('Making sure that the instance is correctly converted into a string',
        () {
      const node = InterpolationNode(
        x: 1.5,
        y: 3.546,
      );

      expect('$node', equals('(1.5, 3.546)'));
      expect(node.toStringAsFixed(2), equals('(1.50, 3.55)'));
    });

    test('Making sure that objects comparison works properly', () {
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
        node ==
            const InterpolationNode(
              x: 1.5,
              y: 3,
            ),
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
        equals(const InterpolationNode(
          x: 1.5,
          y: 3,
        ).hashCode),
      );
    });
  });
}
