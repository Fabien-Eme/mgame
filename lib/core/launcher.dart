import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'initializer.dart';
import 'router.dart';

class Launcher extends ConsumerWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Basic logging setup.
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      dev.log(
        record.message,
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
      );
    });
    return Initializer(
      child: MaterialApp.router(
        routerConfig: router,
        title: "M Game",
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
