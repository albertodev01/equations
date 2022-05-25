import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/complex_result_wrapper.dart';
import 'package:equations_solver/routes/other_page/model/analyzer/wrappers/matrix_result_wrapper.dart';
import 'package:equations_solver/routes/other_page/model/other_result.dart';
import 'package:equations_solver/routes/other_page/model/other_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NonlinearState' class", () {
    test('Initial values', () {
      final otherState = OtherState();

      expect(otherState.state, equals(const OtherResult()));
    });

    test('Making sure that matrices can be analyzed and cleared', () {
      var count = 0;
      final otherState = OtherState()..addListener(() => ++count);
      expect(otherState.state, equals(const OtherResult()));

      otherState.matrixAnalyze(matrix: ['1'], size: 1);
      expect(otherState.state.results, isA<MatrixResultWrapper>());
      expect(count, equals(1));

      otherState.clear();

      expect(otherState.state, equals(const OtherResult()));
      expect(count, equals(2));
    });

    test('Making sure that complex numbers can be analyzed and cleared', () {
      var count = 0;
      final otherState = OtherState()..addListener(() => ++count);
      expect(otherState.state, equals(const OtherResult()));

      otherState.complexAnalyze(realPart: '1', imaginaryPart: '2');
      expect(otherState.state.results, isA<ComplexResultWrapper>());
      expect(count, equals(1));

      otherState.clear();

      expect(otherState.state, equals(const OtherResult()));
      expect(count, equals(2));
    });

    test('Making sure that exceptions are handled', () {
      var count = 0;
      final otherState = OtherState()..addListener(() => ++count);
      expect(otherState.state, equals(const OtherResult()));

      otherState.matrixAnalyze(matrix: [''], size: 1);
      expect(otherState.state.results, isNull);
      expect(count, equals(1));

      otherState.complexAnalyze(realPart: '1', imaginaryPart: '');
      expect(otherState.state.results, isNull);
      expect(count, equals(2));
    });
  });
}
