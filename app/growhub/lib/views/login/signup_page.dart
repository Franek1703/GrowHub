import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/login/widgets/background_img.dart';
import 'package:growhub/features/login/widgets/input_filed.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundImage(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 24, right: 24, top: 100, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                const GHInputField(hintText: "Your name", title: "Your name",),
              const SizedBox(height: 16),
              const GHInputField(hintText: "Email", title: "Email",),
              const SizedBox(height: 16),
              const GHInputField(hintText: "Password", title: "Password", isPassword: true),
              const SizedBox(height: 16),
              const GHInputField(hintText: "Repeat password", title: "Repeat password", isPassword: true),
              const SizedBox(height: 32),
                const SizedBox(height: 32),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      // TODO: Implement login logic here
                    },
                    child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: GHColors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: GHColors.white),
                        ))),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.go("/login");
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: GHColors.black, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                                color: GHColors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}