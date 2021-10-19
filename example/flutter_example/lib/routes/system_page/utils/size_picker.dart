import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget has 2 arrows that, respectively, decrease and increase value
/// held in the state of the [NumberSwitcherCubit] bloc.
class SizePicker extends StatelessWidget {
  /// Creates a [SizePicker] widget.
  const SizePicker({Key? key}) : super(key: key);

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
          onPressed: () => context.read<NumberSwitcherCubit>().decrease(),
          child: const Icon(Icons.arrow_back),
        ),

        // Spacing
        const SizedBox(width: 15),

        // The size
        BlocBuilder<NumberSwitcherCubit, int>(
          builder: (context, state) {
            late final String text;

            switch (state) {
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
              default:
                throw RangeError("'state' is not in the range!");
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
          onPressed: () => context.read<NumberSwitcherCubit>().increase(),
          child: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
