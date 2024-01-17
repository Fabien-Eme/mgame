import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/audio/audio_controller.dart';

class Initializer extends ConsumerWidget {
  const Initializer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: performInitialization(ref),
      builder: (BuildContext context, AsyncSnapshot<bool> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          ref.watch(audioControllerProvider);

          FlutterNativeSplash.remove();
          return child;
        } else if (asyncSnapshot.hasError) {
          return somethingWentWrong();
        } else {
          return loading();
        }
      },
    );
  }
}

Future<bool> performInitialization(WidgetRef ref) async {
  try {
    return true;
  } catch (e) {
    rethrow;
  }
}

Widget somethingWentWrong() {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(child: Text("Une erreur s'est produite, veuillez relancer l'application.")),
    ),
  );
}

Widget loading() {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(child: CircularProgressIndicator()),
    ),
  );
}
