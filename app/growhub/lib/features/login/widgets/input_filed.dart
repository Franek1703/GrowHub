import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:growhub/config/assets.gen.dart';
import 'package:growhub/config/constants/colors.dart';

class GHInputField extends HookWidget {
  const GHInputField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    required this.title,
    required this.onTitleChange,
    this.text,
    this.controller
  });

  final Function(String) onTitleChange;
  final String hintText;
  final bool isPassword;
  final String title;
  final String? text;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final isObscure = useState(!isPassword);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(
          height: 4,
        ),
        Stack(
          children: [
            TextFormField(
              controller: controller,
              initialValue: text,
              obscureText: !isObscure.value,
              onChanged: (value) => onTitleChange(value),
              onTapOutside: (event) {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: GHColors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: GHColors.black, width: 3),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                hintText: hintText,
                suffixIcon: isPassword
                    ? IconButton(
                        onPressed: () => isObscure.value = !isObscure.value,
                        icon: isObscure.value
                            ? Assets.iconsUi.eyeOpen.svg(
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  GHColors.black,
                                  BlendMode.srcIn,
                                ),
                              )
                            : Assets.iconsUi.eyeClose.svg(
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  GHColors.black,
                                  BlendMode.srcIn,
                                ),
                              ))
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
