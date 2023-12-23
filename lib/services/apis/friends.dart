// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsDb {
  static final CollectionReference requestCollection =
      FirebaseFirestore.instance.collection('friends');

  static Future<bool> addFriend(String eklenecekYer, String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await requestCollection.doc(eklenecekYer).get();

      if (documentSnapshot.exists) {
        await requestCollection.doc(eklenecekYer).update({
          documentId: FieldValue.serverTimestamp(),
        });
        return true;
      } else {
        Map<String, dynamic> data = {documentId: FieldValue.serverTimestamp()};
        await requestCollection.doc(eklenecekYer).set(data);
        return true;
      }
    } catch (e) {
      print("FriendsDb | createOrUpdateDocument | Hata: $e");
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
      print("FriendsDb | deleteField | Hata: $e");
      return false;
    }
  }

  static Future<List> containsField(
      String aranacakYer, String docId, bool state) async {
    try {
      DocumentSnapshot viewerDocSnapshot =
          await requestCollection.doc(aranacakYer).get();

      if (!viewerDocSnapshot.exists) {
        return [];
      }

      Map<String, dynamic>? viewerData =
          viewerDocSnapshot.data() as Map<String, dynamic>?;
      if (viewerData != null) {
        return [
          state ? viewerData.containsKey(docId) : false,
          viewerData.length
        ];
      }

      return [];
    } catch (e) {
      print("FriendsDb | containsField | Hata: $e");
      return [];
    }
  }
}
