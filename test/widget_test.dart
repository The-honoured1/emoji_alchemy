import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_alchemy/main.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const EmojiAlchemyApp());
    
    // Wait for async initialization to complete
    await tester.pumpAndSettle();

    expect(find.text('Emoji Alchemy'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Collection'), findsOneWidget);
  });
}
