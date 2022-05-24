import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';

/// This widget allows the input of the initial guesses vector of the Jacobi
/// algorithm.
class JacobiVectorInput extends StatelessWidget {
  /// The controller needed to parse the initial guesses vector.
  final List<TextEditingController> controllers;

  /// The size of the vector.
  final int vectorSize;

  /// Creates a [JacobiVectorInput] widget.
  const JacobiVectorInput({
    super.key,
    required this.controllers,
    required this.vectorSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<String>(
        valueListenable: context.dropdownValue,
        builder: (context, value, child) {
          final jacobiItems = SystemDropdownItems.jacobi.asString();

          if (value.toLowerCase() == jacobiItems.toLowerCase()) {
            return child!;
          }

          // Nothing is displayed if the chosen method isn't 'Jacobi'.
          return const SizedBox.shrink();
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 35,
            bottom: 10,
          ),
          child: Column(
            key: const Key('Jacobi-Vector-Input-Column'),
            children: [
              // Input.
              VectorInput(
                vectorControllers: controllers,
                vectorSize: vectorSize,
              ),

              // Some spacing.
              const SizedBox(height: 15),

              // A label that describes what 'w' is.
              Text(
                context.l10n.jacobi_initial,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
