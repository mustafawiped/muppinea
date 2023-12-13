import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:src/models/messagemodel.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/services/auth/authservice.dart';

class APIs {
  static FirebaseFirestore fstore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
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
        isTyping: false,
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    String userId = AuthService.me.id;
    return fstore
        .collection('Users')
        .where('id', isNotEqualTo: userId)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      userData chatUser) {
    return fstore
        .collection('Users')
        .where("id", isEqualTo: chatUser.id)
        .snapshots();
  }

  static String getConversationID(String id) =>
      AuthService.user.uid.hashCode <= id.hashCode
          ? "${AuthService.user.uid}_$id"
          : "${id}_${AuthService.user.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      userData otherUser) {
    return fstore
        .collection('chats/${getConversationID(otherUser.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      userData otherUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message newMessage = Message(
      msg: msg,
      read: '',
      told: otherUser.id,
      type: type,
      fromId: AuthService.user.uid,
      sent: time,
      edited: "",
      reply: "",
    );

    final ref =
        fstore.collection('chats/${getConversationID(otherUser.id)}/messages');
    await ref.doc(time).set(newMessage.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    fstore
        .collection('chats/${getConversationID(message.fromId)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Future<void> updateActiveStatus(bool isOnline, bool state) async {
    fstore.collection('Users').doc(AuthService.user.uid).update({
      "isOnline": isOnline,
      "lastActive": DateTime.now().millisecondsSinceEpoch.toString(),
      "pushToken": state ? "" : AuthService.me.pushToken,
    });
  }

  static Future<void> sendChatImage(userData chatUser, File file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child(
        "images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) async {
      print("Data Transferred: ${p0.bytesTransferred / 1000} kb");
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
