import 'package:flutter/material.dart';

class LinearEquationTab extends StatefulWidget {
  const LinearEquationTab({super.key});

  @override
  State<LinearEquationTab> createState() => _LinearEquationTabState();
}

class _LinearEquationTabState extends State<LinearEquationTab> {
  final controllerA = TextEditingController();
  final controllerB = TextEditingController();

  @override
  void dispose() {
    controllerA.dispose();
    controllerB.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < 200; ++i) Text('$i'),
      ],
    );
  }
}
