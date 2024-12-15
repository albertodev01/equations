import 'package:equations_solver/src/features/app/widgets/route_scaffold.dart';
import 'package:flutter/material.dart';

class MatricesView extends StatelessWidget {
  const MatricesView({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteScaffold(
      title: 'Matrices',
      child: Center(
        child: Text('matrices'),
      ),
    );
  }
}
