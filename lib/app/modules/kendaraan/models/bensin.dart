// To parse this JSON data, do
//
//     final bensin = bensinFromJson(jsonString);

import 'dart:convert';

List<Bensin> bensinFromJson(List list) =>
    List<Bensin>.from(list.map((x) => Bensin.fromJson(x)));

String bensinToJson(List<Bensin> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bensin {
  int id;
  dynamic fixedAssetId;
  dynamic namaFixedAsset;
  dynamic fillUpDate;
  dynamic odometer;
  dynamic liter;
  dynamic hargaPerLiter;
  dynamic total;
  dynamic bukti;
  dynamic notes;

  Bensin({
    required this.id,
    required this.fixedAssetId,
    required this.namaFixedAsset,
    required this.fillUpDate,
    required this.odometer,
    required this.liter,
    required this.hargaPerLiter,
    required this.total,
    required this.bukti,
    required this.notes,
  });

  factory Bensin.fromJson(Map<String, dynamic> json) => Bensin(
        id: json["id"],
        fixedAssetId: json["fixed_asset_id"],
        namaFixedAsset: json["nama_fixed_asset"],
        fillUpDate: json["fill_up_date"] != null
            ? DateTime.parse(json["fill_up_date"])
            : json["fill_up_date"],
        odometer: json["odometer"],
        liter: json["liter"] ?? '-',
        hargaPerLiter: json["harga_per_liter"],
        total: json["total"],
        bukti: json["bukti"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fixed_asset_id": fixedAssetId,
        "nama_fixed_asset": namaFixedAsset,
        "fill_up_date":
            "${fillUpDate.year.toString().padLeft(4, '0')}-${fillUpDate.month.toString().padLeft(2, '0')}-${fillUpDate.day.toString().padLeft(2, '0')}",
        "odometer": odometer,
        "liter": liter,
        "harga_per_liter": hargaPerLiter,
        "total": total,
        "bukti": bukti,
        "notes": notes,
      };
}
