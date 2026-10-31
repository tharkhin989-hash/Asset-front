
import 'package:flutter_project_exe/main.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('Asset Management app opens successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AssetManagementApp());
    await tester.pumpAndSettle();

    expect(find.byType(AssetManagementApp), findsOneWidget);
  });
}
