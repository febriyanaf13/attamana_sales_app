/// VERSI 53: pilihan pendamping activity (API list_pendamping). pegawaiId 0 = tanpa pendamping.
class Pendamping {
  final int pegawaiId;
  final String nama;

  const Pendamping({required this.pegawaiId, required this.nama});

  factory Pendamping.fromJson(Map<String, dynamic> json) => Pendamping(
        pegawaiId: int.tryParse('${json['pegawai_id'] ?? 0}') ?? 0,
        nama: '${json['nama'] ?? ''}',
      );

  static const tanpa = Pendamping(pegawaiId: 0, nama: '— Tanpa pendamping —');

  /// dipakai pencarian dropdown
  @override
  String toString() => nama;
}
