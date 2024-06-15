import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

AwesomeDialog awesomeDialogQuestion(
    String title, String desc, Function() okPress) {
  return AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnCancelOnPress: () {
        Get.back();
      },
      btnOkOnPress: okPress);
}

AwesomeDialog awesomeDialogSuccess(String title, String desc) {
  return AwesomeDialog(
    context: Get.context!,
    dialogType: DialogType.success,
    animType: AnimType.rightSlide,
    title: title,
    desc: desc,
    btnOkOnPress: () {
      Get.back();
    },
  );
}
