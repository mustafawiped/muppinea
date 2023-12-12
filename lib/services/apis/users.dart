import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/models/UserModel.dart';
import 'package:src/services/auth/authservice.dart';

class APIs {
  static FirebaseFirestore fstore = FirebaseFirestore.instance;
  static final CollectionReference usersCollection = fstore.collection('Users');

  // create new user
  static Future<void> createUser(
      String email, String username, String password, String pp) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final newUser = userData(
        about: "Hey! Ben Muppin Kullanıyorum!",
        createdAt: timestamp,
        email: email,
        id: AuthService.user.uid,
        image: pp.isNotEmpty ? pp : "",
        isOnline: false,
        lastActive: timestamp,
        username: username,
        badges: [],
        pronouns: "",
        security: false,
        socials: {},
        pushToken: "");
    return await fstore
        .collection("Users")
        .doc(AuthService.user.uid)
        .set(newUser.toMap());
  }

  static Future<bool> existsControl(String key, String value) async {
    QuerySnapshot querySnapshot =
        await usersCollection.where(key, isEqualTo: value).get();
    return (querySnapshot.docs.isEmpty);
  }

  static Future<bool> userExists() async {
    return (await fstore.collection("users").doc(AuthService.user.uid).get())
        .exists;
  }
}
