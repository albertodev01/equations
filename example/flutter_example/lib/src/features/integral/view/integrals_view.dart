import 'package:equations_solver/src/features/app/widgets/route_scaffold.dart';
import 'package:flutter/material.dart';

class IntegralsView extends StatelessWidget {
  const IntegralsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteScaffold(
      title: 'Integral',
      child: Center(
        child: Text('integral'),
      ),
    );
  }
}
