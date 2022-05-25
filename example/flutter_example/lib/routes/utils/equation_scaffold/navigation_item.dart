import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// An interactive item within an [EquationScaffold] navigation bar widget.
class NavigationItem {
  /// The title of the item.
  final String title;

  /// The default icon to be shown.
  final Widget icon;

  /// The icon to be shown when the item is selected.
  final Widget activeIcon;

  /// The content of the page.
  final Widget content;

  /// Creates a [NavigationItem] widget. Both icons default to
  /// [Icons.multiline_chart].
  const NavigationItem({
    required this.title,
    required this.content,
    this.icon = const Icon(Icons.multiline_chart),
    this.activeIcon = const Icon(Icons.multiline_chart),
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is NavigationItem) {
      return runtimeType == other.runtimeType &&
          title == other.title &&
          icon == other.icon &&
          activeIcon == other.activeIcon &&
          content == other.content;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = 17;

    result = result * 37 + title.hashCode;
    result = result * 37 + icon.hashCode;
    result = result * 37 + activeIcon.hashCode;
    result = result * 37 + content.hashCode;

    return result;
  }
}
