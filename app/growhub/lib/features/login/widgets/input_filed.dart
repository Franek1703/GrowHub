import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';

class GHInputField extends HookWidget {
  final Function(String) onTitleChange;
  final String hintText;
  final bool isPassword;
  final String title;
  final String? text;
  const GHInputField(
      {super.key,
      required this.hintText,
      this.isPassword = false,
      required this.title,
      required this.onTitleChange,
      this.text
      });

  @override
  Widget build(BuildContext context) {
    final isTextVisible = useState(!isPassword);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GHColors.black, width: 2)),
          child: Stack(
            children: [
              TextFormField(
                initialValue: text,
                obscureText: !isTextVisible.value,
                onChanged: (value) => onTitleChange(value),
                onTapOutside: (event) {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  hintText: hintText,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: isPassword
                    ? IconButton(
                        onPressed: () =>
                            isTextVisible.value = !isTextVisible.value,
                        icon: isTextVisible.value
                        //TODO: Change this icons
                            ? Assets.iconsUi.bell.svg(
                                colorFilter: ColorFilter.mode(
                                  GHColors.black,
                                  BlendMode.srcIn,
                                ),
                              )
                            : Assets.iconsUi.user.svg(
                                colorFilter: ColorFilter.mode(
                                  GHColors.black,
                                  BlendMode.srcIn,
                                ),
                              ))
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
