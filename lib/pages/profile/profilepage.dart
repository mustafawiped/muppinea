import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:src/models/usermodel.dart';
import 'package:src/pages/profile/profileedit.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/services/shippers/badges.dart';
import 'package:src/widgets/components/numberswidget.dart';
import 'package:src/widgets/utils/times.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final userData user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isMe = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () {
      initConfigures();
    });
  }

  void initConfigures() {
    isMe = widget.user.id == AuthService.me.id;
    setState(() {
      isLoading = false;
    });
  }

  void btnOnClick() {
    if (isMe) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProfileEdit(user: widget.user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          actions: isMe
              ? null
              : [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ))
                ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Column(
                      children: [
                        // profile photo
                        profilePhotoWidget(mq),

                        //sizedbox
                        const SizedBox(
                          height: 24,
                        ),

                        //name and mail
                        buildName(),

                        //sized box
                        const SizedBox(
                          height: 24,
                        ),

                        //add friend button or profile edit button
                        buildAddFriendButton(
                            isMe ? "Profili Düzenle" : "Arkadaş Ekle",
                            btnOnClick),

                        //sized box
                        const SizedBox(height: 24),

                        //friends and popularity
                        NumbersWidget(
                            friendCount: "0",
                            popularity: "1.0",
                            badgeCount: widget.user.badges.length.toString()),

                        //sized box
                        const SizedBox(
                          height: 24,
                        ),

                        //about
                        buildAbout(),

                        //sized box
                        const SizedBox(
                          height: 24,
                        ),

                        //badges
                        if (widget.user.badges.isNotEmpty) buildBadges(),

                        //sizedbox
                        if (widget.user.badges.isNotEmpty)
                          const SizedBox(
                            height: 24,
                          ),

                        //joined date
                        buildJoined(),

                        //sizedbox
                        if (widget.user.socials.isNotEmpty)
                          const SizedBox(
                            height: 24,
                          ),

                        //socials
                        if (widget.user.socials.isNotEmpty) buildSocials(),

                        //sizedbox
                        if (widget.user.socials.isNotEmpty)
                          const SizedBox(
                            height: 24,
                          ),
                      ],
                    ),
            ),
          ),
        ));
  }

  Widget profilePhotoWidget(Size mq) {
    return widget.user.image.isEmpty
        ? Container(
            width: mq.height * .2,
            height: mq.height * .2,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(mq.height * .1),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(mq.height * .1),
              ),
              child: Image.asset(
                "assets/images/default.png",
                width: mq.height * .2,
                height: mq.height * .2,
                fit: BoxFit.cover,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(mq.height * .1)),
            child: CachedNetworkImage(
              width: mq.height * .2,
              height: mq.height * .2,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 50),
            ),
          );
  }

  Widget buildName() {
    return Column(
      children: [
        Text(
          widget.user.username,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          widget.user.email,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildAddFriendButton(String text, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        foregroundColor: const Color.fromARGB(255, 32, 32, 32),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      onPressed: onClicked,
      child: Text(text),
    );
  }

  Widget buildAbout() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hakkında',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            widget.user.about,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.grey,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget buildBadges() {
    List userBadges = widget.user.badges;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rozetler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          buildBadgeIcons(userBadges),
        ],
      ),
    );
  }

  Widget buildBadgeIcons(List userBadges) {
    if (userBadges.isEmpty) {
      return const Row();
    }
    return Row(
      children: userBadges.map((badgeIndex) {
        return InkWell(
          onTap: () {
            showBadgeInfo(badgeIndex);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: buildBadgeIcon(badgeIndex),
          ),
        );
      }).toList(),
    );
  }

  void showBadgeInfo(int index) {
    String text = index == 0
        ? "Erken Dönem Destekçisi"
        : index == 1
            ? "Bug Hunter"
            : index == 2
                ? "Elite"
                : index == 3
                    ? "Admin"
                    : "Erken Dönem Destekçisi";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 200.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 32, 32, 32),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildBadgeIcon(index),
                  const SizedBox(height: 10.0),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showSocialInfo(String social, String link) {
    String text = social == "discord" ? "discord.gg/$link" : "@$link";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 200.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 32, 32, 32),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/socials/$social.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MaterialButton(
                      color: const Color.fromARGB(255, 73, 47, 85),
                      shape: const StadiumBorder(),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        String url = social == "discord"
                            ? "https://www.discord.gg/$link"
                            : social == "instagram" || social == "twitter"
                                ? "https://www.$social.com/$link"
                                : "https://www.youtube.com/@$link";
                        Uri urls = Uri.parse(url);
                        launchUrl(urls);
                      },
                      child: const Text(
                        "Yönlendir",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBadgeIcon(int badgeIndex) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.transparent,
      child: Image.asset(
        Badges().allBadges[badgeIndex],
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildJoined() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Katılım Tarihi',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            DateUtil.getJoinedDate(
                context: context, lastActive: widget.user.createdAt),
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget buildSocials() {
    Map socials = widget.user.socials;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bağlantılar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          buildSocialIcons(socials),
        ],
      ),
    );
  }

  Widget buildSocialIcons(Map userSocials) {
    List<String> socialPlatforms = [
      'instagram',
      'twitter',
      'youtube',
      'discord'
    ];
    List<Widget> socialIcons = [];
    for (String platform in socialPlatforms) {
      if (userSocials.containsKey(platform) && userSocials[platform] != null) {
        socialIcons.add(buildSocialIcon(platform, 10.0));
      }
    }
    return Row(
      children: socialIcons,
    );
  }

  Widget buildSocialIcon(String platform, double rightPadding) {
    return InkWell(
      onTap: () {
        showSocialInfo(platform, AuthService.me.socials[platform]);
      },
      child: Padding(
        padding: EdgeInsets.only(right: rightPadding),
        child: CircleAvatar(
          radius: 14,
          backgroundColor: Colors.transparent,
          child: Image.asset(
            'assets/socials/$platform.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
