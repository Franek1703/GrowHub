import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/common/widgets/progress_indicator_small.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
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
    final isSamePasswordErrorVisible = useState(false);

    final userState = context.watch<UserCubit>().state;

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
                child: BlocListener<UserCubit, UserState>(
                  listener: (context, state) {
                    // if (state is UserStateSignedUp) {
                    //   context.go('/login');
                    // }
                    // print(state);
                    // if (state is UserStateLoading) {
                    //   print("Loading");
                    // } else {
                    //   if (Navigator.of(context).canPop()) {
                    //     // Navigator.of(context).pop();
                    //   }
                    //   if (state is UserStateLoaded) {
                    //     //context.push('/dashboard');
                    //   } else if (state is UserStateError) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text(state.error)),
                    //     );
                    //   }
                    // }
                  },
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
                          if (isErrorVisible.value)
                            _errorText(
                              isErrorVisible.value,
                              "All inputs must be provided!",
                            ),
                          if (isSamePasswordErrorVisible.value)
                            _errorText(
                              isSamePasswordErrorVisible.value,
                              "Passwords are not the same!",
                            ),
                          if (userState is UserStateLoading)
                            const GHProgressIndicatorSmall(),
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

                                  if (email.value == "" ||
                                      password.value == "") {
                                    isErrorVisible.value = true;
                                    return;
                                  }

                                  if (password.value != repeatPassword.value) {
                                    isSamePasswordErrorVisible.value = true;
                                    return;
                                  }

                                  final userCubit = context.read<UserCubit>();
                                  userCubit.signUp(
                                      name.value, email.value, password.value);
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
                                  isSamePasswordErrorVisible.value = false;
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _errorText(bool isVisible, String text) {
    return SizedBox(
      height: 32,
      child: Visibility(
        visible: isVisible,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.red, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
