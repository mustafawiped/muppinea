// ignore_for_file: camel_case_types

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/services/apis/notifications.dart';
import 'package:src/services/auth/authservice.dart';

class messageRequest {
  void messageReq(BuildContext context, String userId) {
    awesomeDialog().show(
        context,
        "Mesaj Gönderilemiyor.",
        "Bu kişi direkt mesajları kabul etmiyor. Ona mesaj gönderebilmek için, mesaj isteği atmalısın. Neden mesaj atmak istediğini ona birkaç cümle ile söylemek ister misin?",
        "Hayır",
        "Evet",
        DialogType.question,
        () {}, () {
      String msg = "";
      BuildContext dialogContext;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: const Color.fromARGB(255, 32, 32, 32),
            contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Text(
                  "Mesaj isteği gönder",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.message,
                  color: Color.fromARGB(255, 73, 47, 85),
                  size: 28,
                ),
              ],
            ),
            content: TextFormField(
              initialValue: msg,
              minLines: 1,
              maxLines: 4,
              maxLength: 50,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => msg = value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Sizinle tanışabilir miyim?",
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            actions: [
              // cancel button
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MaterialButton(
                  color: const Color.fromARGB(255, 73, 47, 85),
                  shape: const StadiumBorder(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "İptal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // update button
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MaterialButton(
                  color: const Color.fromARGB(255, 73, 47, 85),
                  shape: const StadiumBorder(),
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    NotificationsDb.addNotification(
                        userId,
                        AuthService.user.uid,
                        "Sana mesaj göndermek istiyor!",
                        msg,
                        "messagerequest");

                    Fluttertoast.showToast(
                        msg: "İstek Gönderildi!",
                        toastLength: Toast.LENGTH_SHORT);
                  },
                  child: const Text(
                    "Gönder",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      );
    });
  }
}
