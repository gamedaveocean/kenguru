import 'package:flutter_test/flutter_test.dart';
import 'package:kenguru/main.dart';

void main() {
  testWidgets('App starts and shows game screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KenguruApp());
    expect(find.text('🦘 Кенгуру-головоломка'), findsOneWidget);
  });
}
