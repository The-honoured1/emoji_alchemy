import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_state.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/game_screen.dart';
import 'ui/screens/codex_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/hint_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: const EmojiAlchemyApp(),
    ),
  );
}

class EmojiAlchemyApp extends StatelessWidget {
  const EmojiAlchemyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Alchemy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.inkPaperTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/lab': (context) => const GameScreen(),
        '/collection': (context) => const CollectionScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/hints': (context) => const HintScreen(),
      },
    );
  }
}

