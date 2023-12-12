import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:src/pages/unregister/registerpage.dart';
import 'package:src/services/auth/authservice.dart';
import 'package:src/widgets/components/emailTextfield.dart';
import 'package:src/widgets/components/passwordTextfield.dart';
import 'package:src/widgets/utils/noglowscroll.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool buttonEnabled = false;
  bool buttonLoading = false;

  Future<void> onLoginButtonClick() async {
    if (buttonEnabled == false || buttonLoading) return;
    setState(() {
      buttonLoading = true;
    });
    try {
      String email = emailController.text.trim();
      print("email: $email");
      print("psw: ${passwordController.text}");
      await AuthService.auth.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      print('Giriş başarılı');
      setState(() {
        buttonLoading = false;
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        print("hata: ${e.code}");
        if (e.code == 'user-not-found') {
          emailErrorMessage = "Bu epostaya sahip kullanıcı bulunamadı.";
          emailErrorState = true;
        } else if (e.code == 'wrong-password' ||
            e.code == "invalid-credential") {
          passwordErrorMessage = "Şifre hatalı!";
          passwordErrorState = true;
        } else if (e.code == "too-many-requests") {
          emailErrorMessage = "Çok fazla denedin. biraz bekleyip tekrar dene.";
          emailErrorState = true;
        } else if (e.code == "network-request-failed") {
          emailErrorMessage = "İnternet bağlantısı yok.";
          emailErrorState = true;
        } else {
          emailErrorMessage = "Geçersiz bir eposta adresi.";
          emailErrorState = true;
        }
        setState(() {
          buttonLoading = false;
        });
      }
    }
  }

  // region for Email Input Controls  //
  TextEditingController emailController = TextEditingController();
  bool emailErrorState = false;
  String emailErrorMessage = "";

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
            emailController.text.contains("@") &&
            passwordController.text.length > 3) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        emailErrorState = false;
      });
    }
  }
  //endregion

  bool passwordErrorState = false;
  String passwordErrorMessage = "";
  bool isPasswordFieldVisible = false;
  TextEditingController passwordController = TextEditingController();

  void passwordErrorCatcher(String text) {
    List<String> words = text.split(' ');
    String password = words.where((word) => word.isNotEmpty).join(' ');
    text = password;
    if (passwordController.text == "") {
      setState(() {
        buttonEnabled = false;
        passwordErrorState = true;
        passwordErrorMessage = "Şifre boş olamaz.";
      });
    } else {
      setState(() {
        if (emailController.text.isNotEmpty &&
            (emailController.text.contains(".com") ||
                emailController.text.contains(".edu") ||
                emailController.text.contains(".gov")) &&
            emailController.text.contains("@") &&
            passwordController.text.length > 3) {
          buttonEnabled = true;
        } else {
          buttonEnabled = false;
        }
        passwordErrorState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior().copyWith(overscroll: false),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const SizedBox(height: 30.0),
                        createEmailTextfield(
                            controller: emailController,
                            hintText: "Eposta..",
                            changed: emailErrorCatcher,
                            errorState: emailErrorState,
                            errorText: emailErrorMessage),
                        const SizedBox(height: 10.0),
                        createPasswordTextField(
                            controller: passwordController,
                            hintText: "Şifre..",
                            changed: passwordErrorCatcher,
                            errorState: passwordErrorState,
                            errorText: passwordErrorMessage,
                            visibility: passwordObs(),
                            obscureState: isPasswordFieldVisible),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: buttonEnabled
                                    ? Colors.purple
                                    : const Color.fromARGB(154, 73, 47, 85),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed:
                                  buttonLoading ? null : onLoginButtonClick,
                              child: buttonLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Color.fromARGB(255, 159, 159, 159)),
                                      ),
                                    )
                                  : Text(
                                      "Giriş Yap",
                                      style: TextStyle(
                                          color: buttonEnabled
                                              ? Colors.white
                                              : Colors.grey),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Hesap detaylarını mı unuttun?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  "Giriş için yardım al.",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Henüz hesap oluşturmadın mı?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterPage()));
                                },
                                child: const Text(
                                  "Hesap Oluştur!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Kullanım Koşulları & Gizlilik Politikası",
                        style: TextStyle(color: Colors.grey, fontSize: 8),
                      ),
                    ),
                    const Divider(
                      color: Colors.black26,
                    ),
                    const Text(
                      "version: Erken Erişim (Early Access)",
                      style: TextStyle(color: Colors.grey, fontSize: 8),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector passwordObs() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPasswordFieldVisible = !isPasswordFieldVisible;
        });
      },
      child: Icon(
        isPasswordFieldVisible ? Icons.visibility : Icons.visibility_off,
        color: const Color.fromARGB(255, 32, 32, 32),
      ),
    );
  }
}
