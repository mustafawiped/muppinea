// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/models/searchmodel.dart';
import 'package:src/pages/profile/profilepage.dart';
import 'package:src/services/apis/friendrequests.dart';
import 'package:src/services/apis/friends.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/useravatar.dart';

class createFriendsBox extends StatefulWidget {
  final searchUserDatas user;
  final bool isMe;
  final Function(String data) deleteItem;

  const createFriendsBox({
    super.key,
    required this.user,
    required this.isMe,
    required this.deleteItem,
  });

  @override
  State<createFriendsBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<createFriendsBox> {
  Map<String, bool> isButtonLoading = {};
  Map<String, bool> sendRequest = {};

  Future<void> onBtnClick() async {
    setState(() {
      isButtonLoading[widget.user.documentId] = true;
    });

    if (sendRequest[widget.user.documentId] != null) {
      await friendRequestsDb.deleteField(
          widget.user.documentId, AuthService.me.id);
      setState(() {
        isButtonLoading.remove(widget.user.documentId);
        sendRequest.remove(widget.user.documentId);
      });
    } else if (widget.isMe) {
      unfriendShow();
    } else {
      List state = await FriendsDb.containsField(
          AuthService.me.id, widget.user.documentId, true);

      if (state[0]) {
        setState(() {
          isButtonLoading.remove(widget.user.documentId);
        });
        awesomeDialog().show(
            context,
            "Zaten arkadaşsın!",
            "${widget.user.username} adlı kullanıcıyla zaten arkadaşsın. Bu yüzden istek gönderilmedi.",
            "Tamam",
            "",
            DialogType.error,
            () {},
            null);
      } else {
        await friendRequestsDb.sendRequest(widget.user.documentId);
        setState(() {
          isButtonLoading.remove(widget.user.documentId);
          sendRequest[widget.user.documentId] = true;
        });
      }
    }
  }

  void unfriendShow() {
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
                'Emin misin?',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Eğer ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: widget.user.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' arkadaşlıktan çıkarırsan, onun hakkında daha az bilgi alacaksın ve tekrar arkadaş olabilmek için, tekrar istek göndermen gerekecek.',
                      style: TextStyle(color: Colors.white),
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
                      setState(() {
                        isButtonLoading.remove(widget.user.documentId);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text("Vazgeç",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await FriendsDb.deleteField(
                          AuthService.me.id, widget.user.documentId);
                      await FriendsDb.deleteField(
                          widget.user.documentId, AuthService.me.id);
                      widget.deleteItem(widget.user.documentId);
                      isButtonLoading.remove(widget.user.documentId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text("Çıkar",
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

  @override
  void dispose() {
    super.dispose();

    isButtonLoading.clear();
    sendRequest.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (widget.isMe || widget.user.documentId != AuthService.me.id) {
            loadingDilaog().show(context);
            dynamic userData = await APIs.fetchData(widget.user.documentId);
            if (userData != null) {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfilePage(user: userData)));
            } else {
              Navigator.pop(context);
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
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfilePage(user: AuthService.me)));
          }
        },
        child: ListTile(
          // profil fotoğrafı
          leading: UserAvatar(filename: widget.user.pp),

          // kullanıcı adı
          title: Text(
            widget.user.username,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white),
          ),

          // hakkında
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),

          // arkadaş ekleme
          trailing: (widget.isMe || AuthService.me.id != widget.user.documentId)
              ? ElevatedButton(
                  onPressed: isButtonLoading[widget.user.documentId] != null
                      ? null
                      : onBtnClick,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(154, 73, 47, 85),
                  ),
                  child: isButtonLoading[widget.user.documentId] != null
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeAlign: -6,
                          strokeWidth: 3,
                        )
                      : Text(sendRequest[widget.user.documentId] != null
                          ? "Gönderildi"
                          : widget.isMe
                              ? "Çıkar"
                              : "Ekle"),
                )
              : null,
        ),
      ),
    );
  }
}
