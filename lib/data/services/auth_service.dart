import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login
  Future<User> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user!;

    // pastikan email sudah diverifikasi
    if (!user.emailVerified) {
      await _auth.signOut();
      throw Exception("Email belum diverifikasi");
    }

    return user;
  }

  // logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ambil user yang sedang login
  User? get currentUser => _auth.currentUser;

  // cek status login
  bool get isLoggedIn => _auth.currentUser != null;

  // refresh data user
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }
}
