import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';

/// This widget allows the input of the initial guesses vector of the Jacobi
/// algorithm.
class JacobiVectorInput extends StatelessWidget {
  /// Creates a [JacobiVectorInput] widget.
  const JacobiVectorInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<String>(
        valueListenable: context.dropdownValue,
        builder: (context, value, child) {
          final jacobiItems = SystemDropdownItems.jacobi.asString;

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
              AnimatedBuilder(
                animation: context.numberSwitcherState,
                builder: (context, _) {
                  return VectorInput(
                    vectorControllers:
                        context.systemTextControllers.jacobiControllers,
                    vectorSize: context.numberSwitcherState.state,
                  );
                },
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
