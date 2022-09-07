import 'package:flutter/material.dart';

/// Appends a leading blue string in front of the actual string value.
class ColoredText extends StatelessWidget {
  /// The blue leading text.
  final String leading;

  /// The actual string value.
  final String value;

  /// Creates a [ColoredText] widget.
  const ColoredText({
    required this.leading,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: leading,
        style: const TextStyle(
          color: Colors.blue,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
