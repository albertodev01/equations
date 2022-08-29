import 'package:flutter/material.dart';

/// A series of [Card] widgets representing the various kind of solvers
/// supported by the app. A [CardContainer] widget has an icon on the left and
/// some text on the right.
class CardContainer extends StatelessWidget {
  /// The container description.
  final String title;

  /// The image on the left.
  final Widget image;

  /// This callback is triggered whenever the widget is tapped or clicked.
  final VoidCallback onTap;

  /// Creates a [CardContainer] widget.
  const CardContainer({
    required this.title,
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: SizedBox(
        width: 260,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 8,
              shadowColor: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(8),
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
      ),
    );
  }
}
