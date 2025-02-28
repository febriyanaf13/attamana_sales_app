import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

GetStorage storage = GetStorage();

String setRupiah(int nilai) {
  return NumberFormat.simpleCurrency(
    decimalDigits: 0,
    locale: 'id_ID',
  ).format(nilai);
}

String setTanggal(DateTime tgl) {
  return DateFormat('dd MMMM yyyy').format(tgl);
}
