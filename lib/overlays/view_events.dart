import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../flame_game/game.dart';

Widget viewEvents(BuildContext context, MGame game) {
  return ViewEvents(game);
}

class ViewEvents extends StatefulWidget {
  const ViewEvents(this.mgame, {super.key});

  final MGame mgame;

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
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
                  child: Form(
                    key: formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              const Text(
                                'ALL CLEANING EVENT',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                errorMessage,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Email'),
                                validator: (value) => value!.isEmpty || !value.contains('@') ? "Enter a valid email" : null,
                                onSaved: (value) => email = value!,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                validator: (value) => value!.isEmpty || value.length < 6 ? "Password must be at least 6 characters long" : null,
                                onSaved: (value) => password = value!,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      widget.mgame.overlays.remove('viewEvents');
                                      widget.mgame.mouseCursor = SystemMouseCursors.none;
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: _submitForm,
                                    child: Text(isLogin ? 'Login' : 'Sign up'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: _resetPassword,
                                child: const Text('Forgot Password?'),
                              ),
                            ],
                          ),
                        ),
                      ),
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
