// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/dialogs/loading.dart';
import 'package:src/services/apis/users.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/inputs/aboutTextfield.dart';
import 'package:src/widgets/components/inputs/usernameTextfield.dart';
import 'package:src/widgets/utils/noglowscroll.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key, required this.step});
  final int step;

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  // STEP 1   USERNAME start//
  final TextEditingController usernameController = TextEditingController();
  bool usernameErrorState = false;
  String usernameErrorMessage = "";
  void usernameErrorCatcher(String text) {
    List<String> words = text.split(' ');
    String username = words.where((word) => word.isNotEmpty).join(' ');
    text = removeConsecutiveUnderscores(username);
    usernameController.text = text.toLowerCase();
    if (usernameController.text == "") {
      setState(() {
        buttonEnabled = false;
        usernameErrorState = true;
        usernameErrorMessage = "Kullanıcı adı boş olamaz.";
      });
    } else {
      setState(() {
        if (usernameController.text.length > 3) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        usernameErrorState = false;
      });
    }
  }

  String removeConsecutiveUnderscores(String input) {
    RegExp regex = RegExp(r'_+');
    return input.replaceAll(regex, '_');
  }

  bool isLetter(String character) {
    return RegExp(r'[a-zA-Z]').hasMatch(character);
  }

  bool containsAtLeastTwoLetters(String input) {
    int letterCount = 0;

    for (int i = 0; i < input.length; i++) {
      if (isLetter(input[i])) {
        letterCount++;

        if (letterCount > 2) {
          return true;
        }
      }
    }
    return false;
  }

  bool buttonEnabled = false;
  bool buttonLoading = false;

  void changeUsername() {
    String? userName = usernameController.text.trim();
    if (containsAtLeastTwoLetters(userName)) {
      Future<bool> state = APIs.existsControl("username", userName);
      state.then((value) async {
        if (value) {
          loadingDilaog().show(context);
          await APIs.updateUserInfo("username", userName);
          AuthService.me.username = userName;
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          setState(() {
            buttonEnabled = false;
            usernameErrorState = true;
            buttonLoading = false;
            usernameErrorMessage = "Bu kullanıcı adı zaten kullanılmaktadır.";
          });
        }
      });
    } else {
      setState(() {
        buttonEnabled = false;
        usernameErrorState = true;
        buttonLoading = false;
        usernameErrorMessage = "Kullanıcı adı minimum 3 harf içermeli.";
      });
    }
  }

  // STEP 1   USERNAME end//

  // STEP 2   ABOUT start//
  final TextEditingController aboutController =
      TextEditingController(text: AuthService.me.about);
  bool aboutErrorState = false;
  String aboutErrorMessage = "";
  void aboutErrorCatcher(String text) {
    if (aboutController.text.length < 5 ||
        !containsAtLeastTwoLetters(aboutController.text)) {
      setState(() {
        buttonEnabled = false;
        aboutErrorState = true;
        aboutErrorMessage = "Hakkında kısmı minimum 5 karakter olmalıdır.";
      });
    } else {
      setState(() {
        if (aboutController.text.length >= 5) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        aboutErrorState = false;
      });
    }
  }

  void changeAbout() async {
    if (!buttonEnabled) return;
    loadingDilaog().show(context);
    AuthService.me.about = aboutController.text.toString();
    await APIs.updateUserInfo("about", aboutController.text.toString());
    Navigator.pop(context);
    Navigator.pop(context);
  }

  // STEP 2   ABOUT end//

  void onButtonClick() {
    if (widget.step == 1) {
      changeUsername();
    } else if (widget.step == 2) {
      changeAbout();
    }
  }

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
                    Text(
                      (widget.step == 1)
                          ? "Kullanıcı Adını Güncelle"
                          : (widget.step == 2)
                              ? "Hakkında Kısmını Güncelle"
                              : (widget.step == 3)
                                  ? "Epostanı Güncelle"
                                  : "Doğrulama Kodunu Gir",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      (widget.step == 1)
                          ? "İstediğin zaman kullanıcı adını tekrar değiştirebilirsin."
                          : "İnsanlara kendinden bahset, tabii abartmadan, lütfen.",
                      style: const TextStyle(color: Colors.white70),
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
                      height: 10,
                    ),

                    // next button
                    createButton(),

                    // sizedbox
                    const SizedBox(
                      height: 15,
                    ),

                    if (widget.step != 3)
                      // divider
                      const Divider(
                        color: Colors.grey,
                      ),

                    if (widget.step != 3)
                      // sizedbox
                      const SizedBox(
                        height: 15,
                      ),

                    if (widget.step != 3)
                      createBottomLabel(
                          "karar veremiyor musun?", "Muppin'in Önerisi!", () {
                        awesomeDialog().show(
                            context,
                            "Bu özellik yapım aşamasında!",
                            "Muppin, henüz erken erişim sürecinde olduğu için, bu tarz özellikler henüz aktif değildir.",
                            "",
                            "Tamam",
                            DialogType.info,
                            null,
                            () {});
                      }),

                    // sizedbox
                    const SizedBox(
                      height: 50,
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

  Widget createBottomLabel(
      String firstString, String otherString, Function()? click) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstString,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: click,
          child: Text(
            otherString,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget createButton() {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: (buttonEnabled == false)
                ? const Color.fromARGB(154, 73, 47, 85)
                : const Color.fromARGB(154, 195, 90, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: buttonLoading ? null : onButtonClick,
          child: buttonLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 159, 159, 159)),
                  ),
                )
              : Text(
                  "Kaydet",
                  style: TextStyle(
                      color: (buttonEnabled == false)
                          ? Colors.grey
                          : Colors.white),
                ),
        ),
      ),
    );
  }

  Widget getInput() {
    if (widget.step == 1) {
      return createUsernameTextfield(
        controller: usernameController,
        hintText: "Kullanıcı Adı",
        errorState: usernameErrorState,
        errorText: usernameErrorMessage,
        changed: usernameErrorCatcher,
      );
    } else if (widget.step == 2) {
      return createAboutTextfield(
          controller: aboutController,
          hintText: "Hakkında",
          changed: aboutErrorCatcher,
          errorState: aboutErrorState,
          errorText: aboutErrorMessage);
    } else if (widget.step == 3) {
      return const Row();
    } else {
      return const Row();
    }
  }
}
