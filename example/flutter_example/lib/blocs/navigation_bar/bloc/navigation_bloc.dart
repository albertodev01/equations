import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc that stores the state of a navigation bar. It simply keeps track of the
/// currently selected index of a [BottomNavigationBar] or a [NavigationRail].
class NavigationBloc extends Bloc<int, int> {
  NavigationBloc() : super(0);

  @override
  Stream<int> mapEventToState(int event) async* {
    yield event;
  }
}
