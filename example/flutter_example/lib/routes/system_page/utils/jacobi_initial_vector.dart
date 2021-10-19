import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget allows the input of the initial guesses vector of the Jacobi
/// algorithm.
class JacobiVectorInput extends StatefulWidget {
  /// The controller needed to parse the initial guesses vector.
  final List<TextEditingController> controllers;

  /// The size of the vector.
  final int vectorSize;

  /// Creates a [JacobiVectorInput] widget.
  const JacobiVectorInput({
    Key? key,
    required this.controllers,
    required this.vectorSize,
  }) : super(key: key);

  @override
  _JacobiVectorInputState createState() => _JacobiVectorInputState();
}

class _JacobiVectorInputState extends State<JacobiVectorInput> {
  /// Caching the input widget.
  late Widget inputWidget = buildInput();

  /// Builds the input widget.
  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 35,
        bottom: 10,
      ),
      child: Column(
        children: [
          // Input
          VectorInput(
            vectorControllers: widget.controllers,
            vectorSize: widget.vectorSize,
          ),

          // Some spacing
          const SizedBox(height: 15),

          // A label that describes what 'w' is
          Text(
            context.l10n.jacobi_initial,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant JacobiVectorInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.vectorSize != oldWidget.vectorSize) {
      inputWidget = buildInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DropdownCubit, String>(
        builder: (context, state) {
          if (state.toLowerCase() == 'jacobi') {
            return inputWidget;
          }

          // Nothing is displayed if the chosen method isn't 'Jacobi'
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
