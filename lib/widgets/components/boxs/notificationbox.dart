// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:src/models/searchmodel.dart';
import 'package:src/widgets/components/listavatar.dart';

class createNotificationBox extends StatefulWidget {
  final searchUserDatas user;
  final Function(String data) deleteItem;

  const createNotificationBox({
    super.key,
    required this.user,
    required this.deleteItem,
  });

  @override
  State<createNotificationBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<createNotificationBox> {
  Map<String, bool> isButtonLoading = {};
  Map<String, bool> sendRequest = {};

  void btnOnClick() {}

  @override
  void dispose() {
    super.dispose();

    isButtonLoading.clear();
    sendRequest.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // profil fotoğrafı
      leading: listAvatar(filename: widget.user.pp),

      // kullanıcı adı
      title: Text(
        widget.user.username,
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),

      // hakkında
      subtitle: Text(
        widget.user.about,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
