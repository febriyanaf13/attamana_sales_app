// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

List<Customer> customerFromJson(List lst) =>
    List<Customer>.from(lst.map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  int customerId;
  String corporate;
  String companyName;
  String nama;
  String address;
  String city;
  String country;
  String phone1;

  Customer({
    required this.customerId,
    required this.corporate,
    required this.companyName,
    required this.nama,
    required this.address,
    required this.city,
    required this.country,
    required this.phone1,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json["customer_id"] ?? 0,
        corporate: json["corporate"] ?? '-',
        companyName: json["company_name"] ?? '-',
        nama: json["nama"] ?? '-',
        address: json["address"] ?? "-",
        city: json["city"] ?? '-',
        country: json["country"] ?? '-',
        phone1: json["phone1"] == null || json["phone1"] == ''
            ? '-'
            : json["phone1"],
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "corporate": corporate,
        "company_name": companyName,
        "nama": nama,
        "address": address,
        "city": city,
        "country": country,
        "phone1": phone1,
      };
}
