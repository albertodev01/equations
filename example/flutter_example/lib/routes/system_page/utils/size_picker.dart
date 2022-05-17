import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:flutter/material.dart';

/// This widget has 2 arrows that, respectively, decrease and increase value
/// held in the state of the [NumberSwitcherCubit] bloc.
class SizePicker extends StatelessWidget {
  /// Creates a [SizePicker] widget.
  const SizePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrease
        ElevatedButton(
          key: const Key('SizePicker-Back-Button'),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
          ),
          onPressed: context.numberSwitcherState.decrease,
          child: const Icon(Icons.arrow_back),
        ),

        // Spacing
        const SizedBox(width: 15),

        // The size
        AnimatedBuilder(
          animation: context.numberSwitcherState,
          builder: (context, _) {
            late final String text;

            switch (context.numberSwitcherState.state) {
              case 1:
                text = context.l10n.matrix_size1;
                break;
              case 2:
                text = context.l10n.matrix_size2;
                break;
              case 3:
                text = context.l10n.matrix_size3;
                break;
              case 4:
                text = context.l10n.matrix_size4;
                break;
              case 5:
                text = context.l10n.matrix_size5;
                break;
            }

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
            shape: MaterialStateProperty.all(const CircleBorder()),
          ),
          onPressed: context.numberSwitcherState.increase,
          child: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
