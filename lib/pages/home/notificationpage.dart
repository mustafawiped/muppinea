// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/models/messagemodel.dart';
import 'package:src/models/notificationmodel.dart';
import 'package:src/models/searchmodel.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/chat/chatpage.dart';
import 'package:src/pages/profile/profilepage.dart';
import 'package:src/services/apis/friendrequests.dart';
import 'package:src/services/apis/friends.dart';
import 'package:src/services/apis/notifications.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/widgets/utils/times.dart';

class NotificationsPage extends StatefulWidget {
  final userData user;

  const NotificationsPage({super.key, required this.user});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<searchUserDatas> friendRequests = [];
  List notifications = [];

  bool isLoading = true;

  Map friendBtnLoadings = {};

  bool friendRequestFullState = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () {
      initConfigures();
    });
  }

  void initConfigures() async {
    List<String> requestUsers =
        await friendRequestsDb().getFriendsIds(widget.user.id);
    friendRequests = await APIs.getFriendDetails(requestUsers);

    List<notificationModel> notificationList =
        await APIs.getNotifications(widget.user.id);
    if (notificationList.isNotEmpty) {
      List<String> userDocIdList =
          notificationList.map((notification) => notification.user).toList();
      List<searchUserDatas> userDetails =
          await APIs.getFriendDetails(userDocIdList);
      notifications.add(notificationList);
      notifications.add(userDetails);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> friendBtnsFunc(bool state, index) async {
    setState(() {
      friendBtnLoadings[index] = true;
    });
    String otherUserDocId = friendRequests[index].documentId;

    if (state) {
      await FriendsDb.addFriend(widget.user.id, otherUserDocId);
      await FriendsDb.addFriend(otherUserDocId, widget.user.id);
    }
    await friendRequestsDb.deleteField(widget.user.id, otherUserDocId);

    setState(() {
      friendBtnLoadings.remove(index);
      friendRequests.removeAt(index);
    });
  }

  void detailBtnsFunc(index) {
    List<notificationModel> notification = notifications[0];
    String process = notification[index].process;

    if (process == "messagerequest") {
      msgRequest(context, notification[index], index);
    }
  }

  void msgRequest(BuildContext otherContext, notificationModel data, index) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 32, 32, 32),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sana mesaj göndermek isteyen biri var!',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.user.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' adlı kullanıcı sana mesaj göndermek istiyor!' +
                          (data.desc.isNotEmpty
                              ? "\nSebebi: ${data.desc}"
                              : ""),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      List<notificationModel> notification = notifications[0];
                      List<searchUserDatas> userDetails = notifications[1];
                      notification.removeAt(index);
                      userDetails.removeAt(index);
                      setState(() {
                        notifications[0] = notification;
                        notifications[1] = userDetails;
                      });
                      NotificationsDb.deleteNotification(
                          widget.user.id, data.user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text("Reddet",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      loadingDilaog().show(otherContext);
                      await APIs.sendOtherUserMessage(
                          data.user, data.desc, Type.text, []);
                      NotificationsDb.deleteNotification(
                          widget.user.id, data.user);
                      Navigator.pop(otherContext);
                      Navigator.pop(otherContext);
                      userData? chatUser = await APIs.fetchData(data.user);
                      if (chatUser != null) {
                        Navigator.push(
                            otherContext,
                            MaterialPageRoute(
                                builder: (_) => ChatPage(otherUser: chatUser)));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text("Kabul Et",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> goToUserProfile(String docId) async {
    loadingDilaog().show(context);
    dynamic userData = await APIs.fetchData(docId);
    if (userData != null) {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProfilePage(user: userData)));
    } else {
      awesomeDialog().show(
          context,
          "Hata!",
          "Bir şeyler ters gitti bu yüzden kişinin profiline gidemedin.",
          "Tamam",
          "",
          DialogType.error,
          () {},
          null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 70,
              height: 100,
            ),
            const SizedBox(width: 8),
            const Text(
              "| Bildirimler",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : buildBody(),
    );
  }

  Widget buildBody() {
    return friendRequests.isEmpty && notifications.isEmpty
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/notificationempty.png",
                  width: 120,
                  height: 120,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 50, left: 50),
                  child: Text(
                    "Henüz herhangi bir bildirimin yok..",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              //build and show friend requests
              if (friendRequests.isNotEmpty) buildFriendRequestList(),

              //if friendRequest list > 4 then, create "+" button
              if (friendRequests.length > 4) createShowMoreBtn(),

              //Sizedbox
              const SizedBox(
                height: 5,
              ),

              //build notifications list
              if (notifications.isNotEmpty) buildNotificationsList(),
            ],
          );
  }

  Widget createShowMoreBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            minimumSize: const Size(double.infinity, 40),
          ),
          onPressed: () => setState(() {
                friendRequestFullState = !friendRequestFullState;
              }),
          child: Text(
            friendRequestFullState
                ? "Daha az göster"
                : "Devamını göster (${friendRequests.length - 4})",
            style: const TextStyle(color: Colors.grey),
          )),
    );
  }

  Widget buildFriendRequestList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.group,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                "Arkadaşlık İstekleri",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: friendRequestFullState != false
              ? friendRequests.length
              : friendRequests.length > 4
                  ? 4
                  : friendRequests.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                margin: const EdgeInsets.all(2.0),
                color: Colors.transparent,
                child: ListTile(
                  onTap: () =>
                      goToUserProfile(friendRequests[index].documentId),
                  leading: getProfileImage(friendRequests[index].pp),
                  title: Row(children: [
                    Text(
                      friendRequests[index].username,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  subtitle: Text(
                    friendRequests[index].about,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: friendBtnLoadings[index] != null
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeAlign: -6,
                          strokeWidth: 3,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => friendBtnsFunc(false, index),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                minimumSize: const Size(30, 10),
                              ),
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                            TextButton(
                              onPressed: () => friendBtnsFunc(true, index),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                minimumSize: const Size(30, 10),
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget getProfileImage(String image) {
    Size mq = MediaQuery.of(context).size;
    return image.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(mq.height * .3)),
            child: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,
              imageUrl: image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 50),
            ),
          )
        : CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueGrey,
            backgroundImage: Image.asset("assets/images/default.png").image,
          );
  }

  Widget buildNotificationsList() {
    List<notificationModel> notification = notifications[0];
    List<searchUserDatas> userDetails = notifications[1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                "Diğer Bildirimler",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: userDetails.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                margin: const EdgeInsets.all(2.0),
                color: Colors.transparent,
                child: ListTile(
                  onTap: () => goToUserProfile(userDetails[index].documentId),
                  leading: getProfileImage(userDetails[index].pp),
                  title: Row(children: [
                    Text(
                      userDetails[index].username,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  subtitle: SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification[index].header,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateUtil.getMessageTimes(
                            context: context,
                            lastActive: notification[index].time,
                          ),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () => detailBtnsFunc(index),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(30, 10),
                    ),
                    child: const Text(
                      "Detaylar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
