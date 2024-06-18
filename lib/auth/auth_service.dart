import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registro de usuario
  Future<String?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar datos del usuario en Firestore
      await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
      });

      return null; // Registro exitoso
    } on FirebaseAuthException catch (e) {
      return e.message; // Mensaje de error
    }
  }

  // Inicio de sesión
  Future<String?> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Inicio de sesión exitoso
    } on FirebaseAuthException catch (e) {
      return e.message; // Mensaje de error
    }
  }

// Cerrar sesión
  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
