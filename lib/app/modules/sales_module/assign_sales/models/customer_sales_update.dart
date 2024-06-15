// To parse this JSON data, do
//
//     final CustomerSalesUpdate = CustomerSalesUpdateFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<CustomerSalesUpdate> CustomerSalesUpdateFromJson(List lst) =>
    List<CustomerSalesUpdate>.from(
        lst.map((x) => CustomerSalesUpdate.fromJson(x)));

String CustomerSalesUpdateToJson(List<CustomerSalesUpdate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerSalesUpdate {
  int pegawaiId;
  RxBool isSet;

  CustomerSalesUpdate({
    required this.pegawaiId,
    required this.isSet,
  });

  factory CustomerSalesUpdate.fromJson(Map<String, dynamic> json) =>
      CustomerSalesUpdate(
        pegawaiId: json["pegawai_id"],
        isSet: json["iseset"],
      );

  Map<String, dynamic> toJson() => {
        "pegawai_id": pegawaiId,
        "iseset": isSet,
      };
}
