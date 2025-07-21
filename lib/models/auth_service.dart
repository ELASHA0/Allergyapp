import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Safely update display name and reload user
    if (result.user != null) {
      await result.user!.updateDisplayName(name);
      await result.user!.reload(); // refresh user instance
      return _auth.currentUser; // return updated user
    }

    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get userChanges => _auth.userChanges();
}
