import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:holo_mobile_coding_challenge/core/widgets/state_message.dart';

void main() {
  testWidgets('StateMessage renders message and triggers action', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: StateMessage(
          message: 'Hello',
          actionLabel: 'Retry',
          onActionPressed: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
