import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/borders.dart';
import '../style/colors.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({
    super.key,
    required this.title,
    required this.isRequired,
    required this.boolImage,
    this.image,
    required this.onTap,
    this.validator,
  });

  final Function() onTap;
  final RxBool boolImage;
  final RxBool? validator;
  final bool isRequired;
  final File? image;
  final String title;

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: widget.onTap,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: widget.isRequired ? '* ' : widget.title,
                      style: widget.isRequired
                          ? const TextStyle(color: kErrorColor)
                          : const TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                widget.isRequired ? widget.title : '(Optional)',
                            style: widget.isRequired
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
                height: 200,
                width: Get.width,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: kInputBorderColor)),
                    child: widget.boolImage.isFalse
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_a_photo_outlined,
                                size: 50,
                                color: kPrimaryColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Ambil Foto Bukti',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: kSecondaryTextColor),
                              )
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(kDefaultBorder),
                            child: Image.file(
                              widget.image!,
                              fit: BoxFit.fitWidth,
                            ),
                          )),
              ),
              widget.boolImage.isFalse
                  ? const SizedBox()
                  : const Text('Tap untuk mengambil ulang bukti..!'),
              widget.validator != null
                  ? widget.validator!.isFalse
                      ? const SizedBox()
                      : const Text(
                          'Foto bukti harus disertakan..!',
                          style: TextStyle(color: Colors.red),
                        )
                  : const SizedBox()
            ],
          ),
        ));
  }
}
