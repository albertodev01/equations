import 'package:flutter/material.dart';

/// A widget representing a section title in a page.
class PageTitle extends StatelessWidget {
  /// The section title.
  final String pageTitle;

  /// A small image on the left of the text. Generally, this widget should be
  /// a 50 x 50 square.
  final Widget pageLogo;

  /// Creates a [PageTitle] widget.
  const PageTitle({
    required this.pageTitle,
    required this.pageLogo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: pageLogo,
          ),
          Text(
            pageTitle,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
