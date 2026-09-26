import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('Micros inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MicrosApp());

    expect(find.text('MICROS'), findsOneWidget);
  });
}