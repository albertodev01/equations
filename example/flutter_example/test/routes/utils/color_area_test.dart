import 'package:equations_solver/routes/utils/plot_widget/color_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'ColorArea' class", () {
    test('Making sure that default values are correct', () {
      const obj = ColorArea(
        startPoint: 6,
        endPoint: 19,
      );

      expect(obj.color, equals(Colors.transparent));
      expect(obj.startPoint, equals(6));
      expect(obj.endPoint, equals(19));

      expect('$obj', equals('Color(0x00000000) from 6.00 to 19.00'));
    });

    test('Making sure that a custom color can be set', () {
      const obj = ColorArea(
        startPoint: -1,
        endPoint: 2,
        color: Colors.red,
      );

      expect(obj.color, equals(Colors.red));
      expect(obj.startPoint, equals(-1));
      expect(obj.endPoint, equals(2));
    });

    test('Making sure that instances can be properly compared.', () {
      const colorArea = ColorArea(
        startPoint: 6,
        endPoint: 19,
      );

      expect(
        colorArea ==
            const ColorArea(
              startPoint: 6,
              endPoint: 19,
            ),
        isTrue,
      );

      expect(
        colorArea.hashCode,
        equals(
          const ColorArea(
            startPoint: 6,
            endPoint: 19,
          ).hashCode,
        ),
      );

      expect(
        colorArea ==
            const ColorArea(
              startPoint: -6,
              endPoint: 19,
            ),
        isFalse,
      );
      expect(
        colorArea ==
            const ColorArea(
              startPoint: 6,
              endPoint: 19,
              color: Colors.orange,
            ),
        isFalse,
      );
    });
  });
}
