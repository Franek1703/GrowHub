import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/progress_indicator.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
import 'package:growhub/features/api/data/models/user_model.dart';
import 'package:growhub/features/bottom_app_bar/cubit/path_cubit.dart';
import 'package:growhub/features/login/widgets/input_filed.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;
    UserModel? user;
    switch (userState) {
      case UserStateLoaded _:
        user = userState.user;
        break;
      case UserStateSignedUp _:
        user = userState.user;
        break;
      default:
        user = null;
        break;
    }
    final nameController = useTextEditingController(text: user?.username ?? "");
    final emailController = useTextEditingController(text: user?.email ?? "");
    final name = useState(nameController.text);
    final email = useState(emailController.text);

    nameController.addListener(() => name.value = nameController.text);
    emailController.addListener(() => email.value = emailController.text);
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Builder(
              builder: (context) {
                if (user != null) {
                  return IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 100,
                        bottom: 25,
                      ),
                      child: Column(
                        children: [
                          GHInputField(
                            hintText: "E-mail",
                            title: "E-mail",
                            // text: email.text,
                            onTitleChange: (p0) {},
                            controller: emailController,
                          ),
                          const SizedBox(height: 40),
                          GHInputField(
                            hintText: "Name",
                            title: "Name",
                            // text: name.text,
                            controller: nameController,
                            onTitleChange: (p0) {},
                          ),
                          const SizedBox(height: 60),
                          Builder(builder: (context) {
                            if (user!.email != email.value ||
                                user.username != name.value) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  iconButton(Icons.save, "Save changes",
                                      GHColors.black, () async {
                                    final newUser = UserModel(
                                        username: nameController.text,
                                        email: emailController.text);
                                    await context
                                        .read<UserCubit>()
                                        .editUser(newUser);
                                    context
                                        .read<PathCubit>()
                                        .onPathChange("/dashboard");
                                  }),
                                  const SizedBox(width: 15),
                                  iconButton(Icons.cancel, "Discard changes",
                                      GHColors.black, () {
                                    nameController.text = user!.username;
                                    emailController.text = user.email;
                                  }),
                                ],
                              );
                            }
                            return iconButton(
                                Icons.exit_to_app, "Sing out", Colors.red,
                                () async {
                              await context.read<UserCubit>().singOut();
                              context
                                  .read<PathCubit>()
                                  .onPathChange("/dashboard");
                            });
                          })
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: GHProgressIndicator(),
                  );
                }
              },
            )),
      );
    });
  }

  Widget iconButton(
      IconData icon, String label, Color color, Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: GHColors.white,
              ),
            ),
            Text(label)
          ],
        ));
  }
}
