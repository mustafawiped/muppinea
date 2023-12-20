// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:src/pages/profile/connects.dart';
import 'package:src/widgets/components/itemtile.dart';
import 'package:src/widgets/utils/noglowscroll.dart';

class ProfileConnectionsInfo extends StatefulWidget {
  const ProfileConnectionsInfo({super.key, required this.step});
  final int step;

  @override
  State<ProfileConnectionsInfo> createState() => _ProfileConnectionsInfoState();
}

class _ProfileConnectionsInfoState extends State<ProfileConnectionsInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login Top Banner
                    const Text(
                      "Bağlantılarınızı Yönetin",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    //sizedbox
                    const SizedBox(height: 10),

                    //desc
                    const Text(
                      "Diğer sosyal medya platformlarında olan hesaplarınızı ekleyin ve profilinizde gözüksün.",
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),

                    // sizedbox
                    const SizedBox(
                      height: 25,
                    ),

                    // input
                    getInput(),

                    // sizedbox
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getInput() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20),
      ItemTile(
        socialname: "instagram",
        title: "Instagram",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ProfileOtherEdits(
                        social: "instagram",
                        step: 1,
                      )));
        },
      ),
      const SizedBox(height: 20),
      ItemTile(
        socialname: "twitter",
        title: "X",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ProfileOtherEdits(
                        social: "twitter",
                        step: 1,
                      )));
        },
      ),
      const SizedBox(height: 20),
      ItemTile(
        socialname: "youtube",
        title: "Youtube",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ProfileOtherEdits(
                        social: "youtube",
                        step: 1,
                      )));
        },
      ),
      const SizedBox(height: 20),
      ItemTile(
        socialname: "discord",
        title: "Discord",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ProfileOtherEdits(
                        social: "discord",
                        step: 1,
                      )));
        },
      ),
    ]);
  }
}
