import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equations_solver/blocs/slider/slider.dart';

/// Sets the precision of the currently selected algorithm.
class PrecisionSlider extends StatelessWidget {
  /// Creates a [PrecisionSlider] wiget.
  const PrecisionSlider();

  void _update(BuildContext context, double value) =>
      context.read<SliderBloc>().add(value);

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
              BlocBuilder<SliderBloc, double>(
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
                    const Text('Precision'),
                    BlocBuilder<SliderBloc, double>(
                      builder: (context, state) => Text('1.0e-$state'),
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