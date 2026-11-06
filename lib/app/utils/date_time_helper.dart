import 'package:intl/intl.dart';

String formatTanggal(dynamic tanggal) {
  if (tanggal == null) return '-';
  DateTime? dt;
  try {
    if (tanggal is DateTime) {
      dt = tanggal;
    } else if (tanggal is String) {
      if (tanggal.trim().isEmpty) return '-';
      dt = DateTime.parse(tanggal); // server format "yyyy-MM-dd HH:mm:ss"
    } else {
      return '-';
    }
  } catch (_) {
    return '-';
  }
  return DateFormat('dd MMMM yyyy').format(dt);
}

String formatJamMenit(dynamic waktu) {
  if (waktu == null) return '-';
  DateTime? dt;
  try {
    if (waktu is DateTime) {
      dt = waktu;
    } else if (waktu is String) {
      if (waktu.trim().isEmpty) return '-';
      dt = DateTime.parse(waktu);
    } else {
      return '-';
    }
  } catch (_) {
    return '-';
  }
  return DateFormat('HH:mm').format(dt);
}
