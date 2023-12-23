// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/services/auth/authservice.dart';

class friendRequestsDb {
  static final CollectionReference requestCollection =
      FirebaseFirestore.instance.collection('friendrequests');

  static Future<bool> sendRequest(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await requestCollection.doc(documentId).get();

      if (documentSnapshot.exists) {
        await requestCollection.doc(documentId).update({
          AuthService.me.id: FieldValue.serverTimestamp(),
        });
        return true;
      } else {
        Map<String, dynamic> data = {
          AuthService.me.id: FieldValue.serverTimestamp()
        };
        await requestCollection.doc(documentId).set(data);
        return true;
      }
    } catch (e) {
      print("FriendRequestDb | createOrUpdateDocument | Hata: $e");
      return false;
    }
  }

  static Future<bool> deleteField(String silinecekYer, String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await requestCollection.doc(silinecekYer).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey(userId)) {
          Map<String, dynamic> updateData = {
            userId: FieldValue.delete(),
          };
          await requestCollection.doc(silinecekYer).update(updateData);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("FriendRequests | deleteField | Hata: $e");
      return false;
    }
  }

  static Future<bool> containsField(
      String aranacakYer, String aranacakKisi) async {
    try {
      DocumentSnapshot viewerDocSnapshot =
          await requestCollection.doc(aranacakYer).get();

      if (!viewerDocSnapshot.exists) {
        return false;
      }

      Map<String, dynamic>? viewerData =
          viewerDocSnapshot.data() as Map<String, dynamic>?;
      if (viewerData != null) {
        return viewerData.containsKey(aranacakKisi);
      }

      return false;
    } catch (e) {
      print("FriendRequests | containsField | Hata: $e");
      return false;
    }
  }
}
