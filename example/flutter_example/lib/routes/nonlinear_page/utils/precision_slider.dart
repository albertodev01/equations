import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/models/precision_slider/inherited_precision_slider.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// Sets the precision of the currently selected algorithm.
class PrecisionSlider extends StatelessWidget {
  /// Creates a [PrecisionSlider] widget.
  const PrecisionSlider({super.key});

  void _update(BuildContext context, double value) =>
      context.precisionState.updateSlider(value);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimensions) {
        var defaultWidth = precisonSliderWidth;

        if (dimensions.maxWidth <= precisonSliderWidth + 50) {
          defaultWidth = defaultWidth * 1.5;
        }

        return SizedBox(
          width: defaultWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slider
              AnimatedBuilder(
                animation: context.precisionState,
                builder: (context, state) {
                  return Slider(
                    min: 2,
                    max: 15,
                    value: context.precisionState.value,
                    onChanged: (value) => _update(context, value),
                  );
                },
              ),

              const SizedBox(height: 15),

              // Labels
              const _SliderLabels(),
            ],
          ),
        );
      },
    );
  }
}

/// The text next to the [Slider] in the [PrecisionSlider] widget.
class _SliderLabels extends StatelessWidget {
  const _SliderLabels();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The precision of the slider
          Text(context.l10n.precision),

          // The label representing the precision
          AnimatedBuilder(
            animation: context.precisionState,
            builder: (context, state) {
              return Text('1.0e-${context.precisionState.value.round()}');
            },
          ),
        ],
      ),
    );
  }
}
