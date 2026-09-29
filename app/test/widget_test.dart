import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chordband/main.dart';

void main() {
  testWidgets('ChordBandApp smoke test - renders app bar and initial state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ChordBandApp(),
      ),
    );

    // Initial pump
    await tester.pump();

    // Verify ChordBand brand title is displayed
    expect(find.text('ChordBand'), findsOneWidget);
  });
}
