// To parse this JSON data, do
//
//     final customerAssign = customerAssignFromJson(jsonString);

import 'dart:convert';

List<CustomerAssign> customerAssignFromJson(List list) =>
    List<CustomerAssign>.from(list.map((x) => CustomerAssign.fromJson(x)));

String customerAssignToJson(List<CustomerAssign> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerAssign {
  int customerId;
  String corporate;
  String nama;
  String address;
  String sales;

  CustomerAssign({
    required this.customerId,
    required this.corporate,
    required this.nama,
    required this.address,
    required this.sales,
  });

  factory CustomerAssign.fromJson(Map<String, dynamic> json) => CustomerAssign(
        customerId: json["customer_id"],
        corporate: json["corporate"],
        nama: json["nama"],
        address: json["address"],
        sales: json["sales"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "corporate": corporate,
        "nama": nama,
        "address": address,
        "sales": sales,
      };
}
