import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double? height;
  final double? width;
  final double border;
  final Color? color;
  final Gradient? gradient; // Menambahkan dukungan gradient
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    required this.border,
    this.color,
    this.gradient,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width,
      height: height ?? 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border),
        // Menggunakan Gradient jika tersedia, jika tidak menggunakan warna solid
        gradient: gradient ??
            (color == Colors.transparent
                ? null
                : LinearGradient(
                    colors: [
                      color ?? kPrimaryColor,
                      color?.withOpacity(0.8) ?? kPrimaryColor.withOpacity(0.8),
                    ],
                  )),
        boxShadow: [
          if (color != Colors.transparent)
            BoxShadow(
              color: (color ?? kPrimaryColor).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(border),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Center(
            child: Text(
              text,
              style: textStyle ??
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
