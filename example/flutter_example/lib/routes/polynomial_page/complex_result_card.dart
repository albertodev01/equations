import 'package:equations/equations.dart';
import 'package:flutter/material.dart';

class ComplexResultCard extends StatelessWidget {
  final Complex value;
  final String leading;
  const ComplexResultCard({required this.value, this.leading = 'x ='});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: SizedBox(
          width: 250,
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text('$leading $value'),
              subtitle: Text('Fraction: ${value.toStringAsFraction()}'),
            ),
          ),
        ),
      ),
    );
  }
}
