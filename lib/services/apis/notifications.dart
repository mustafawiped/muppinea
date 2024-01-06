// ignore_for_file: camel_case_types, avoid_print
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/services/auth/authservice.dart';

class NotificationsDb {
  static final CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection('Users');

  static Future<bool> addNotification(String sendingUser, String otherUser,
      String headerText, String descText, String process) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> data = {
        "user": otherUser,
        "process": process,
        "header": headerText,
        "desc": descText,
        "time": time
      };
      await notificationCollection
          .doc(sendingUser)
          .collection('notifications')
          .doc(otherUser)
          .set(data);
      return true;
    } catch (e) {
      print("NotificationsDb | addNotification | Hata: $e");
      return false;
    }
  }

  static Future<bool> deleteNotification(
      String silinecekYer, String docId) async {
    if (docId != silinecekYer) {
      try {
        await notificationCollection
            .doc(AuthService.user.uid)
            .collection('notifications')
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllNotifications() {
    return notificationCollection
        .doc(AuthService.user.uid)
        .collection("notifications")
        .orderBy('time', descending: false)
        .snapshots();
  }

  static Future<bool> containsField(
      String aranacakYer, String aranacakKisi) async {
    try {
      DocumentSnapshot viewerDocSnapshot = await notificationCollection
          .doc(aranacakYer)
          .collection("notifications")
          .doc(aranacakKisi)
          .get();

      if (!viewerDocSnapshot.exists) {
        return false;
      }

      Map<String, dynamic>? viewerData =
          viewerDocSnapshot.data() as Map<String, dynamic>?;
      if (viewerData != null) {
        return viewerData["process"] == "messagerequest";
      }

      return false;
    } catch (e) {
      print("FriendRequests | containsField | Hata: $e");
      return false;
    }
  }

  static Stream<int> getNotificationsCountStream() {
    final StreamController<int> notificationsCountController =
        StreamController<int>();

    notificationCollection
        .doc(AuthService.user.uid)
        .collection("notifications")
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      notificationsCountController.add(snapshot.size);
    });

    return notificationsCountController.stream;
  }
}
