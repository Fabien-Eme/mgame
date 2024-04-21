import 'package:flutter/material.dart';
import 'package:mgame/flame_game_widget.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: const Color(0xFF182F46),
          child: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 500)).then((value) => true),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return const FlameGameWidget();
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Game is Loading",
                          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 50),
                        CircularProgressIndicator(
                          strokeWidth: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                }
              })),
        ),
      );
    });
  }
}
