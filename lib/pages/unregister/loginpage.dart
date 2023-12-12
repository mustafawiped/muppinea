import 'package:flutter/material.dart';
import 'package:src/pages/unregister/registerpage.dart';
import 'package:src/widgets/utils/noglowscroll.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordFieldVisible = true;

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
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: const TextField(
                            maxLength: 40,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: [AutofillHints.email],
                            decoration: InputDecoration(
                              hintText: 'Eposta',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 123, 123, 123)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 32, 32, 32),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 20.0,
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: isPasswordFieldVisible
                                    ? Colors.white
                                    : const Color.fromARGB(255, 255, 255, 255),
                                hintText: 'Şifre',
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 123, 123, 123)),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    isPasswordFieldVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color:
                                        const Color.fromARGB(255, 32, 32, 32),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 64, 64, 64)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 64, 64, 64)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 64, 64, 64)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 64, 64, 64)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 64, 64, 64)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                errorText:
                                    null // isErrorState ? isErrorText : null,
                                ),
                            obscureText: !isPasswordFieldVisible,
                          ),
                        ),
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
                                backgroundColor:
                                    const Color.fromARGB(154, 73, 47, 85),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed:
                                  () {}, //isLoading ? null : transactions,
                              child: /* isLoading
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
                                  :*/
                                  const Text("Giriş Yap"),
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
}
