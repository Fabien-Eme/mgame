import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@Riverpod(keepAlive: true)
class UserController extends _$UserController {
  @override
  User? build() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      state = user;
    });

    return null;
  }
}
