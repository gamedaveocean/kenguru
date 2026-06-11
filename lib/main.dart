import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'state/game_state.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const KenguruApp());
}

class KenguruApp extends StatelessWidget {
  const KenguruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Кенгуру-головоломка',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoTextTheme(),
        ),
        home: const GameScreen(),
      ),
    );
  }
}
