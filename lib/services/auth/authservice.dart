import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/services/apis/users.dart';

class AuthService extends ChangeNotifier {
  // yetkilendirme örneği
  static FirebaseAuth auth = FirebaseAuth.instance;

  // firestore u yetkilendir
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static User get user => auth.currentUser!;

  static late userData me;

  static Future<bool> getSelfInfo() async {
    return await _fireStore
        .collection('Users')
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = userData.fromMap(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        APIs.updateActiveStatus(true, false);
        print('My Data: ${user.data()}');
        return true;
      } else {
        return false;
      }
    });
  }

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
      }
    });
  }

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
