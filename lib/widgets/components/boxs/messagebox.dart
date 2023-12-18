// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/models/messagemodel.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/bubbles/image_bubble.dart';
import 'package:src/widgets/components/bubbles/reply_bubble.dart';
import 'package:src/widgets/components/bubbles/text_bubble.dart';
import 'package:src/widgets/utils/times.dart';

class MessageBox extends StatefulWidget {
  const MessageBox(
      {super.key,
      required this.message,
      required this.seenState,
      required this.otherUsername});

  final Message message;
  final bool seenState;
  final String otherUsername;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    bool isMe = AuthService.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        messageDetailsBottomSheet(isMe);
      },
      child: isMe ? _purpleMessage() : _greyMessage(),
    );
  }

  void messageDetailsBottomSheet(bool isMe) {
    Size mq = MediaQuery.of(context).size;

    showModalBottomSheet(
        context: context,
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              // black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              if (widget.message.type == Type.text)
                // Copy Item
                _OptionItem(
                    const Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue,
                      size: 20,
                    ),
                    "Metni Kopyala", () async {
                  await Clipboard.setData(
                          ClipboardData(text: widget.message.msg))
                      .then((value) {
                    Navigator.pop(context);
                  });
                }),

              if (widget.message.type == Type.image)
                // Copy Item
                _OptionItem(
                    const Icon(
                      Icons.download_rounded,
                      color: Colors.blue,
                      size: 20,
                    ),
                    "Resmi Kaydet", () async {
                  Navigator.pop(context);
                  loadingDilaog().show(context);
                  bool state = await _saveImage(widget.message.msg, 100);
                  Navigator.pop(context);
                  awesomeDialog().show(
                      context,
                      state ? "Başarılı!" : "Bir şeyler ters gitti.",
                      state
                          ? "Resim başarıyla kaydedildi."
                          : "Üzgünüz, bir sorun oluştu ve resim indirilemedi. İnternet bağlantını kontrol et.",
                      state ? "" : "Tamam",
                      state ? "Tamam" : "",
                      state ? DialogType.success : DialogType.error,
                      state ? null : () {},
                      state ? () {} : null);
                }),

              // Divider
              Divider(
                color: const Color.fromARGB(255, 73, 47, 85),
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              if (widget.message.type == Type.text && isMe)
                // Edit option
                _OptionItem(
                    const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 20,
                    ),
                    "Mesajı düzenle", () {
                  Navigator.pop(context);
                  _showMessageUpdateDialog();
                }),

              if (isMe)
                // Delete option
                _OptionItem(
                    const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                      size: 20,
                    ),
                    "Mesajı sil", () async {
                  await APIs.deleteMessage(widget.message);
                  Navigator.pop(context);
                }),

              if (isMe)
                // Divider
                Divider(
                  color: const Color.fromARGB(255, 73, 47, 85),
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              // Sent Time Option
              _OptionItem(
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                    size: 20,
                  ),
                  "Teslim Edildi: ${DateUtil.getMessageTime(context: context, time: widget.message.sent)}",
                  () {}),

              // read time
              _OptionItem(
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                    size: 20,
                  ),
                  "Görüldü: ${widget.message.read == "" ? "Henüz görülmedi" : DateUtil.getMessageTime(context: context, time: widget.message.read)}",
                  () {}),

              if (widget.message.edited.isNotEmpty)
                // edited time
                _OptionItem(
                    const Icon(
                      Icons.update,
                      color: Colors.blue,
                      size: 20,
                    ),
                    "Düzenlendi: ${DateUtil.getMessageTime(context: context, time: widget.message.edited)}",
                    () {}),
            ],
          );
        });
  }

  Widget _greyMessage() {
    if (widget.seenState && widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    if (widget.message.type == Type.image) {
      return BubbleNormalImage(
        id: widget.message.sent,
        image: CachedNetworkImage(imageUrl: widget.message.msg),
        color: const Color.fromARGB(255, 61, 61, 61),
        tail: true,
        isSender: false,
      );
    } else {
      return widget.message.reply.isEmpty
          ? BubbleNormal(
              text: widget.message.msg,
              isSender: false,
              color: const Color.fromARGB(255, 61, 61, 61),
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              tail: false,
              sent: false,
              seen: false,
              time: DateUtil.getMessageTimes(
                  context: context, lastActive: widget.message.sent),
              edited: widget.message.edited,
            )
          : ReplyBubble(
              text: widget.message.msg,
              isSender: false,
              color: const Color.fromARGB(255, 61, 61, 61),
              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              tail: false,
              sent: false,
              seen: false,
              time: DateUtil.getMessageTimes(
                  context: context, lastActive: widget.message.sent),
              replymessage: widget.message.reply[1],
              username: widget.message.reply[0]
                  ? widget.otherUsername
                  : AuthService.me.username,
              edited: widget.message.edited,
            );
    }
  }

  Widget _purpleMessage() {
    return widget.message.type == Type.image
        ? BubbleNormalImage(
            id: widget.message.sent,
            image: CachedNetworkImage(imageUrl: widget.message.msg),
            color: const Color.fromARGB(255, 112, 35, 112),
            tail: true,
            isSender: true,
            sent: true,
            delivered: true,
            seen: widget.message.read.isNotEmpty,
          )
        : widget.message.reply.isEmpty
            ? BubbleNormal(
                text: widget.message.msg,
                isSender: true,
                color: const Color.fromARGB(255, 112, 35, 112),
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                tail: false,
                sent: true,
                time: DateUtil.getMessageTimes(
                    context: context, lastActive: widget.message.sent),
                delivered: true,
                seen: widget.message.read.isNotEmpty ? true : false,
                edited: widget.message.edited,
              )
            : ReplyBubble(
                text: widget.message.msg,
                isSender: true,
                color: const Color.fromARGB(255, 112, 35, 112),
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                tail: false,
                sent: true,
                time: DateUtil.getMessageTimes(
                    context: context, lastActive: widget.message.sent),
                delivered: true,
                seen: widget.message.read.isNotEmpty ? true : false,
                edited: widget.message.edited,
                replymessage: widget.message.reply[1],
                username: widget.message.reply[0]
                    ? AuthService.me.username
                    : widget.otherUsername,
              );
  }

  Future<bool> _saveImage(String url, int quality) async {
    try {
      var response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: quality, name: "MuppinImages");
      return true;
    } catch (e) {
      return false;
    }
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;
    BuildContext dialogContext;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 32, 32, 32),
          contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Text(
                "Mesajı Güncelle",
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
            initialValue: updatedMsg,
            minLines: 1,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => updatedMsg = value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
                  await APIs.updateMessage(widget.message, updatedMsg);
                },
                child: const Text(
                  "Düzenle",
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
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(this.icon, this.name, this.onTap);

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              "        $name",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white54,
                letterSpacing: 0.5,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
