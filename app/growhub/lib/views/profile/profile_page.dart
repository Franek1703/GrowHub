import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/common/widgets/progress_indicator.dart';
import 'package:growhub/config/constants/colors.dart';
import 'package:growhub/features/api/cubit/user/user_cubit.dart';
import 'package:growhub/features/api/data/models/user_model.dart';
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
    final name = useState<String>(user?.username ?? "");
    final email = useState<String>(user?.email ?? "");
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
                            text: email.value,
                            onTitleChange: (p0) => email.value = p0,
                          ),
                          const SizedBox(height: 40),
                          GHInputField(
                            hintText: "Name",
                            title: "Name",
                            text: name.value,
                            onTitleChange: (p0) => name.value = p0,
                          ),
                          const SizedBox(height: 60),
                          Builder(builder: (context) {
                            if (user!.email != email.value ||
                                user.username != name.value) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: GHColors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.save,
                                      size: 30,
                                      color: GHColors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: GHColors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.cancel,
                                      size: 30,
                                      color: GHColors.white,
                                    ),
                                  )
                                ],
                              );
                            }
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.exit_to_app,
                                size: 30,
                                color: GHColors.white,
                              ),
                            );
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
}
