import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:equations_solver/routes/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget contains a series of [PolynomialInputField] widgets needed to
/// parse the values of the matrix of the system in the `Ax = b` equation.
class SystemDataInput extends StatefulWidget {
  /// Creates a [SystemDataInput] widget.
  const SystemDataInput();

  @override
  _SystemDataInputState createState() => _SystemDataInputState();
}

class _SystemDataInputState extends State<SystemDataInput> {
  /// The text input controllers for the matrix.
  ///
  /// This is asking for `A` in the `Ax = b` equation where:
  ///
  ///  - `A` is the matrix
  ///  - `b` is the known values vector
  late final matrixControllers = List<TextEditingController>.generate(16, (_) {
    return TextEditingController();
  });

  /// The text input controllers for the vector.
  ///
  /// This is asking for `b` in the `Ax = b` equation where:
  ///
  ///  - `A` is the matrix
  ///  - `b` is the known values vector
  late final vectorControllers = List<TextEditingController>.generate(4, (_) {
    return TextEditingController();
  });

  /// Form validation key.
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (final controller in matrixControllers) {
      controller.dispose();
    }

    for (final controller in vectorControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Some spacing
          const SizedBox(
            height: 60,
          ),

          // Size changer
          const SizePicker(),

          // Some spacing
          const SizedBox(
            height: 35,
          ),

          // Matrix input
          BlocBuilder<NumberSwitcherCubit, int>(
            builder: (context, state) => MatrixInput(
              matrixControllers: matrixControllers,
              matrixSize: state,
            ),
          ),

          // Some spacing
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
