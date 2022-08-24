import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Determines whether the integration test is running on a desktop platform or
/// not. In case of desktop, the test surface is enlarged.
///
/// Enlarging the test surface ensures that all widget are visible and avoids
/// the 'warn if missed' call.
Future<void> configureIfDesktop(WidgetTester tester) async {
  final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  // A web app can also be run on a mobile device so we want to exclude it.
  if (!kIsWeb && isDesktop) {
    await tester.binding.setSurfaceSize(const Size(1200, 1200));
  }
}
