import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

/// VERSI 51: API notifikasi & pendampingan activity untuk aplikasi sales.
class NotifikasiProvider extends GetConnect {
  NotifikasiProvider() : super(timeout: const Duration(seconds: 30));

  Map<String, String> get headers => {
        "Authorization": "Bearer ${storage.read(kToken)}",
        "Accept": "application/json"
      };

  String get userId => '${storage.read(kUserId)}';

  /// daftar notifikasi. status: 'belum' | '' ; kategori: SO | PENDAMPINGAN | ACTIVITY | SAMPLE | ''
  Future<Response> getList({int page = 1, String status = '', String kategori = ''}) =>
      get(Api.notifikasi, headers: headers, query: {
        'userid': userId,
        'page': '$page',
        'per_page': '20',
        if (status.isNotEmpty) 'status': status,
        if (kategori.isNotEmpty) 'kategori': kategori,
      });

  Future<Response> getJumlah() => get(Api.notifikasiJumlah, headers: headers, query: {'userid': userId});

  Future<Response> baca({List<int> ids = const [], bool semua = false}) => post(
      Api.notifikasiBaca,
      FormData({
        'userid': userId,
        if (semua) 'semua': '1' else 'id': ids.join(','),
      }),
      headers: headers);

  Future<Response> simpanPerangkat(String token, String platform, String versi) => post(
      Api.notifikasiPerangkat,
      FormData({'userid': userId, 'token': token, 'platform': platform, 'aplikasi': 'SALES', 'versi_app': versi}),
      headers: headers);

  Future<Response> hapusPerangkat(String token) =>
      post(Api.notifikasiPerangkatHapus, FormData({'token': token}), headers: headers);

  /// status: REQUEST (menunggu keputusan) | RIWAYAT
  Future<Response> getPendampingan(String status) =>
      get(Api.pendampingan, headers: headers, query: {'userid': userId, 'status': status});

  Future<Response> putuskanPendampingan(List<int> ids, String status, String catatan) => post(
      Api.pendampinganPutuskan,
      FormData({'userid': userId, 'kunjungan_id': ids.join(','), 'status': status, 'note_pendamping': catatan}),
      headers: headers);
}
