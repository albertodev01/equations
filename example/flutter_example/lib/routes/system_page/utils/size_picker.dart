import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/models/text_controllers/inherited_text_controllers.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyzer_input.dart';
import 'package:equations_solver/routes/other_page/model/inherited_other.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/system_data_input.dart';
import 'package:flutter/material.dart';

/// This widget has 2 arrows that, respectively, decrease and increase the value
/// store in [NumberSwitcherState].
class SizePicker extends StatelessWidget {
  /// Whether this widget is used inside the [MatrixAnalyzerInput] page or not.
  ///
  /// When `false`, it means that this widget is used within [SystemDataInput].
  final bool isInOtherPage;

  /// Creates a [SizePicker] widget.
  const SizePicker({
    required this.isInOtherPage,
    super.key,
  });

  /// Ensures that, whenever the matrix size changes, the form is cleared.
  void _clearState(BuildContext context) {
    if (isInOtherPage) {
      for (final controller in context.textControllers) {
        controller.clear();
      }
      context.otherState.clear();
    } else {
      for (final controller
          in context.systemTextControllers.matrixControllers) {
        controller.clear();
      }
      for (final controller
          in context.systemTextControllers.vectorControllers) {
        controller.clear();
      }
      for (final controller
          in context.systemTextControllers.jacobiControllers) {
        controller.clear();
      }

      context.systemTextControllers.wSorController.clear();
      context.systemState.clear();
    }

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrease
        ElevatedButton(
          key: const Key('SizePicker-Back-Button'),
          style: ButtonStyle(
            shape: WidgetStateProperty.all(const CircleBorder()),
          ),
          onPressed: () {
            context.numberSwitcherState.decrease();
            _clearState(context);
          },
          child: const Icon(Icons.arrow_back),
        ),

        // Spacing
        const SizedBox(width: 15),

        // The size
        ListenableBuilder(
          listenable: context.numberSwitcherState,
          builder: (context, _) {
            final text = switch (context.numberSwitcherState.state) {
              1 => context.l10n.matrix_size1,
              2 => context.l10n.matrix_size2,
              3 => context.l10n.matrix_size3,
              4 => context.l10n.matrix_size4,
              _ => '-'
            };

            return Text(
              text,
              style: const TextStyle(
                fontSize: 15,
              ),
            );
          },
        ),

        // Spacing
        const SizedBox(width: 15),

        // Increase
        ElevatedButton(
          key: const Key('SizePicker-Forward-Button'),
          style: ButtonStyle(
            shape: WidgetStateProperty.all(const CircleBorder()),
          ),
          onPressed: () {
            context.numberSwitcherState.increase();
            _clearState(context);
          },
          child: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
