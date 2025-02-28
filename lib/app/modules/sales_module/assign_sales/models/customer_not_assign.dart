// To parse this JSON data, do
//
//     final customerNotAssign = customerNotAssignFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<CustomerNotAssign> customerNotAssignFromJson(List lst) =>
    List<CustomerNotAssign>.from(lst.map((x) => CustomerNotAssign.fromJson(x)));

String customerNotAssignToJson(List<CustomerNotAssign> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerNotAssign {
  int customerId;
  String corporate;
  String nama;
  String address;

  CustomerNotAssign({
    required this.customerId,
    required this.corporate,
    required this.nama,
    required this.address,
  });

  factory CustomerNotAssign.fromJson(Map<String, dynamic> json) =>
      CustomerNotAssign(
        customerId: json["customer_id"],
        corporate: json["corporate"],
        nama: json["nama"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "corporate": corporate,
        "nama": nama,
        "address": address,
      };
}
