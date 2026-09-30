import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_state.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/game_screen.dart';
import 'ui/screens/collection_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/hint_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EmojiAlchemyApp());
}

class EmojiAlchemyApp extends StatefulWidget {
  const EmojiAlchemyApp({super.key});

  @override
  State<EmojiAlchemyApp> createState() => _EmojiAlchemyAppState();
}

class _EmojiAlchemyAppState extends State<EmojiAlchemyApp> {
  late Future<GameState> _gameStateFuture;

  @override
  void initState() {
    super.initState();
    _gameStateFuture = _initGameState();
  }

  Future<GameState> _initGameState() async {
    final gameState = GameState();
    await gameState.initialize();
    return gameState;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameState>(
      future: _gameStateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: AppTheme.offWhite,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final gameState = snapshot.data!;
        return ChangeNotifierProvider<GameState>.value(
          value: gameState,
          child: MaterialApp(
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
          ),
        );
      },
    );
  }
}