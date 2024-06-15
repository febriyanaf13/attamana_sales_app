import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextFieldTitle extends StatelessWidget {
  const CustomTextFieldTitle({
    super.key,
    required this.title,
    required this.hint,
    this.maxLine,
    required this.controller,
    this.titleStyle,
    this.maxLength,
    required this.withTitle,
  });

  final String title, hint;
  final String? titleStyle;
  final bool withTitle;
  final int? maxLine, maxLength;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        withTitle == true
            ? Text(
          title,
          style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: titleStyle == 'bold'
                  ? FontWeight.bold
                  : FontWeight.normal),
        )
            : const SizedBox(),
        const SizedBox(height: 5),
        SizedBox(
          width: Get.width,
          child: TextFormField(
            controller: controller,
            maxLines: maxLine ?? 1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              label: Text(title, style: Get.textTheme.bodyMedium,),
              hintText: hint,
              hintStyle: Get.textTheme.bodySmall,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Form harus diisi!';
              } else {
                return null;
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}
