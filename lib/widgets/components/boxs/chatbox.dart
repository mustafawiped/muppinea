import 'package:flutter/material.dart';
import 'package:src/dialogs/profiledialog.dart';
import 'package:src/models/messagemodel.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/chat/chatpage.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/useravatar.dart';
import 'package:src/widgets/utils/times.dart';

// ignore: camel_case_types
class createChatMsg extends StatelessWidget {
  final userData userDt;

  const createChatMsg({
    super.key,
    required this.userDt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatPage(otherUser: userDt)));
        },
        child: StreamBuilder(
            stream: APIs.getLastMessage(userDt),
            builder: (context, snapshot) {
              Message? message;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const SizedBox();

                case ConnectionState.active:
                case ConnectionState.done:
                  // docs
                  final data = snapshot.data?.docs;
                  if (data == null) {
                    return const ListTile();
                  }
                  final list = data
                      .map((e) =>
                          Message.fromJson(e.data() as Map<String, dynamic>))
                      .toList();
                  if (list.isNotEmpty) {
                    message = list[0];
                  }

                  return ListTile(
                    leading: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => ProfileDialog(
                                    user: userDt,
                                  ));
                        },
                        child: UserAvatar(filename: userDt.image)),

                    // kullanıcı adı
                    title: Text(
                      userDt.username,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    // son mesaj
                    subtitle: message?.fromId != AuthService.user.uid
                        ? message?.type == Type.image
                            ? const Row(
                                children: [
                                  Icon(
                                    Icons.photo,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text("Fotoğraf"),
                                ],
                              )
                            : Text(
                                message != null
                                    ? message.msg.length > 25
                                        ? '${message.msg.substring(0, 22)}...'
                                        : message.msg
                                    : userDt.about.length > 30
                                        ? '${userDt.about.substring(0, 27)}...'
                                        : userDt.about,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                        : message?.type == Type.image
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.done_all_rounded,
                                    size: 17,
                                    color: message!.read.isEmpty
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                                  const Icon(
                                    Icons.photo,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Text("Fotoğraf"),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(
                                    Icons.done_all_rounded,
                                    size: 17,
                                    color: message!.read.isEmpty
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    message.msg.length > 25
                                        ? '${message.msg.substring(0, 22)}...'
                                        : message.msg,
                                    maxLines: 1,
                                  ),
                                ],
                              ),

                    // son mesaj zamanı
                    trailing: message == null
                        ? null
                        : message.read.isEmpty &&
                                message.fromId != AuthService.user.uid
                            ? Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent.shade400,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : Text(
                                DateUtil.getLastMessageTime(
                                    context: context, time: message.sent),
                                style: const TextStyle(color: Colors.black54),
                              ),
                  );
              }
            }),
      ),
    );
  }
}
