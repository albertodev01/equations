import 'package:equations_solver/src/features/app/widgets/route_scaffold.dart';
import 'package:flutter/material.dart';

class InterpolationView extends StatelessWidget {
  const InterpolationView({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteScaffold(
      title: 'Interpolation',
      child: Center(
        child: Text('interpolation'),
      ),
    );
  }
}
