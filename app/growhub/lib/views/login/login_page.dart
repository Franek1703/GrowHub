import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:growhub/common/widgets/page_padding.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
import 'package:growhub/features/login/widgets/background_img.dart';
import 'package:growhub/features/login/widgets/input_filed.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = useState<String>("");
    final password = useState<String>("");
    final isErrorVisible = useState(false);

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Kluczowe dla poprawnego działania z klawiaturą
      body: BackgroundImage(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight, // Wypełnij całą wysokość ekranu
                ),
                child: BlocListener<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state is UserStateLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is UserStateLoaded) {
                      context.push('/dashboard');
                    } else if (state is UserStateError) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: IntrinsicHeight(
                    child: GHPagePadding(
                      top: 100,
                      bottom: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Log in",
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold),
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
                            isPassword: true,
                          ),
                          SizedBox(
                            height: 32,
                            child: Visibility(
                              visible: isErrorVisible.value,
                              child: const Center(
                                child: Text(
                                  "All inputs must be provided!",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () async {
                                  if (email.value == "" ||
                                      password.value == "") {
                                    isErrorVisible.value = true;
                                    return;
                                  }
                                  final userCubit = context.read<UserCubit>();
                                  userCubit.login(email.value, password.value);
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
                                      "Log in",
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
                                  context.push("/signup");
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                        color: GHColors.black, fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: "Sign up",
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
}
