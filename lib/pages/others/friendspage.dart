import 'package:flutter/material.dart';
import 'package:src/models/searchmodel.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/services/apis/friends.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/widgets/components/boxs/friendsbox.dart';

class FriendsPage extends StatefulWidget {
  final userData user;
  final bool isMe;

  const FriendsPage({super.key, required this.user, required this.isMe});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool isLoading = true;
  List<searchUserDatas> myFriends = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () {
      initConfigures();
    });
  }

  Future<void> initConfigures() async {
    List<String> myFriendsIds = await FriendsDb().getFriendsIds(widget.user.id);
    myFriends = await APIs.getFriendDetails(widget.user.id, myFriendsIds);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 70,
                height: 100,
              ),
              const SizedBox(width: 8),
              Text(
                isLoading ? "| Yükleniyor.." : "| ${widget.user.username}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 32, 32, 32),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            isScrollable: false,
            unselectedLabelStyle:
                const TextStyle(fontSize: 14.0, color: Colors.grey),
            labelStyle: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            tabs: [
              Tab(
                text: isLoading ? "Yükleniyor.." : "Arkadaşlar",
              ),
              Tab(text: isLoading ? "Yükleniyor.." : "Senin İçin"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      "Yükleniyor..",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            : TabBarView(
                children: [
                  createList(),
                  createBuilding(),
                ],
              ),
      ),
    );
  }

  Widget createList() {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      color: const Color.fromARGB(255, 32, 32, 32),
      child: Column(
        children: [
          // search
          createSearch(),

          // list
          createItemList(),
        ],
      ),
    );
  }

  // Search
  Widget createSearch() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
      child: TextField(
        maxLength: 20,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.purple,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          //filterData(value);
        },
        maxLines: 1,
        onChanged: (String value) {
          //filterData(value);
        },
        decoration: const InputDecoration(
          hintText: 'Ara..',
          hintStyle: TextStyle(color: Color.fromARGB(255, 123, 123, 123)),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.purple,
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 54, 54, 54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 0.0,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          counterText: "",
        ),
      ),
    );
  }

  // Items List
  Widget createItemList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: myFriends.length,
      itemBuilder: (context, index) {
        return createFriendsBox(
          user: myFriends[index],
          isMe: widget.isMe,
          deleteItem: deleteItem,
        );
      },
    );
  }

  void deleteItem(String data) {
    setState(() {
      myFriends.removeWhere((user) => user.documentId == data);
    });
  }

  Widget createBuilding() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/building.png",
            width: 200,
            height: 200,
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 50, left: 50),
            child: Text(
              "Burası yapım aşamasında! Yakın bir tarihte burada sana yeni insanlar önereceğiz!",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
