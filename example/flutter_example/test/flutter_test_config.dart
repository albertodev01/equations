import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Loading fonts for golden tests
  setUpAll(() async {
    await loadAppFonts();
  });

  // Tests' main body
  await testMain();
}
