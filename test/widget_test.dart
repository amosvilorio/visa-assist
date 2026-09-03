import 'package:flutter_test/flutter_test.dart';
import 'package:visa_app/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (tester) async {
    await tester.pumpWidget(const VisaAssistApp());

    expect(find.text('Visa Assist'), findsOneWidget);
  });
}