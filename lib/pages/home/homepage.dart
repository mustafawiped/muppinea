import 'package:flutter/material.dart';
import 'package:src/services/auth/authservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  int TabState = 1;

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
                            setState(() {
                              TabState = 3;
                            });
                          },
                          child: Text(
                            "Market",
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
                            "Hikayeler",
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
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            createUserStatus(
                                filename: "img1.jpg", name: "Hikayen"),
                            createUserStatus(
                                filename: "img2.jpg", name: "mustafawiped"),
                            createUserStatus(
                                filename: "img3.jpg", name: "Salih"),
                            createUserStatus(
                                filename: "img4.jpg", name: "Ersin"),
                            createUserStatus(
                                filename: "img5.jpg", name: "Ahmet"),
                            createUserStatus(
                                filename: "img6.jpg", name: "Mustafa"),
                            createUserStatus(
                                filename: "img7.jpg", name: "Burak"),
                            createUserStatus(
                                filename: "img8.jpg", name: "Saliha"),
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
                    color: Color(0xFFEFFFFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
                    children: [
                      createChatMsg(
                        profilePicture: "img1.jpg",
                        username: "mustafawiped",
                        lastMsg: "Hey orada mısın?",
                        notification: 3,
                        time: "9:35 PM",
                        onClick: () {},
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      createChatMsg(
                        profilePicture: "img3.jpg",
                        username: "katarinabluu",
                        lastMsg: "Senden hoşlanıyorum sanırım..",
                        notification: 2,
                        time: "1:40 PM",
                        onClick: () {},
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      createChatMsg(
                        profilePicture: "img2.jpg",
                        username: "thv",
                        lastMsg: "anlaştık.",
                        notification: 0,
                        time: "8:54 PM",
                        onClick: () {},
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      createChatMsg(
                        profilePicture: "img4.jpg",
                        username: "jungkook",
                        lastMsg: "standing next to youu!",
                        notification: 0,
                        time: "8:54 PM",
                        onClick: () {},
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
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

            //      ** TAB STATE 3 **         //
            if (TabState == 3)
              const Center(
                child: Text(
                  "Market",
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
              onPressed: () {
                AuthService.signOut();
              },
              backgroundColor: const Color.fromARGB(255, 73, 47, 85),
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),

      // drawer oluşturma
      drawer: const createDrawer(),
    );
  }
}

// ignore: camel_case_types, Sohbet mesajlarını oluşturma
class createChatMsg extends StatelessWidget {
  final String profilePicture;
  final String username;
  final String lastMsg;
  final String time;
  final int notification;
  final Function() onClick;

  const createChatMsg({
    super.key,
    required this.profilePicture,
    required this.username,
    required this.lastMsg,
    required this.time,
    required this.notification,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              UserAvatar(filename: profilePicture),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    lastMsg,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (notification != 0)
                CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.purple,
                  child: Text(
                    notification.toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

// ignore: camel_case_types, Hikaye oluşturma
class createUserStatus extends StatelessWidget {
  final String filename;
  final String name;
  const createUserStatus({
    super.key,
    required this.filename,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          children: [
            UserAvatar(filename: filename),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kullanıcı avatarı oluşturma
class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 29,
      backgroundColor: Colors.white24,
      child: CircleAvatar(
        radius: 26,
        backgroundImage: Image.asset("assets/silinecekler/$filename").image,
      ),
    );
  }
}

// ignore: camel_case_types, drawer oluşturma sınıfı
class createDrawer extends StatelessWidget {
  const createDrawer({super.key});

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
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 56,
                      ),
                      Text(
                        "Genel Bakış",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      UserAvatar(filename: "img1.jpg"),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "mustafawiped",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  createDrawerItem(
                    headerText: "Profil",
                    icon: Icons.person,
                    color: Colors.white,
                  ),
                  createDrawerItem(
                    headerText: "Bildirim Ayarları",
                    icon: Icons.notification_add,
                    color: Colors.white,
                  ),
                  createDrawerItem(
                    headerText: "Veri Depolama",
                    icon: Icons.storage,
                    color: Colors.white,
                  ),
                  createDrawerItem(
                    headerText: "Sohbet Ayarı",
                    icon: Icons.storage,
                    color: Colors.white,
                  ),
                  createDrawerItem(
                    headerText: "Genel Ayarlar",
                    icon: Icons.settings,
                    color: Colors.white,
                  ),
                  createDrawerItem(
                    headerText: "Yardım",
                    icon: Icons.help,
                    color: Colors.white,
                  ),
                  Divider(
                    color: Color.fromARGB(255, 73, 47, 85),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  createDrawerItem(
                    headerText: "Çıkış Yap",
                    icon: Icons.logout,
                    color: Colors.white,
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
    return InkWell(
      onTap: () {},
      child: Padding(
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
      ),
    );
  }
}
