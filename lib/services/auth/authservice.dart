import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:src/services/apis/users.dart';

class AuthService extends ChangeNotifier {
  // yetkilendirme örneği
  static FirebaseAuth auth = FirebaseAuth.instance;

  // firestore u yetkilendir
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  // kullanıcı girişi yap
  Future<UserCredential> signInWithEmailanPassword(
      String email, String password) async {
    try {
      // giriş yapmayı dene
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // user collection ına eğer daha önceden eklenmediyse yeni döküman ekle
      _fireStore.collection("users").doc(userCredential.user!.uid).set(
          {"uid": userCredential.user!.uid, "email": email},
          SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // yeni kullanıcı hesabı oluştur
  static Future<bool> signUpWithEmailandPassword(
      String email, String password, String username, String pp) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // kullanıcı oluşturduktan sonra, users collection da yeni bir document oluştur.
      APIs.createUser(email, username, password, pp);

      return true;
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // kullanıcı çıkışı yap
  static Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
