// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:src/dialogs/awesome.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/inputs/emailTextfield.dart';
import 'package:src/widgets/utils/noglowscroll.dart';

class SaveAccountPage extends StatefulWidget {
  const SaveAccountPage({super.key});

  @override
  State<SaveAccountPage> createState() => _SaveAccountPageState();
}

class _SaveAccountPageState extends State<SaveAccountPage> {
  bool buttonLoading = false;
  bool buttonEnabled = false;

  final TextEditingController emailController = TextEditingController();
  bool emailErrorState = false;
  String emailErrorMessage = "";

  int step = 1;

  String removeConsecutiveUnderscores(String input) {
    RegExp regex = RegExp(r'_+');
    return input.replaceAll(regex, '_');
  }

  void emailErrorCatcher(String text) {
    List<String> words = text.split(' ');
    String email = words.where((word) => word.isNotEmpty).join(' ');
    text = removeConsecutiveUnderscores(email);
    emailController.text = text.toLowerCase();
    if (emailController.text == "") {
      setState(() {
        buttonEnabled = false;
        emailErrorState = true;
        emailErrorMessage = "Eposta boş olamaz.";
      });
    } else {
      setState(() {
        if (emailController.text.isNotEmpty &&
            (emailController.text.contains(".com") ||
                emailController.text.contains(".edu") ||
                emailController.text.contains(".gov")) &&
            emailController.text.contains("@")) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        emailErrorState = false;
      });
    }
  }

  void emailNext() async {
    String? email = emailController.text.trim();
    if (!emailErrorState) {
      setState(() {
        buttonLoading = true;
      });
      try {
        await AuthService.auth.sendPasswordResetEmail(email: email);
        setState(() {
          buttonLoading = false;
          step++;
        });
      } catch (e) {
        setState(() {
          buttonLoading = false;
        });
        awesomeDialog().show(
            context,
            "Hata!",
            "Kurtarma epostası gönderilemedi. İnternet bağlantını kontrol et ya da epostanı kontrol et.",
            "Tamam",
            "",
            DialogType.error,
            () {},
            null);
        print("Hata! $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
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
                      step == 1
                          ? "Eposta Adresi Girin"
                          : "Epostanı kontrol et!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      step == 1
                          ? "Kayıtlı hesabınızın eposta adresini girin."
                          : "Eğer girdiğiniz eposta adresi bir hesaba kayıtlıysa, eposta adresinize şifre sıfırlama linki gönderildi.",
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),

                    // sizedbox
                    const SizedBox(
                      height: 25,
                    ),

                    // input
                    if (step == 1)
                      createEmailTextfield(
                          controller: emailController,
                          hintText: "Eposta",
                          changed: emailErrorCatcher,
                          errorState: emailErrorState,
                          errorText: emailErrorMessage),

                    // sizedbox
                    if (step == 1)
                      const SizedBox(
                        height: 10,
                      ),

                    // next button
                    if (step == 1) createButton(),

                    // sizedbox
                    const SizedBox(
                      height: 15,
                    ),

                    // divider
                    const Divider(
                      color: Colors.grey,
                    ),

                    // sizedbox
                    const SizedBox(
                      height: 15,
                    ),

                    createBottomLabel(
                        "Giriş ekranına dönmek için", "buraya tıkla.", () {
                      Navigator.of(context).pop();
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
          onPressed: buttonLoading ? null : emailNext,
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
                  "Kurtar",
                  style: TextStyle(
                      color: (buttonEnabled == false)
                          ? Colors.grey
                          : Colors.white),
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
}
