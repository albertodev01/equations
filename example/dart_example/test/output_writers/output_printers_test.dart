import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../common_process.dart';

void main() {
  Future<void> testProcess(Process process) async {
    // Converting into a stream
    final stream = process.stdout.transform(const Utf8Decoder());

    // What to NOT expect
    const notExpectedOutput = '\n > Error: the given argument is not valid!'
        '\n\nPress any key to exit...';

    // This is required to 'press any key to continue'
    process.stdin.writeln('.');

    await expectLater(
      stream,
      neverEmits(
        [notExpectedOutput],
      ),
    );

    final exitCode = await process.exitCode;
    expect(exitCode, isZero);
  }

  group('Testing the output classes', () {
    test(
      'Making sure that Integrals can correctly be evaluated and printed',
      () async {
        final process = await createProcess(
          arg: '-i',
        );

        await testProcess(process);
      },
    );

    test(
      'Making sure that matrices can correctly be evaluated and printed',
      () async {
        final process = await createProcess(
          arg: '-m',
        );

        await testProcess(process);
      },
    );

    test(
      'Making sure that polynomials can correctly be evaluated and printed',
      () async {
        final process = await createProcess(
          arg: '-p',
        );

        await testProcess(process);
      },
    );

    test(
      'Making sure that nonlinear eq. can correctly be evaluated and printed',
      () async {
        final process = await createProcess(
          arg: '-n',
        );

        await testProcess(process);
      },
    );
  });
}
