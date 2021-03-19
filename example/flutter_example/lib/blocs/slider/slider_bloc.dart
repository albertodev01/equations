import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This bloc handles the state of a material [Slider] widget. In particular,
/// [SliderBloc] stores the currently selected value of the slider
class SliderBloc extends Bloc<double, double> {
  /// The minimum value of the slider
  final double minValue;

  /// By default, the minimum value of the slider is `2`
  SliderBloc({
    this.minValue = 2,
  }) : super(minValue);

  @override
  Stream<double> mapEventToState(double event) async* {
    if (event >= minValue) {
      yield event;
    }
  }
}
