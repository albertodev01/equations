import 'package:flutter/material.dart';

/// This widget appends a blue `f(x) =  ` text in front of the equation string.
class EquationTextFormatter extends StatelessWidget {
  /// The string representation of the equation.
  final String equation;

  /// Creates a [EquationTextFormatter] widget.
  const EquationTextFormatter({
    Key? key,
    required this.equation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style.copyWith(
          color: Colors.blueAccent,
          fontStyle: FontStyle.italic,
          fontSize: 20,
        );

    return RichText(
      text: TextSpan(
        text: 'f(x) =  ',
        style: style,
        children: [
          TextSpan(
            text: equation,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
