import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  /// The title of the page.
  final String pageTitle;
  /// The image associate to the title (appearing to the left)
  final Widget icon;
  const SectionTitle({
    required this.pageTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: icon,
        ),
        Text(
          pageTitle,
          style: const TextStyle(fontSize: 26, color: Colors.blueGrey),
        ),
      ],
    );
  }
}