// VERSI 49: item list Sample & Pricing (API GET sample).

import 'package:flutter/material.dart';

import '../../sales_module/shared/sales_ui.dart';

class SampleItem {
  final int sampleId;
  final String kodeSample;
  final String tanggal;
  final String dueDate;
  final String namaHotel;
  final String kota;
  final String tipeBarang;
  final String tipeCustomer;
  final String namaCustomer;
  final String status;
  final String statusApproval;
  final String statusKode;
  final String statusLabel;
  final int progres;
  final String foto;
  final bool bolehEdit;
  final bool bolehKirim; // VERSI 61
  final bool bolehUpdateStatus; // VERSI 61

  SampleItem({
    required this.sampleId,
    required this.kodeSample,
    required this.tanggal,
    required this.dueDate,
    required this.namaHotel,
    required this.kota,
    required this.tipeBarang,
    required this.tipeCustomer,
    required this.namaCustomer,
    required this.status,
    required this.statusApproval,
    required this.statusKode,
    required this.statusLabel,
    required this.progres,
    required this.foto,
    required this.bolehEdit,
    this.bolehKirim = false,
    this.bolehUpdateStatus = false,
  });

  factory SampleItem.fromJson(Map<String, dynamic> j) => SampleItem(
        sampleId: intDari(j['sample_id']),
        kodeSample: teksDari(j['kode_sample']),
        tanggal: teksDari(j['tanggal']),
        dueDate: teksDari(j['due_date']),
        namaHotel: teksDari(j['nama_hotel']),
        kota: teksDari(j['kota']),
        tipeBarang: teksDari(j['tipe_barang']),
        tipeCustomer: teksDari(j['tipe_customer']),
        namaCustomer: teksDari(j['nama_customer']),
        status: teksDari(j['status']),
        statusApproval: teksDari(j['status_approval']),
        statusKode: teksDari(j['status_kode']),
        statusLabel: teksDari(j['status_label']),
        progres: intDari(j['progres']),
        foto: teksDari(j['foto']),
        bolehEdit: boolDari(j['boleh_edit']),
        bolehKirim: boolDari(j['boleh_kirim']),
        bolehUpdateStatus: boolDari(j['boleh_update_status']),
      );
}

Color warnaStatusSample(String kode) {
  switch (kode) {
    case 'MENUNGGU_APPROVAL':
      return kOranye;
    case 'DITOLAK':
    case 'FAIL':
      return kMerah;
    case 'PROSES':
    case 'RND':
      return kBiru;
    case 'READY_TO_DELIVERED':
      return const Color(0xFF0D9488);
    case 'DELIVERED_SAMPLE_TO_CUSTOMER':
      return const Color(0xFF4F46E5);
    case 'APPROVED':
      return kHijau;
    case 'REVISI':
      return kUngu;
  }
  return kSlate500;
}

IconData ikonStatusSample(String kode) {
  switch (kode) {
    case 'MENUNGGU_APPROVAL':
      return Icons.hourglass_top_rounded;
    case 'DITOLAK':
      return Icons.block_rounded;
    case 'FAIL':
      return Icons.cancel_rounded;
    case 'PROSES':
    case 'RND':
      return Icons.science_rounded;
    case 'READY_TO_DELIVERED':
      return Icons.inventory_2_rounded;
    case 'DELIVERED_SAMPLE_TO_CUSTOMER':
      return Icons.local_shipping_rounded;
    case 'APPROVED':
      return Icons.verified_rounded;
    case 'REVISI':
      return Icons.edit_note_rounded;
  }
  return Icons.fiber_new_rounded;
}
