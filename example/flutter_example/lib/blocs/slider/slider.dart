import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the state of a material [Slider] widget. In particular,
/// [SliderBloc] stores the currently selected value of the slider
class SliderBloc extends Bloc<double, double> {
  /// The minimum value of the slider.
  final double minValue;

  /// The maximum value of the slider.
  final double maxValue;

  /// The default value of the slider.
  final double current;

  /// By default, the minimum value of the slider is `2`
  SliderBloc({
    required this.minValue,
    required this.maxValue,
    required this.current,
  }) : super(current);

  @override
  Stream<double> mapEventToState(double event) async* {
    if ((event >= minValue) && (event <= maxValue)) {
      yield event;
    }
  }
}
