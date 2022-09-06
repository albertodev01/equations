import 'package:flutter/material.dart';

/// The section title at the top of each route.
class PageTitle extends StatelessWidget {
  /// The section title.
  final String pageTitle;

  /// A small image on the left of the text.
  ///
  /// Generally, this widget is 50x50 large.
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
