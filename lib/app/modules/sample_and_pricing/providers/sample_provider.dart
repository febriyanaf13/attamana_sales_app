import 'package:get/get.dart';

import '../../../data/api/my_api.dart';
import '../../../utils/constants.dart';
import '../../../utils/string.dart';

/// VERSI 49: API Sample & Pricing untuk aplikasi sales.
class SampleProvider extends GetConnect {
  SampleProvider() : super(timeout: const Duration(seconds: 60));

  Map<String, String> get headers => {
        "Authorization": "Bearer ${storage.read(kToken)}",
        "Accept": "application/json"
      };

  String get userId => '${storage.read(kUserId)}';

  Future<Response> getList(Map<String, String> query) =>
      get(Api.sample, headers: headers, query: {...query, 'userid': userId});

  Future<Response> getDetail(int id) => get('${Api.sample}/$id', headers: headers, query: {'userid': userId});

  Future<Response> getMaster() => get(Api.sampleMaster, headers: headers);

  Future<Response> getCustomer(String cari) => get(Api.sampleCustomer, headers: headers, query: {'cari': cari});

  Future<Response> getPertanyaan(int tipeBarangId) => get('${Api.samplePertanyaan}/$tipeBarangId', headers: headers);

  Future<Response> getProvinsi() => get(Api.getProvinsi, headers: headers);

  Future<Response> getKabupaten(String provinsiId) => get('${Api.getKabupaten}/$provinsiId', headers: headers);

  /// [body] FormData (multipart, ada foto)
  Future<Response> simpan(FormData body) => post(Api.sampleSimpan, body, headers: headers);

  Future<Response> update(int id, FormData body) => post('${Api.sampleUpdate}/$id', body, headers: headers);

  /// VERSI 61: kirim sample (READY TO DELIVERED -> DELIVERED SAMPLE TO CUSTOMER).
  /// [body]: tanggal_kirim, real_armada_kirim, via, nomor_resi (userid ditambahkan otomatis).
  Future<Response> kirim(int id, Map<String, String> body) =>
      post('${Api.sampleKirim}/$id', FormData({...body, 'userid': userId}), headers: headers);

  /// VERSI 61: status hasil dari pelanggan. [body] FormData: status, catatan, file_bukti_approval (wajib untuk APPROVED).
  Future<Response> updateStatus(int id, FormData body) => post('${Api.sampleStatus}/$id', body, headers: headers);
}
