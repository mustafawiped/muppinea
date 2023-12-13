import 'package:flutter/material.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/chat/chatpage.dart';
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
        child: ListTile(
          // kullanıcı profil fotoğrafı
          leading:
              InkWell(onTap: () {}, child: UserAvatar(filename: userDt.image)),

          // kullanıcı adı
          title: Text(
            userDt.username,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          // son mesaj
          subtitle: Row(
            children: [
              const Icon(Icons.done_all_rounded, size: 17, color: Colors.grey),
              const SizedBox(
                width: 2,
              ),
              Text(
                // max 25 karakter
                userDt.about.length > 28
                    ? '${userDt.about.substring(0, 25)}...'
                    : userDt.about,
              ),
            ],
          ),

          // son mesaj zamanı
          trailing: Text(
            DateUtil.getLastMessageTime(
                context: context, time: userDt.lastActive),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
