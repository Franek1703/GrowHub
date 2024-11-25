import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/login/widgets/background_img.dart';
import 'package:growhub/features/login/widgets/input_filed.dart';

class SignupPage extends HookWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = useState<String>("");
    final email = useState<String>("");
    final password = useState<String>("");
    final repeatPassword = useState<String>("");
    final isErrorVisible = useState(false);

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ważne, aby działało z klawiaturą
      body: BackgroundImage(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Dopasowanie do ekranu
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 100,
                      bottom: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        GHInputField(
                          hintText: "Your name",
                          title: "Your name",
                          text: name.value != "" ? name.value : null,
                          onTitleChange: (p0) => name.value = p0,
                        ),
                        const SizedBox(height: 16),
                        GHInputField(
                          hintText: "Email",
                          title: "Email",
                          text: email.value != "" ? email.value : null,
                          onTitleChange: (p0) => email.value = p0,
                        ),
                        const SizedBox(height: 16),
                        GHInputField(
                          hintText: "Password",
                          title: "Password",
                          isPassword: true,
                          text: password.value != "" ? password.value : null,
                          onTitleChange: (p0) => password.value = p0,
                        ),
                        const SizedBox(height: 16),
                        GHInputField(
                          hintText: "Repeat password",
                          title: "Repeat password",
                          isPassword: true,
                          text: repeatPassword.value != ""
                              ? repeatPassword.value
                              : null,
                          onTitleChange: (p0) => repeatPassword.value = p0,
                        ),
                        SizedBox(
                          height: 32,
                          child: Visibility(
                            visible: isErrorVisible.value,
                            child: const Center(
                              child: Text(
                                "All inputs must be provided!",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                if (name.value == "" ||
                                    email.value == "" ||
                                    password.value == "" ||
                                    repeatPassword.value == "") {
                                  isErrorVisible.value = true;
                                }
                                // TODO: Implement signup logic here
                              },
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: GHColors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: GHColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                isErrorVisible.value = false;
                                context.pop();
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                    color: GHColors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Log in",
                                      style: TextStyle(
                                        color: GHColors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
