import 'dart:convert';

import 'package:test/test.dart';

import '../common_process.dart';

void main() {
  group("Testing the 'ErrorOutput' class", () {
    test(
      'Making sure that, when an unexpected argument is provided, an error '
      'message is displayed',
      () async {
        final process = await createProcess(
          arg: '',
        );

        // Converting into a stream
        final stream = process.stdout.transform(Utf8Decoder());

        // Expected output
        final expectedOutput = '\n > Error: the given argument is not valid!'
            '\n\nPress any key to exit...';

        expectLater(
          stream,
          emitsInOrder(
            [expectedOutput],
          ),
        );
      },
    );
  });
}
