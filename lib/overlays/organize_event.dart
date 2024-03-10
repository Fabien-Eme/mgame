import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../flame_game/game.dart';

Widget organizeEvent(BuildContext context, MGame game) {
  return OrganizeEvent(game);
}

class OrganizeEvent extends StatefulWidget {
  const OrganizeEvent(this.mgame, {super.key});

  final MGame mgame;

  @override
  State<OrganizeEvent> createState() => _OrganizeEventState();
}

class _OrganizeEventState extends State<OrganizeEvent> {
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  String email = '';
  String password = '';
  bool isLogin = false;
  String errorMessage = '';
  bool isTryingToConnect = false;

  void _submitForm() async {
    if (!isTryingToConnect) {
      isTryingToConnect = true;

      final isValid = formKey.currentState?.validate();
      if (!(isValid ?? false)) return;

      formKey.currentState?.save();
      try {
        if (isLogin) {
          await auth.signInWithEmailAndPassword(email: email.toLowerCase(), password: password);
        } else {
          await auth.createUserWithEmailAndPassword(email: email.toLowerCase(), password: password);
          await db.collection("users").doc(email.toLowerCase()).set({
            'achievements': [],
            'lastLevelCompleted': 0,
          });
        }

        widget.mgame.overlays.remove('signInUp');
        widget.mgame.mouseCursor = SystemMouseCursors.none;
      } on FirebaseAuthException catch (e) {
        isTryingToConnect = false;
        if (e.code == 'unknown-error') {
          setState(() => errorMessage = 'No account for this email. Create one');
        } else {
          setState(() => errorMessage = e.code);
        }
      }
    }
  }

  void _resetPassword() async {
    if (email.isEmpty) {
      setState(() => errorMessage = 'Enter an Email');
      return;
    }
    try {
      await auth.sendPasswordResetEmail(email: email);
      setState(() => errorMessage = "Password reset email sent");
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.code);
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
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Describe what the participants will do :',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.white,
                                    child: TextFormField(
                                      onSaved: (value) => email = value!,
                                      maxLines: 4,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Adress of the event :',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    color: Colors.white,
                                    child: TextFormField(
                                      onSaved: (value) => email = value!,
                                      maxLines: 4,
                                    ),
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
                        ),
                      ),
                    ),
                    Container(
                      width: (constraints.maxWidth / 3 > 500) ? 500 : constraints.maxWidth / 3,
                      height: (constraints.maxHeight / 1.3 > 480) ? 480 : constraints.maxHeight / 1.3,
                      padding: const EdgeInsets.all(8),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'We offer you the possibility to organize waste cleaning events in real life.\nInspire other people to take action around the world.\n\nYou will earn rewards according to the number of participants to your event. Each participant will get a fixed reward for attending the event.\n\nAfter you confirm your event, you will get a google wallet pass to share the event and invite people in real life.\nYou will also get a second pass the day before the event. This one will allow you to reward the participants. By flashing the QR Code, they will get a reward in-game.\n\nKeep in mind that your event will be public and viewable by everyone.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
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
