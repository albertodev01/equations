import 'package:equations/equations.dart';
import 'package:equations_solver/routes/system_page/model/system_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'NonlinearResult' class", () {
    test('Initial values', () {
      final systemResult = SystemResult(
        systemSolver: LUSolver(
          matrix: RealMatrix.fromData(
            columns: 2,
            rows: 2,
            data: const [
              [3, -1],
              [1, 0]
            ],
          ),
          knownValues: const [1, 2],
        ),
      );

      expect(systemResult.systemSolver, isA<LUSolver>());
    });

    test('Making sure that objects can be properly compared', () {
      final systemResult = SystemResult(
        systemSolver: LUSolver(
          matrix: RealMatrix.fromData(
            columns: 2,
            rows: 2,
            data: const [
              [3, -1],
              [1, 0]
            ],
          ),
          knownValues: const [1, 2],
        ),
      );

      expect(
        systemResult,
        equals(SystemResult(
          systemSolver: LUSolver(
            matrix: RealMatrix.fromData(
              columns: 2,
              rows: 2,
              data: const [
                [3, -1],
                [1, 0]
              ],
            ),
            knownValues: const [1, 2],
          ),
        )),
      );

      expect(
        SystemResult(
          systemSolver: LUSolver(
            matrix: RealMatrix.fromData(
              columns: 2,
              rows: 2,
              data: const [
                [3, -1],
                [1, 0]
              ],
            ),
            knownValues: const [1, 2],
          ),
        ),
        systemResult,
      );

      expect(
        systemResult ==
            SystemResult(
              systemSolver: LUSolver(
                matrix: RealMatrix.fromData(
                  columns: 2,
                  rows: 2,
                  data: const [
                    [3, -1],
                    [1, 0]
                  ],
                ),
                knownValues: const [1, 2],
              ),
            ),
        isTrue,
      );

      expect(
        SystemResult(
              systemSolver: LUSolver(
                matrix: RealMatrix.fromData(
                  columns: 2,
                  rows: 2,
                  data: const [
                    [3, -1],
                    [1, 0]
                  ],
                ),
                knownValues: const [1, 2],
              ),
            ) ==
            systemResult,
        isTrue,
      );

      expect(
        SystemResult(
              systemSolver: LUSolver(
                matrix: RealMatrix.fromData(
                  columns: 2,
                  rows: 2,
                  data: const [
                    [3, 1],
                    [1, 0]
                  ],
                ),
                knownValues: const [1, 2],
              ),
            ) ==
            systemResult,
        isFalse,
      );

      expect(
        systemResult.hashCode,
        equals(
          SystemResult(
            systemSolver: LUSolver(
              matrix: RealMatrix.fromData(
                columns: 2,
                rows: 2,
                data: const [
                  [3, -1],
                  [1, 0]
                ],
              ),
              knownValues: const [1, 2],
            ),
          ).hashCode,
        ),
      );
    });
  });
}
