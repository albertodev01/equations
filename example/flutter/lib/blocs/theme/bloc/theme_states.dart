import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// States for the [ThemeBloc] bloc
abstract class ThemeState extends Equatable {
  /// The theme to be used
  final ThemeData themeData;
  const ThemeState({required this.themeData});

  @override
  List<Object> get props => [themeData];
}

/// Implements the dart theme for the app
class DarkTheme extends ThemeState {
  DarkTheme() : super(themeData: ThemeData.dark());
}

/// Implements the light theme for the app
class LightTheme extends ThemeState {
  LightTheme() : super(themeData: ThemeData.light());
}
