import 'package:flutter/material.dart';
import 'package:mgame/flame_game_widget.dart';
import 'initializer.dart';

class Launcher extends StatelessWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Initializer(
      child: MaterialApp(
        title: "M Game",
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const FlameGameWidget(),
      ),
    );
  }
}
