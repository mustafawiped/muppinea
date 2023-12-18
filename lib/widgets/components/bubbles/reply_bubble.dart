import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const double BUBBLE_RADIUS = 16;

///basic chat bubble type
///
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state
///chat bubble [TextStyle] can be customized using [textStyle]

class ReplyBubble extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final String text;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final String time;
  final TextStyle textStyle;
  final String edited;
  final BoxConstraints? constraints;
  final String username;
  final String replymessage;

  const ReplyBubble({
    Key? key,
    required this.text,
    this.constraints,
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.time = "00:00",
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.edited = "",
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    required this.username,
    required this.replymessage,
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints: constraints ??
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(tail
                      ? isSender
                          ? bubbleRadius
                          : 0
                      : BUBBLE_RADIUS),
                  bottomRight: Radius.circular(tail
                      ? isSender
                          ? 0
                          : bubbleRadius
                      : BUBBLE_RADIUS),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: isSender
                            ? [
                                const Color.fromARGB(255, 192, 120, 205),
                                const Color.fromARGB(255, 54, 0, 80),
                                const Color.fromARGB(255, 54, 0, 80),
                                const Color.fromARGB(255, 54, 0, 80),
                              ]
                            : [
                                const Color.fromARGB(255, 192, 120, 205),
                                const Color.fromARGB(255, 32, 32, 32),
                                const Color.fromARGB(255, 32, 32, 32),
                                const Color.fromARGB(255, 32, 32, 32),
                              ],
                        stops: const [0.0, 0.05, 0.2, 1.0],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                username,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 192, 120, 205),
                                  fontSize: 14,
                                  fontWeight: FontWeight
                                      .bold, // Color.fromARGB(255, 54, 0, 80),
                                ),
                              ),
                            ),
                            replymessage.contains("MuppinImgMsg:Id=")
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.photo,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Fotoğraf",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      replymessage,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: textStyle,
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                children: [
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  if (edited.isNotEmpty)
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  if (edited.isNotEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text(
                                        "(düzenlendi)",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 7,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      stateIcon != null && stateTick
                          ? Positioned(
                              bottom: 4,
                              right: 6,
                              child: stateIcon,
                            )
                          : const SizedBox(
                              width: 1,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
