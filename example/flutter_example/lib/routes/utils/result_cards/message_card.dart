import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';

/// A wrapper of [Card] that displays a message.
class MessageCard extends StatelessWidget {
  /// The message.
  final String message;

  /// Creates a [MessageCard] widget.
  const MessageCard({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidgetsWidth,
      child: Card(
        margin: const EdgeInsets.only(top: 35),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(message),
          ),
        ),
      ),
    );
  }
}
