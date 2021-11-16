import 'package:equations_solver/routes/utils/plot_widget/color_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'ColorArea' class", () {
    test('Making sure that default values are correct', () {
      const colorArea = ColorArea(
        startPoint: 1,
        endPoint: 2,
      );

      expect(colorArea.startPoint, equals(1));
      expect(colorArea.endPoint, equals(2));
      expect(colorArea.color, equals(Colors.transparent));
    });

    test('Making sure that object comparison works properly', () {
      const colorArea = ColorArea(
        startPoint: 3.6,
        endPoint: 10,
        color: Colors.blue,
      );

      expect(
        colorArea,
        equals(
          const ColorArea(
            startPoint: 3.6,
            endPoint: 10,
            color: Colors.blue,
          ),
        ),
      );

      expect(
        const ColorArea(
          startPoint: 3.6,
          endPoint: 10,
          color: Colors.blue,
        ),
        equals(colorArea),
      );

      expect(
        colorArea.hashCode ==
            const ColorArea(
              startPoint: 3.6,
              endPoint: 10,
              color: Colors.blue,
            ).hashCode,
        isTrue,
      );

      expect(
        colorArea ==
            const ColorArea(
              startPoint: 3.6,
              endPoint: 10.1,
              color: Colors.blue,
            ),
        isFalse,
      );

      expect(
        colorArea ==
            const ColorArea(
              startPoint: 3.6,
              endPoint: 10,
              color: Colors.red,
            ),
        isFalse,
      );

      expect(
        colorArea ==
            const ColorArea(
              startPoint: 3,
              endPoint: 10,
            ),
        isFalse,
      );
    });
  });
}
