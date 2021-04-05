import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit that stores the state of a navigation bar. It simply keeps track of the
/// currently selected index of a [BottomNavigationBar] or a [NavigationRail].
class NavigationCubit extends Cubit<int> {
  /// The initial value is set to `0`
  NavigationCubit() : super(0);

  /// Sets the new index of the currently selected page.
  void pageIndex(int index) => emit(index);
}
