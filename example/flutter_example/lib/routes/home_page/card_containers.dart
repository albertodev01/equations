import 'package:flutter/material.dart';

/// A series of [Card] widgets representing the various kind of solvers exposed
/// by the app. A [CardContainer] widget has an icon on the left and some text
/// on the right.
class CardContainer extends StatelessWidget {
  /// The description of the container.
  final String title;

  /// The image on the left.
  final Widget image;

  /// The route to be opened when the container is tapped.
  final void Function() onTap;

  /// Creates a [CardContainer] widget.
  const CardContainer({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: SizedBox(
        width: 260,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 8,
            shadowColor: Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: image,
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
