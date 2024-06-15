import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.hint,
    this.prefix,
    required this.isRequired,
    required this.controller,
    this.titleStyle,
    this.maxLine,
    this.maxLength,
    this.inputType,
    this.suffixText,
  });

  final String title, hint;
  final String? titleStyle;
  final String? suffixText;
  final Widget? prefix;
  final TextInputType? inputType;
  final bool isRequired;
  final int? maxLine, maxLength;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: isRequired ? '* ' : title,
                style: isRequired
                    ? const TextStyle(color: kErrorColor)
                    : const TextStyle(
                        color: kPrimaryTextColor, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: isRequired ? title : '(Optional)',
                      style: isRequired
                          ? const TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold)
                          : const TextStyle(
                              color: kSecondaryTextColor,
                              fontWeight: FontWeight.normal)),
                ],
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: Get.width,
          child: TextFormField(
            controller: controller,
            maxLines: maxLine ?? 1,
            keyboardType: inputType,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: kSecondaryTextColor),
                prefixIcon: prefix,
                suffixText: suffixText),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Form harus diisi!';
              } else {
                return null;
              }
            },
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ),
      ],
    );
  }
}
