import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mgame/flame_game/riverpod_controllers/user_controller.dart';

import '../flame_game/game.dart';

Widget validateParticipation(BuildContext context, MGame game) {
  return ValidateParticipation(game);
}

class ValidateParticipation extends ConsumerStatefulWidget {
  const ValidateParticipation(this.mgame, {super.key});

  final MGame mgame;

  @override
  ConsumerState<ValidateParticipation> createState() => _ValidateParticipationState();
}

class _ValidateParticipationState extends ConsumerState<ValidateParticipation> {
  final formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  String code = '';
  bool isTryingToConnect = false;
  String displayText = "Validation pending...";
  bool isFormShown = true;
  bool isOkButtonShown = false;

  void _submitForm() async {
    setState(() {
      isFormShown = false;
    });
    if (!isTryingToConnect) {
      isTryingToConnect = true;

      formKey.currentState?.save();
      try {
        code = code.toUpperCase();
        final allDocs = await db.collection('events').get();
        bool codeFound = false;
        for (final doc in allDocs.docs) {
          if (doc.data()['code'] == code) {
            codeFound = true;

            String currentUserMail = ref.read(userControllerProvider)?.email ?? "";
            String organizerMail = doc.data()['user'] as String;

            if (currentUserMail != organizerMail) {
              final docUser = await db.collection('users').doc(currentUserMail).get();

              List<dynamic>? codeUsedList = docUser.data()?['codeUsed'] as List<dynamic>;
              List<String> codeUsedStrings = codeUsedList.map((dynamic item) => item.toString()).toList();

              if (!codeUsedStrings.contains(code)) {
                await db.collection('users').doc(organizerMail).update({'EcoCredits': FieldValue.increment(10)});
                await db.collection('users').doc(currentUserMail).update({
                  'EcoCredits': FieldValue.increment(10),
                  'codeUsed': FieldValue.arrayUnion([code]),
                });
                isTryingToConnect = false;

                setState(() {
                  displayText = 'You have been granted 10 EcoCredits. Congratulations !';
                  isOkButtonShown = true;
                });
              } else {
                isTryingToConnect = false;
                setState(() {
                  displayText = 'You already used that code';
                  isOkButtonShown = true;
                });
              }
            } else {
              isTryingToConnect = false;
              setState(() {
                displayText = "You cant't validate the code of your own event";
                isOkButtonShown = true;
              });
            }
          }
        }
        isTryingToConnect = false;
        if (!codeFound) {
          setState(() {
            displayText = 'Invalid Code';
            isOkButtonShown = true;
          });
        }
      } on FirebaseAuthException {
        isTryingToConnect = false;
      }
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
              width: (constraints.maxWidth / 2.5 > 600) ? 600 : constraints.maxWidth / 2.5,
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
                child: SizedBox(
                  width: (constraints.maxWidth / 3 > 500) ? 500 : constraints.maxWidth / 3,
                  height: (constraints.maxHeight / 1.5 > 450) ? 450 : constraints.maxHeight / 1.5,
                  child: (isFormShown)
                      ? Form(
                          key: formKey,
                          child: Center(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    const Text(
                                      'VALIDATE YOUR PARTICIPATION IN AN IRL EVENT',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Enter the code on the Google Wallet Pass you received by scanning the Organizer pass :',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      decoration: const InputDecoration(labelText: 'Code'),
                                      onSaved: (value) => code = value!,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            widget.mgame.overlays.remove('validateParticipation');
                                            widget.mgame.mouseCursor = SystemMouseCursors.none;
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: _submitForm,
                                          child: const Text('Validate'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              Text(displayText),
                              const SizedBox(height: 10),
                              if (isOkButtonShown)
                                ElevatedButton(
                                  onPressed: () {
                                    widget.mgame.overlays.remove('validateParticipation');
                                    widget.mgame.mouseCursor = SystemMouseCursors.none;
                                  },
                                  child: const Text(
                                    'OK',
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
