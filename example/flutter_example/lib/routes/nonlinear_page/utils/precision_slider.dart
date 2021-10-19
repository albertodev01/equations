import 'package:equations_solver/blocs/slider/slider.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sets the precision of the currently selected algorithm.
class PrecisionSlider extends StatelessWidget {
  /// Creates a [PrecisionSlider] widget.
  const PrecisionSlider({Key? key}) : super(key: key);

  void _update(BuildContext context, double value) =>
      context.read<SliderCubit>().updateSlider(value);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimensions) {
        var defaultWidth = 300.0;

        if (dimensions.maxWidth <= 350) {
          defaultWidth = defaultWidth * 1.5;
        }

        return SizedBox(
          width: defaultWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slider
              BlocBuilder<SliderCubit, double>(
                builder: (context, state) {
                  return Slider(
                    min: 2,
                    max: 15,
                    value: state,
                    divisions: 13,
                    onChanged: (value) => _update(context, value),
                  );
                },
              ),

              const SizedBox(height: 15),

              // Labels
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // The precision of the slider
                    Text(context.l10n.precision),

                    // The label representing the precision
                    BlocBuilder<SliderCubit, double>(
                      builder: (_, state) {
                        return Text('1.0e-${state.round()}');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
