import 'package:flutter/material.dart';

/// Theme configuration
final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 2,
    surfaceTintColor: Colors.lightBlue,
    shadowColor: Colors.grey,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 4,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    showSelectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
  navigationRailTheme: const NavigationRailThemeData(
    elevation: 4,
    useIndicator: true,
    groupAlignment: 0,
    labelType: NavigationRailLabelType.all,
    selectedIconTheme: IconThemeData(color: Colors.blue),
  ),
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.blue,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
  ),
);
