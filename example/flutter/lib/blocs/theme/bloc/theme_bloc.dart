import 'package:equations_solver/blocs/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Changes the theme of the app, switching from "Light" to "Dart" and vice versa.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(LightTheme());

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is DarkEvent) {
      yield LightTheme();
    }
    if (event is LightEvent) {
      yield DarkTheme();
    }
  }
}