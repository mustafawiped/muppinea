// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/home/searchpage.dart';
import 'package:src/pages/profile/profilepage.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/boxs/chatbox.dart';
import 'package:src/widgets/components/boxs/statusbox.dart';
import 'package:src/widgets/components/useravatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  int TabState = 1;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    AuthService.getSelfInfo().then((value) {
      if (value) {
        setState(() {
          loading = false;
        });
      }
    });

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (AuthService.auth.currentUser != null) {
        if (message == "AppLifecycleState.resumed") {
          APIs.updateActiveStatus(true, false);
        }
        if (message == "AppLifecycleState.paused") {
          APIs.updateActiveStatus(false, false);
        }
        if (message == "AppLifecycleState.inactive") {
          APIs.updateActiveStatus(false, false);
        }
        if (message == "AppLifecycleState.hidden") {
          APIs.updateActiveStatus(false, false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SafeArea(
        child: Stack(
          children: [
            // header
            Column(
              children: [
                // Main Header
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (loading) return;
                          _globalKey.currentState!.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        width: 100,
                        height: 110,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // tabs
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 10),
                    children: [
                      TextButton(
                          onPressed: () {
                            if (loading) return;
                            setState(() {
                              TabState = 1;
                            });
                          },
                          child: Text(
                            "Sohbetler",
                            style: TextStyle(
                              color: TabState == 1 ? Colors.white : Colors.grey,
                              fontSize: 22,
                            ),
                          )),
                      const SizedBox(
                        width: 35,
                      ),
                      TextButton(
                          onPressed: () {
                            if (loading) return;
                            setState(() {
                              TabState = 2;
                            });
                          },
                          child: Text(
                            "Keşfet",
                            style: TextStyle(
                              color: TabState == 2 ? Colors.white : Colors.grey,
                              fontSize: 22,
                            ),
                          )),
                      const SizedBox(
                        width: 35,
                      ),
                      TextButton(
                          onPressed: () {
                            if (loading) return;
                            awesomeDialog().show(
                                context,
                                "Burası yapım aşamasında!",
                                "Muppin Erken Erişim'de olduğu için bu özellik henüz aktif değildir.",
                                "",
                                "Tamam",
                                DialogType.info,
                                null,
                                () {});
                          },
                          child: Text(
                            "Sunucular",
                            style: TextStyle(
                              color: TabState == 3 ? Colors.white : Colors.grey,
                              fontSize: 22,
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //      ** TAB STATE 1 **         //

            if (TabState == 1)
              // status design
              Positioned(
                top: 170,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 73, 47, 85),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Çevrimiçi Arkadaşlar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 90,
                        child: loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  createUserStatus(
                                      filename: AuthService.me.image,
                                      name: AuthService.me.username),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              ),

            if (TabState == 1)
              // chats design
              Positioned(
                top: 320,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.purple,
                        ))
                      : StreamBuilder(
                          stream: APIs.getAllUsers(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return const Center(
                                    child: CircularProgressIndicator());

                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                List list = data
                                        ?.map((e) => userData.fromMap(e.data()))
                                        .toList() ??
                                    [];

                                return ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 3, left: 5, right: 5),
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      return createChatMsg(
                                        userDt: list[index],
                                      );
                                    });
                            }
                          }),
                ),
              ),

            //      ** TAB STATE 2 **         //
            if (TabState == 2)
              const Center(
                child: Text(
                  "Keşfet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),

      // kullanıcı arama
      floatingActionButton: TabState == 3
          ? null
          : FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => searchScreen()));
              },
              backgroundColor: const Color.fromARGB(255, 73, 47, 85),
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),

      // drawer oluşturma
      drawer: createDrawer(
        onTap: () {
          if (loading) return;
          _globalKey.currentState!.closeDrawer();
        },
      ),
    );
  }
}

// ignore: camel_case_types
class createDrawer extends StatelessWidget {
  const createDrawer({super.key, this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 275,
      backgroundColor: Colors.black26,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
        right: Radius.circular(40),
      )),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 32, 32, 32),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: onTap,
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 56,
                      ),
                      const Text(
                        "Genel Bakış",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProfilePage(user: AuthService.me)));
                    },
                    child: Row(
                      children: [
                        UserAvatar(filename: AuthService.me.image),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AuthService.me.username,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              AuthService.me.email,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProfilePage(user: AuthService.me)));
                    },
                    child: const createDrawerItem(
                      headerText: "Hesap Ayarları",
                      icon: Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const createDrawerItem(
                    headerText: "Bildirim Ayarları",
                    icon: Icons.notification_add,
                    color: Colors.white,
                  ),
                  const createDrawerItem(
                    headerText: "Veri Depolama",
                    icon: Icons.storage,
                    color: Colors.white,
                  ),
                  const createDrawerItem(
                    headerText: "Sohbet Ayarı",
                    icon: Icons.chat,
                    color: Colors.white,
                  ),
                  const createDrawerItem(
                    headerText: "Genel Ayarlar",
                    icon: Icons.settings,
                    color: Colors.white,
                  ),
                  const createDrawerItem(
                    headerText: "Yardım",
                    icon: Icons.help,
                    color: Colors.white,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 73, 47, 85),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      awesomeDialog().show(
                          context,
                          "Hey, emin misin?",
                          "Hesabından çıkış yapmak istediğine emin misin?",
                          "Çıkış Yap",
                          "Değilim",
                          DialogType.warning, () async {
                        await APIs.updateActiveStatus(false, true);
                        AuthService.signOut();
                      }, () {});
                    },
                    child: const createDrawerItem(
                      headerText: "Çıkış Yap",
                      icon: Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void emptyFunc() {}
}

// ignore: camel_case_types, drawer oluşturma
class createDrawerItem extends StatelessWidget {
  final String headerText;
  final icon;
  final color;
  const createDrawerItem({
    super.key,
    required this.headerText,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        children: [
          Icon(
            icon as IconData?,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            headerText,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
