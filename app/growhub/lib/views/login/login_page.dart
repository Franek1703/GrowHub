import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/login/widgets/background_img.dart';
import 'package:growhub/features/login/widgets/input_filed.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = useState<String>("");
    final password = useState<String>("");
    final isErrorVisible = useState(false);
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
                  "Log in",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                GHInputField(
                  text: email.value != "" ? email.value : null,
                  hintText: "Email",
                  title: "Email",
                  onTitleChange: (p0) => email.value = p0,
                ),
                const SizedBox(height: 30),
                GHInputField(
                    text: password.value != "" ? password.value : null,
                    onTitleChange: (p0) => password.value = p0,
                    hintText: "Password",
                    title: "Password",
                    isPassword: true),
                SizedBox(
                  height: 32,
                  child: Visibility(
                      visible: isErrorVisible.value,
                      child: const Center(
                        child: Text(
                          "All inputs must be provided!",
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      )),
                ),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if(email.value == "" || password.value == ""){
                        isErrorVisible.value = true;
                      }
                      else{
                        // TODO: Implement login logic here
                      }
                      
                    },
                    child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: GHColors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          "Log in",
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
                      isErrorVisible.value = false;
                      context.push("/signup");
                      
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: GHColors.black, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Sign up",
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
