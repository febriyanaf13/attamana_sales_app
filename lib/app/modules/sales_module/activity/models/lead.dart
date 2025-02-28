// To parse this JSON data, do
//
//     final lead = leadFromJson(jsonString);

import 'dart:convert';

List<Lead> leadFromJson(List lst) =>
    List<Lead>.from(lst.map((x) => Lead.fromJson(x)));

String leadToJson(List<Lead> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lead {
  int leadId;
  dynamic customerId;
  String kode;
  String namaHotel;
  String companyName;
  String addressPenagihan;
  dynamic addressCompany;
  String city;
  String state;
  String country;
  String phone1;
  dynamic phone2;
  dynamic fax;
  dynamic contactName;
  dynamic contactEmail;
  String contactPhone;
  String jobPosition;
  dynamic priority;
  String status;
  dynamic keterangan;
  String isLinked;
  dynamic followUp;
  dynamic notes;
  dynamic existingProduct;
  int jumlahKamarhotel;
  String jenisBarang;
  int estimasiPerbulan;
  String targetPrice;
  String paymentTerms;
  dynamic existingSupplier;
  int categoryHotel;
  dynamic leadStart;
  dynamic leadEnd;
  String lastActivity;

  Lead({
    required this.leadId,
    required this.customerId,
    required this.kode,
    required this.namaHotel,
    required this.companyName,
    required this.addressPenagihan,
    required this.addressCompany,
    required this.city,
    required this.state,
    required this.country,
    required this.phone1,
    required this.phone2,
    required this.fax,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.jobPosition,
    required this.priority,
    required this.status,
    required this.keterangan,
    required this.isLinked,
    required this.followUp,
    required this.notes,
    required this.existingProduct,
    required this.jumlahKamarhotel,
    required this.jenisBarang,
    required this.estimasiPerbulan,
    required this.targetPrice,
    required this.paymentTerms,
    required this.existingSupplier,
    required this.categoryHotel,
    required this.leadStart,
    required this.leadEnd,
    required this.lastActivity,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
        leadId: json["lead_id"],
        customerId: json["customer_id"],
        kode: json["kode"] ?? '-',
        namaHotel: json["nama_hotel"] ?? '-',
        companyName: json["company_name"] ?? '-',
        addressPenagihan: json["address_penagihan"] ?? '-',
        addressCompany: json["address_company"] ?? '-',
        city: json["city"] ?? '-',
        state: json["state"] ?? '-',
        country: json["country"] ?? '-',
        phone1: json["phone1"],
        phone2: json["phone2"],
        fax: json["fax"],
        contactName: json["contact_name"] ?? '-',
        contactEmail: json["contact_email"] ?? '-',
        contactPhone: json["contact_phone"] ?? '-',
        jobPosition: json["job_position"] ?? '-',
        priority: json["priority"] ?? '-',
        status: json["status"] ?? '-',
        keterangan: json["keterangan"] ?? '-',
        isLinked: json["is_linked"] ?? '-',
        followUp: json["follow_up"] ?? '-',
        notes: json["notes"] ?? '-',
        existingProduct: json["existing_product"] ?? '-',
        jumlahKamarhotel: json["jumlah_kamarhotel"] ?? 0,
        jenisBarang: json["jenis_barang"] ?? '-',
        estimasiPerbulan: json["estimasi_perbulan"] ?? '-',
        targetPrice: json["target_price"] ?? '-',
        paymentTerms: json["payment_terms"] ?? '-',
        existingSupplier: json["existing_supplier"] ?? '-',
        categoryHotel: json["category_hotel"] ?? '-',
        leadStart: json["lead_start"] ?? '-',
        leadEnd: json["lead_end"] ?? '-',
        lastActivity: json["last_activity"] ?? '-',
      );

  Map<String, dynamic> toJson() => {
        "lead_id": leadId,
        "customer_id": customerId,
        "kode": kode,
        "nama_hotel": namaHotel,
        "company_name": companyName,
        "address_penagihan": addressPenagihan,
        "address_company": addressCompany,
        "city": city,
        "state": state,
        "country": country,
        "phone1": phone1,
        "phone2": phone2,
        "fax": fax,
        "contact_name": contactName,
        "contact_email": contactEmail,
        "contact_phone": contactPhone,
        "job_position": jobPosition,
        "priority": priority,
        "status": status,
        "keterangan": keterangan,
        "is_linked": isLinked,
        "follow_up": followUp,
        "notes": notes,
        "existing_product": existingProduct,
        "jumlah_kamarhotel": jumlahKamarhotel,
        "jenis_barang": jenisBarang,
        "estimasi_perbulan": estimasiPerbulan,
        "target_price": targetPrice,
        "payment_terms": paymentTerms,
        "existing_supplier": existingSupplier,
        "category_hotel": categoryHotel,
        "lead_start": leadStart,
        "lead_end": leadEnd,
        "last_activity": lastActivity,
      };
}
