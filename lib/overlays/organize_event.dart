import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/game_user_controller.dart';

import '../flame_game/game.dart';

Widget organizeEvent(BuildContext context, MGame game) {
  return OrganizeEvent(game);
}

class OrganizeEvent extends ConsumerStatefulWidget {
  const OrganizeEvent(this.mgame, {super.key});

  final MGame mgame;

  @override
  OrganizeEventState createState() => OrganizeEventState();
}

class OrganizeEventState extends ConsumerState<OrganizeEvent> {
  final formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  String title = '';
  String description = '';
  String dateAndAdress = '';
  bool isTryingToConnect = false;

  void _submitForm() async {
    if (!isTryingToConnect) {
      isTryingToConnect = true;

      formKey.currentState?.save();

      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      Random random = Random();
      String code = '';

      for (int i = 0; i < 6; i++) {
        int randomIndex = random.nextInt(chars.length);
        code += chars[randomIndex];
      }

      await db.collection("events").add({
        'title': title,
        'description': description,
        'dateAndAdress': dateAndAdress,
        'date': FieldValue.serverTimestamp(),
        'user': ref.read(gameUserControllerProvider.notifier).getUserEmail() ?? "",
        'numberOfParticipants': 0,
        'code': code,
      });

      widget.mgame.overlays.remove('organizeEvent');
      widget.mgame.mouseCursor = SystemMouseCursors.none;

      isTryingToConnect = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Center(
            child: Container(
              width: (constraints.maxWidth / 1.25 > 1200) ? 1200 : constraints.maxWidth / 1.25,
              height: (constraints.maxHeight / 1.2 > 500) ? 500 : constraints.maxHeight / 1.2,
              decoration: BoxDecoration(
                color: Colors.blueGrey[50]!,
                border: Border.all(
                  width: 5,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: (constraints.maxWidth / 3 > 500) ? 500 : constraints.maxWidth / 3,
                      height: (constraints.maxHeight / 1.3 > 480) ? 480 : constraints.maxHeight / 1.3,
                      child: Form(
                        key: formKey,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ORGANIZE WASTE CLEANING EVENT',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Title of the Event:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.white,
                                    child: TextFormField(
                                      onSaved: (value) => title = value!,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Describe what the participants will do:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.white,
                                    child: TextFormField(
                                      onSaved: (value) => description = value!,
                                      maxLines: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Date, Time and Adress of the event:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.white,
                                    child: TextFormField(
                                      onSaved: (value) => dateAndAdress = value!,
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: (constraints.maxWidth / 3 > 500) ? 500 : constraints.maxWidth / 3,
                      height: (constraints.maxHeight / 1.3 > 480) ? 480 : constraints.maxHeight / 1.3,
                      padding: const EdgeInsets.all(4),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'We offer you the possibility to organize waste cleaning events in real life.\nInspire other people to take action around the world.\n\nYou will earn 10 EcoCredits per participants to your event. Each participant will get 10 EcoCredits for attending the event.\n\nAfter you confirm your event, go to "My Events" to get a google wallet pass that will allow you to reward the participants. By flashing the QR Code, they will get a code to get their reward in-game.\n\nKeep in mind that your event will be public and viewable by everyone.',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    widget.mgame.overlays.remove('organizeEvent');
                                    widget.mgame.mouseCursor = SystemMouseCursors.none;
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  child: const Text('Confirm Event'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
