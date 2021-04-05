import 'package:equatable/equatable.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter/material.dart';

/// An interactive item within a [EquationScaffold] navigation bar widget.
class NavigationItem extends Equatable {
  /// The title of the item
  final String title;

  /// The default icon to be shown
  final Widget icon;

  /// The icon to be shown when the item is selected
  final Widget activeIcon;

  /// The content of the page
  final Widget content;

  /// Creates a [NavigationItem] widget. The [title] and the [content] are
  /// required while the icons default to [Icons.multiline_chart]
  const NavigationItem({
    required this.title,
    required this.content,
    this.icon = const Icon(Icons.multiline_chart),
    this.activeIcon = const Icon(Icons.multiline_chart),
  });

  @override
  List<Object?> get props => [title, icon, activeIcon, content];
}
