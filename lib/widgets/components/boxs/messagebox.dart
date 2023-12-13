import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:src/models/messagemodel.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/bubbles/image_bubble.dart';
import 'package:src/widgets/components/bubbles/text_bubble.dart';
import 'package:src/widgets/utils/times.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({super.key, required this.message, required this.seenState});

  final Message message;
  final bool seenState;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {
    bool isMe = AuthService.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        //messageDetailsBottomSheet(isMe);
      },
      child: isMe ? _purpleMessage() : _greyMessage(),
    );
  }

  Widget _greyMessage() {
    if (widget.seenState && widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return widget.message.type == Type.image
        ? BubbleNormalImage(
            id: widget.message.sent,
            image: CachedNetworkImage(imageUrl: widget.message.msg),
            color: const Color.fromARGB(255, 61, 61, 61),
            tail: true,
            isSender: false,
            delivered: true,
            seen: widget.message.read.isNotEmpty,
          )
        : BubbleNormal(
            text: widget.message.msg,
            isSender: false,
            color: const Color.fromARGB(255, 61, 61, 61),
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
            tail: false,
            sent: false,
            seen: false,
            time: DateUtil.getMessageTime(
                context: context, time: widget.message.sent),
          );
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
        : BubbleNormal(
            text: widget.message.msg,
            isSender: true,
            color: const Color.fromARGB(255, 112, 35, 112),
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
            tail: false,
            sent: true,
            time: DateUtil.getMessageTime(
                context: context, time: widget.message.sent),
            delivered: true,
            seen: widget.message.read.isNotEmpty ? true : false,
            edited: widget.message.edited,
          );
  }
}
