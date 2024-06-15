// To parse this JSON data, do
//
//     final cuti = cutiFromJson(jsonString);

import 'dart:convert';

List<Cuti> cutiFromJson(List lst) =>
    List<Cuti>.from(lst.map((x) => Cuti.fromJson(x)));

String cutiToJson(List<Cuti> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cuti {
  int id;
  int pegawaiId;
  int approvedBy;
  int tipeCutiId;
  DateTime startDate;
  int days;
  String note;
  dynamic noteFromApprover;
  String status;
  int userCreated;
  int userModified;
  DateTime created;
  DateTime modified;
  dynamic bukti;
  int lastLevelApproval;
  Approver? approver;
  TipeCuti tipeCuti;

  Cuti({
    required this.id,
    required this.pegawaiId,
    required this.approvedBy,
    required this.tipeCutiId,
    required this.startDate,
    required this.days,
    required this.note,
    required this.noteFromApprover,
    required this.status,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
    required this.bukti,
    required this.lastLevelApproval,
    required this.approver,
    required this.tipeCuti,
  });

  factory Cuti.fromJson(Map<String, dynamic> json) => Cuti(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        approvedBy: json["approved_by"],
        tipeCutiId: json["tipe_cuti_id"],
        startDate: DateTime.parse(json["start_date"]),
        days: json["days"],
        note: json["note"],
        noteFromApprover: json["note_from_approver"],
        status: json["status"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        bukti: json["bukti"],
        lastLevelApproval: json["last_level_approval"],
        approver: json["approver"] == null
            ? null
            : Approver.fromJson(json["approver"]),
        tipeCuti: TipeCuti.fromJson(json["tipe_cuti"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pegawai_id": pegawaiId,
        "approved_by": approvedBy,
        "tipe_cuti_id": tipeCutiId,
        "start_date": startDate.toIso8601String(),
        "days": days,
        "note": note,
        "note_from_approver": noteFromApprover,
        "status": status,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "bukti": bukti,
        "last_level_approval": lastLevelApproval,
        "approver": approver?.toJson(),
        "tipe_cuti": tipeCuti.toJson(),
      };
}

class Approver {
  int id;
  int departmentId;
  int userId;
  String nikKaryawan;
  String noKtp;
  String nama;
  dynamic tglLahir;
  String tempatLahir;
  String alamat;
  String statusnikah;
  dynamic telepon;
  String nohp;
  dynamic email;
  dynamic jabatan;
  String statusKaryawan;
  String statusKontrak;
  dynamic statusPajak;
  dynamic golonganDarah;
  dynamic urgentContact;
  dynamic alamatUrgent;
  dynamic joinDate;
  String status;
  int userCreated;
  int userModified;
  DateTime created;
  DateTime modified;
  int jabatanId;
  int ptkpId;
  bool taxCut;
  dynamic noKk;
  String noRekening;
  dynamic tanggalResign;
  int cabangId;
  int companyId;
  dynamic gender;
  dynamic agama;
  dynamic alasanResign;
  dynamic levelPegawaiId;

  Approver({
    required this.id,
    required this.departmentId,
    required this.userId,
    required this.nikKaryawan,
    required this.noKtp,
    required this.nama,
    required this.tglLahir,
    required this.tempatLahir,
    required this.alamat,
    required this.statusnikah,
    required this.telepon,
    required this.nohp,
    required this.email,
    required this.jabatan,
    required this.statusKaryawan,
    required this.statusKontrak,
    required this.statusPajak,
    required this.golonganDarah,
    required this.urgentContact,
    required this.alamatUrgent,
    required this.joinDate,
    required this.status,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
    required this.jabatanId,
    required this.ptkpId,
    required this.taxCut,
    required this.noKk,
    required this.noRekening,
    required this.tanggalResign,
    required this.cabangId,
    required this.companyId,
    required this.gender,
    required this.agama,
    required this.alasanResign,
    required this.levelPegawaiId,
  });

  factory Approver.fromJson(Map<String, dynamic> json) => Approver(
        id: json["id"],
        departmentId: json["department_id"],
        userId: json["user_id"],
        nikKaryawan: json["nik_karyawan"],
        noKtp: json["no_ktp"],
        nama: json["nama"],
        tglLahir: json["tgl_lahir"],
        tempatLahir: json["tempat_lahir"],
        alamat: json["alamat"],
        statusnikah: json["statusnikah"],
        telepon: json["telepon"],
        nohp: json["nohp"],
        email: json["email"],
        jabatan: json["jabatan"],
        statusKaryawan: json["status_karyawan"],
        statusKontrak: json["status_kontrak"],
        statusPajak: json["status_pajak"],
        golonganDarah: json["golongan_darah"],
        urgentContact: json["urgent_contact"],
        alamatUrgent: json["alamat_urgent"],
        joinDate: json["join_date"],
        status: json["status"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        jabatanId: json["jabatan_id"],
        ptkpId: json["ptkp_id"],
        taxCut: json["tax_cut"],
        noKk: json["no_kk"],
        noRekening: json["no_rekening"],
        tanggalResign: json["tanggal_resign"],
        cabangId: json["cabang_id"],
        companyId: json["company_id"],
        gender: json["gender"],
        agama: json["agama"],
        alasanResign: json["alasan_resign"],
        levelPegawaiId: json["level_pegawai_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "department_id": departmentId,
        "user_id": userId,
        "nik_karyawan": nikKaryawan,
        "no_ktp": noKtp,
        "nama": nama,
        "tgl_lahir": tglLahir,
        "tempat_lahir": tempatLahir,
        "alamat": alamat,
        "statusnikah": statusnikah,
        "telepon": telepon,
        "nohp": nohp,
        "email": email,
        "jabatan": jabatan,
        "status_karyawan": statusKaryawan,
        "status_kontrak": statusKontrak,
        "status_pajak": statusPajak,
        "golongan_darah": golonganDarah,
        "urgent_contact": urgentContact,
        "alamat_urgent": alamatUrgent,
        "join_date": joinDate,
        "status": status,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "jabatan_id": jabatanId,
        "ptkp_id": ptkpId,
        "tax_cut": taxCut,
        "no_kk": noKk,
        "no_rekening": noRekening,
        "tanggal_resign": tanggalResign,
        "cabang_id": cabangId,
        "company_id": companyId,
        "gender": gender,
        "agama": agama,
        "alasan_resign": alasanResign,
        "level_pegawai_id": levelPegawaiId,
      };
}

class TipeCuti {
  int id;
  String namaTipe;
  int kuota;
  int userCreated;
  int userModified;
  DateTime created;
  DateTime modified;

  TipeCuti({
    required this.id,
    required this.namaTipe,
    required this.kuota,
    required this.userCreated,
    required this.userModified,
    required this.created,
    required this.modified,
  });

  factory TipeCuti.fromJson(Map<String, dynamic> json) => TipeCuti(
        id: json["id"],
        namaTipe: json["nama_tipe"],
        kuota: json["kuota"],
        userCreated: json["user_created"],
        userModified: json["user_modified"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_tipe": namaTipe,
        "kuota": kuota,
        "user_created": userCreated,
        "user_modified": userModified,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
      };
}
