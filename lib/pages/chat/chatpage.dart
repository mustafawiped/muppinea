// ignore_for_file: deprecated_member_use, sort_child_properties_last

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/models/messagemodel.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/profile/profilepage.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/boxs/messagebox.dart';
import 'package:src/widgets/utils/times.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatPage extends StatefulWidget {
  final userData otherUser;

  const ChatPage({super.key, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  static final FocusNode focusNode = FocusNode();
  List<Message> _list = [];

  final _textController = TextEditingController();

  bool _showEmoji = false,
      _isUpLoading = false,
      appLifeStyle = true,
      _isReplyState = false;

  String replyString = "";
  bool replyUser = false;

  late Size mq;

  bool state = false;

  @override
  void initState() {
    super.initState();
    state = true;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 32, 32, 32),
      statusBarIconBrightness: Brightness.light,
    ));

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (!state) {
        return Future.value(message);
      }
      if (message == "AppLifecycleState.resumed") {
        setState(() {
          appLifeStyle = true;
        });
      }
      if (message == "AppLifecycleState.paused") {
        setState(() {
          appLifeStyle = false;
        });
      }
      if (message == "AppLifecycleState.inactive") {
        setState(() {
          appLifeStyle = false;
        });
      }
      return Future.value(message);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    state = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 32, 32, 32),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 32, 32, 32),
              automaticallyImplyLeading: false,
              flexibleSpace: createAppBar(),
            ),
            body: Column(
              children: [
                // Messages List
                _chatMessages(),

                if (_isUpLoading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),

                //input
                createInput(),

                //emoji
                if (_showEmoji) _emojiPicker(),
              ],
            )),
      ),
    );
  }

  // App bar Design Codes
  Widget createAppBar() {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: Color.fromARGB(255, 32, 32, 32),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfilePage(user: widget.otherUser)));
          },
          child: StreamBuilder(
            stream: APIs.getUserInfo(widget.otherUser),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list = data
                      ?.map(
                        (e) => userData.fromMap(e.data()),
                      )
                      .toList() ??
                  [];

              return Row(
                children: [
                  // back button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  // profile photo
                  widget.otherUser.image.isNotEmpty
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(mq.height * .3)),
                          child: CachedNetworkImage(
                            width: mq.height * .055,
                            height: mq.height * .055,
                            imageUrl: widget.otherUser.image,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, size: 50),
                          ),
                        )
                      : CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueGrey,
                          backgroundImage:
                              Image.asset("assets/images/default.png").image,
                        ),

                  // sizedbox.
                  const SizedBox(
                    width: 10,
                  ),

                  // isim
                  Column(
                    // dikey ortalama
                    mainAxisAlignment: MainAxisAlignment.center,

                    // yatay hizalama
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // boşluk..
                      const SizedBox(
                        height: 2,
                      ),

                      // kullanıcı adı
                      Text(
                        list.isNotEmpty
                            ? list[0].username
                            : widget.otherUser.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),

                      // alt bilgi
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? "Çevrimiçi"
                                : DateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : DateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.otherUser.lastActive),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Message Input Design Codes
  Widget createInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .001, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 73, 47, 85),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  if (_isReplyState)
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 192, 120, 205),
                            Color.fromARGB(255, 54, 0, 80),
                            Color.fromARGB(255, 54, 0, 80),
                            Color.fromARGB(255, 54, 0, 80),
                          ],
                          stops: [0.0, 0.05, 0.2, 1.0],
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
                                  replyUser
                                      ? AuthService.me.username
                                      : widget.otherUser.username,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 192, 120, 205),
                                    fontSize: 14,
                                    fontWeight: FontWeight
                                        .bold, // Color.fromARGB(255, 54, 0, 80),
                                  ),
                                ),
                              ),
                              replyString.contains("MuppinImgMsg:Id=")
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
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        replyString,
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
                          Positioned(
                            top: 0,
                            right: 3,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isReplyState = !_isReplyState;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      // emoji button
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() => _showEmoji = !_showEmoji);
                        },
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),

                      Expanded(
                          child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        focusNode: focusNode,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Mesaj..",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        maxLines: 4,
                        minLines: 1,
                        onTap: () {
                          setState(() {
                            if (_showEmoji) {
                              setState(() {
                                _showEmoji = !_showEmoji;
                              });
                            }
                          });
                        },
                      )),

                      if (!_isReplyState)
                        // image button
                        IconButton(
                          onPressed: () async {
                            if (_isUpLoading) {
                              awesomeDialog().show(
                                  context,
                                  "Hata!",
                                  "Şuanki yükleme bittiğinde yeni fotoğraf/fotoğraflar ekleyebilirsin",
                                  "Tamam",
                                  "",
                                  DialogType.error,
                                  () {},
                                  null);
                              return;
                            }

                            final picker = ImagePicker();
                            final List<XFile> images =
                                await picker.pickMultiImage(imageQuality: 70);
                            setState(() {
                              _isUpLoading = true;
                            });
                            for (XFile i in images) {
                              await APIs.sendChatImage(
                                  widget.otherUser, File(i.path));
                            }
                            setState(() {
                              _isUpLoading = false;
                            });
                          },
                          icon: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),

                      if (!_isReplyState)
                        // camera button
                        IconButton(
                          onPressed: () async {
                            if (_isUpLoading) {
                              awesomeDialog().show(
                                  context,
                                  "Hata!",
                                  "Şuanki yükleme bittiğinde yeni fotoğraf/fotoğraflar ekleyebilirsin",
                                  "Tamam",
                                  "",
                                  DialogType.error,
                                  () {},
                                  null);
                              return;
                            }

                            final picker = ImagePicker();
                            var pickedFile = await picker.pickImage(
                                source: ImageSource.camera, imageQuality: 70);
                            if (pickedFile != null) {
                              setState(() {
                                _isUpLoading = true;
                              });
                              await APIs.sendChatImage(
                                  widget.otherUser, File(pickedFile.path));
                              setState(() {
                                _isUpLoading = false;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              String text = _textController.text;
              if (text.trim().isNotEmpty) {
                List replyList = _isReplyState ? [replyUser, replyString] : [];
                APIs.sendMessage(widget.otherUser, text, Type.text, replyList);
                _textController.clear();
                setState(() {
                  _isReplyState = false;
                });
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.blue,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // Chat Messages Design and Backend Codes
  Widget _chatMessages() {
    return Expanded(
      child: StreamBuilder(
        stream: APIs.getAllMessages(widget.otherUser),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const SizedBox();

            case ConnectionState.active:
            case ConnectionState.done:

              // docs
              final data = snapshot.data?.docs;

              // message list
              _list = data!.map((e) => Message.fromJson(e.data())).toList();

              // realistic
              if (_list.isNotEmpty) {
                return ListView.builder(
                  itemCount: _list.length,
                  reverse: true,
                  padding: EdgeInsets.only(top: mq.height * .01),
                  itemBuilder: (context, index) {
                    return SwipeTo(
                      child: MessageBox(
                        message: _list[index],
                        seenState: appLifeStyle,
                        otherUsername: widget.otherUser.username,
                      ),
                      onRightSwipe: (details) {
                        replyUser = AuthService.me.id == _list[index].fromId;
                        replyString = _list[index].type == Type.text
                            ? _list[index].msg
                            : "MuppinImgMsg:Id=${_list[index].sent}";
                        focusNode.requestFocus();
                        setState(() {
                          _isReplyState = true;
                        });
                      },
                      iconColor: Colors.white,
                    );
                  },
                );
              } else {
                return Center(
                  child: InkWell(
                    onTap: () {
                      APIs.sendMessage(
                          widget.otherUser, "Merhaba 👋", Type.text, []);
                    },
                    child: const Text(
                      '"Merhaba 👋"\ndemek ister misin?',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget _emojiPicker() {
    return SizedBox(
      height: mq.height * .35,
      child: EmojiPicker(
        textEditingController: _textController,
        config: Config(
          bgColor: const Color.fromARGB(255, 32, 32, 32),
          columns: 8,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        ),
      ),
    );
  }
}
