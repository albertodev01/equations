import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:flutter/material.dart';

/// This very simple widget allows the input of the relaxation factor `w` of the
/// SOR system solving algorithm.
class RelaxationFactorInput extends StatelessWidget {
  /// Creates a [RelaxationFactorInput] widget.
  const RelaxationFactorInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 35,
        bottom: 10,
      ),
      child: Column(
        children: [
          // Input
          SystemInputField(
            key: const Key('SystemSolver-Iterative-RelaxationFactor'),
            controller: context.systemTextControllers.wSorController,
            placeholder: 'w',
          ),

          // Some spacing
          const SizedBox(height: 15),

          // A label that describes what 'w' is
          Text(
            context.l10n.sor_w,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
