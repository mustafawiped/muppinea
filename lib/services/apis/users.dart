import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:src/models/messagemodel.dart';
import 'package:src/models/notificationmodel.dart';
import 'package:src/models/searchmodel.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/services/apis/chathistory.dart';
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

  static Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getAllUsers(
      List datas) {
    datas.sort((a, b) => a["time"].compareTo(b["time"]));
    datas = datas.reversed.toList();
    List userIds = datas.map((e) => e.id).toList();

    return fstore
        .collection('Users')
        .where('id', whereIn: userIds.isEmpty ? [''] : userIds)
        .snapshots()
        .map((querySnapshot) {
      List<DocumentSnapshot<Map<String, dynamic>>> sortedData = userIds
          .map((userId) => querySnapshot.docs.firstWhere(
                (doc) => doc['id'] == userId,
              ))
          .toList();

      return sortedData;
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      userData chatUser) {
    return fstore
        .collection('Users')
        .where("id", isEqualTo: chatUser.id)
        .snapshots();
  }

// CHAT METHODS START //

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
      userData otherUser, String msg, Type type, List replyState) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message newMessage = Message(
      msg: msg,
      read: '',
      told: otherUser.id,
      type: type,
      fromId: AuthService.user.uid,
      sent: time,
      edited: "",
      reply: replyState,
    );

    chatHistoryDb.addChatUser(AuthService.user.uid, otherUser.id);
    chatHistoryDb.addChatUser(otherUser.id, AuthService.user.uid);

    final ref =
        fstore.collection('chats/${getConversationID(otherUser.id)}/messages');
    await ref.doc(time).set(newMessage.toJson());
  }

  static Future<void> sendOtherUserMessage(
      String otherUser, String msg, Type type, List replyState) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message newMessage = Message(
      msg: msg,
      read: '',
      told: AuthService.user.uid,
      type: type,
      fromId: otherUser,
      sent: time,
      edited: "",
      reply: replyState,
    );

    chatHistoryDb.addChatUser(AuthService.user.uid, otherUser);
    chatHistoryDb.addChatUser(otherUser, AuthService.user.uid);

    final ref =
        fstore.collection('chats/${getConversationID(otherUser)}/messages');
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
      "isOnline": isOnline ? true : false,
      "lastActive": DateTime.now().millisecondsSinceEpoch.toString(),
      "pushToken": state ? "" : AuthService.me.pushToken,
    });
  }

  static Future<void> sendChatImage(userData chatUser, File file) async {
    final ext = file.path.split(".").last;
    final ref = storage.ref().child(
        "images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image, []);
  }

  static Stream<QuerySnapshot> getLastMessage(userData user) {
    return fstore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> updateMessage(Message message, String newMessage) async {
    await fstore
        .collection('chats/${getConversationID(message.told)}/messages')
        .doc(message.sent)
        .update({
      'msg': newMessage,
      'read': "",
      'edited': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  static Future<void> deleteMessage(Message message) async {
    await fstore
        .collection('chats/${getConversationID(message.told)}/messages')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

// CHAT METHODS END //

  // update profile picture
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split(".").last;
    final ref =
        storage.ref().child("profile_pictures/${AuthService.user.uid}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) async {
      AuthService.me.image = await ref.getDownloadURL();
      await fstore
          .collection("Users")
          .doc(AuthService.user.uid)
          .update({"image": AuthService.me.image});
    });
  }

  // update user details
  static Future<void> updateUserInfo(String key, value) async {
    await fstore.collection("Users").doc(AuthService.user.uid).update({
      key: value,
    });
  }

  Future<List<searchUserDatas>> searchUsers(String searchTerm) async {
    List<searchUserDatas> userList = [];
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where('username', isGreaterThanOrEqualTo: searchTerm)
          .where('username', isLessThan: '${searchTerm}z')
          .limit(25)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          userList.add(searchUserDatas(
            username: doc['username'],
            pp: doc['image'],
            documentId: doc.id,
            about: doc['about'],
          ));
          print("döngü çalıştı..");
        }
        print("yapacakbiseyyok: ${userList.length}");
      } else {
        print('Kullanıcı bulunamadı');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }

    return userList;
  }

  static Future<userData?> fetchData(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(documentId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        userData user = userData.fromMap(data);
        return user;
      } else {
        print("Belge bulunamadı!");
        return null;
      }
    } catch (e) {
      print("Hata: $e");
      return null;
    }
  }

  static Future<List<searchUserDatas>> getFriendDetails(
      List<String> friendList) async {
    if (friendList.isEmpty) return [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await fstore.collection('Users').where('id', whereIn: friendList).get();

    return querySnapshot.docs
        .map((doc) => searchUserDatas.fromMap(doc.data()))
        .toList();
  }

  static Future<List<notificationModel>> getNotifications(String docId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fstore
          .collection('Users')
          .doc(docId)
          .collection("notifications")
          .orderBy("time", descending: true)
          .limit(30)
          .get();

      return querySnapshot.docs
          .map((doc) => notificationModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
