// To parse this JSON data, do
//
//     final customerNotAssign = customerNotAssignFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<CustomerNotAssignIsChecked> customerNotAssignIsCheckedFromJson(List lst) =>
    List<CustomerNotAssignIsChecked>.from(
        lst.map((x) => CustomerNotAssignIsChecked.fromJson(x)));

String customerNotAssignIsCheckedToJson(
        List<CustomerNotAssignIsChecked> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerNotAssignIsChecked {
  String customerId;
  RxBool isChecked;

  CustomerNotAssignIsChecked({
    required this.customerId,
    required this.isChecked,
  });

  factory CustomerNotAssignIsChecked.fromJson(Map<String, dynamic> json) =>
      CustomerNotAssignIsChecked(
        customerId: json["customer_id"],
        isChecked: json["is_checked"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "is_checked": isChecked,
      };
}
