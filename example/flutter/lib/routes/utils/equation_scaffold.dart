import 'package:equations_solver/blocs/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A simple wrapper of [Scaffold]. This widget is meant to be used across the
/// entire app to setup the minimal "skeleton" of the UI. This scaffold is made
/// up of two parts:
///
///  - an [AppBar] with no title and a dark/light theme switcher;
///  - the body of the [Scaffold]
class EquationScaffold extends StatelessWidget {
  /// The body of the [Scaffold]
  final Widget body;
  const EquationScaffold({
    required this.body
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: const [
          _ThemeSwitcher(),
        ],
      ),
      body: body,
    );
  }
}

/// Changes the theme of the app (from light to dark and vice versa).
class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is LightTheme) {
            return IconButton(
              key: const Key("equations_scaffold_dark_button"),
              icon: const Icon(Icons.nightlight_round),
              onPressed: () => context.read<ThemeBloc>().add(const LightEvent()),
            );
          }

          return IconButton(
            key: const Key("equations_scaffold_light_button"),
            icon: const Icon(Icons.wb_sunny),
            onPressed: () => context.read<ThemeBloc>().add(const DarkEvent()),
          );
        },
      ),
    );
  }
}