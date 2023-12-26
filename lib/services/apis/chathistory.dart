// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/services/auth/authservice.dart';

class chatHistoryDb {
  static final FirebaseFirestore fstore = FirebaseFirestore.instance;
  static final CollectionReference chatHistoryCollection =
      FirebaseFirestore.instance.collection('chatHistory');

  static Future<bool> addChatUser(String eklenecekYer, String docId) async {
    if (docId != eklenecekYer) {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      await fstore
          .collection('chatHistory')
          .doc(eklenecekYer)
          .collection('my_users')
          .doc(docId)
          .set({"time": timestamp, "notificationState": false});

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteChatUser(String silinecekYer, String docId) async {
    if (docId != silinecekYer) {
      try {
        await fstore
            .collection('chatHistory')
            .doc(silinecekYer)
            .collection('my_users')
            .doc(docId)
            .delete();

        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatHistory() {
    return FirebaseFirestore.instance
        .collection('chatHistory')
        .doc(AuthService.user.uid)
        .collection("my_users")
        .orderBy('time', descending: false)
        .snapshots();
  }
}
