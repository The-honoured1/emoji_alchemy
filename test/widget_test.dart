import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_alchemy/main.dart';
import 'package:emoji_alchemy/providers/game_state.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameState(),
        child: const EmojiAlchemyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('THE GREAT LAB'), findsOneWidget);
    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('LAB'), findsOneWidget);
  });
}
