import 'package:flutter_test/flutter_test.dart';

import 'package:consultant/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ConsultantApp());
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
