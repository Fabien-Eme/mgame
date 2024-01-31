import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/core/shared_preferences.dart';

class Initializer extends ConsumerWidget {
  const Initializer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: performInitialization(ref),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return somethingWentWrong();
          } else if (snapshot.hasData) {
            // ref.watch(audioControllerProvider);

            FlutterNativeSplash.remove();
            return child;
          } else {
            return loading();
          }
        });
  }
}

Future<bool> performInitialization(WidgetRef ref) async {
  await ref.watch(sharedPreferencesProvider.future);
  return true;
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
