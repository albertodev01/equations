import 'package:flutter/material.dart';

class EquationTextFormatter extends StatelessWidget {
  final String equation;
  const EquationTextFormatter({
    required this.equation,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "f(x) =  ",
        style: DefaultTextStyle.of(context).style.copyWith(
            color: Colors.blueAccent,
            fontStyle: FontStyle.italic,
            fontSize: 20),
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
