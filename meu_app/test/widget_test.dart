import 'package:flutter_test/flutter_test.dart';

import 'package:meu_app/components/display.dart';
import 'package:meu_app/screens/calculator.dart';

void main() {
  testWidgets('enters a number in the calculator', (WidgetTester tester) async {
    await tester.pumpWidget(const Calculator(showAd: false));

    await tester.tap(find.text('7'));
    await tester.pump();

    final display = tester.widget<Display>(find.byType(Display));
    expect(display.text, '7');
  });
}
