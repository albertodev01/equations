import 'package:equatable/equatable.dart';

/// Events for the [ThemeBloc] bloc
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

/// Implements the dart theme for the app
class DarkEvent extends ThemeEvent {
  const DarkEvent();
}

/// Implements the light theme for the app
class LightEvent extends ThemeEvent {
  const LightEvent();
}