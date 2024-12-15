import 'package:equations_solver/src/features/app/widgets/route_scaffold.dart';
import 'package:flutter/material.dart';

class ComplexNumbersView extends StatelessWidget {
  const ComplexNumbersView({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteScaffold(
      title: 'Complex numbers',
      child: Center(
        child: Text('complex numbers'),
      ),
    );
  }
}
