import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opendiet/main.dart';

void main() {
  testWidgets('renders the landing screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: OpenDietApp()));

    expect(find.text('OpenDiet'), findsOneWidget);
    expect(find.text('Local-first diet tracker'), findsOneWidget);
  });
}
