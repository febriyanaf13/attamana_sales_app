import 'package:maps_toolkit/maps_toolkit.dart';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class CekLokasi {
  double? latTitikSekarang;
  double? lngTitikSekarang;
  double? latTitikCircle;
  double? lngTitikCircle;
  List<double>? listLatPolygon;
  List<double>? listLngPolygon;
  List<LatLng> listPolygonPoints = [];

  CekLokasi({
    this.latTitikSekarang,
    this.lngTitikSekarang,
    this.latTitikCircle,
    this.lngTitikCircle,
    this.listLatPolygon,
    this.listLngPolygon,
  });

  bool apakahLokasiDalamPolygon() {
    if (listLatPolygon != null && listLngPolygon != null) {
      print('Masuk ke polygon');

      // 🔹 Pastikan list kosong sebelum diisi ulang
      listPolygonPoints.clear();

      for (var i = 0; i < listLatPolygon!.length; i++) {
        listPolygonPoints.add(LatLng(listLatPolygon![i], listLngPolygon![i]));
      }

      final titikSekarang = LatLng(latTitikSekarang!, lngTitikSekarang!);

      final inside = PolygonUtil.containsLocation(
        titikSekarang,
        listPolygonPoints,
        true,
      );

      print('Titik sekarang: $titikSekarang');
      print('Polygon points: $listPolygonPoints');
      print('Apakah di dalam polygon: $inside');

      return inside;
    } else {
      return false;
    }
  }

  bool apakahLokasiDalamCircle() {
    // num distance =
    //     // SphericalUtil.computeOffset(from, distance, heading)
    //     SphericalUtil.computeDistanceBetween(
    //         LatLng(latTitikSekarang!, lngTitikSekarang!),
    //         LatLng(latTitikCircle!, latTitikCircle!));
    var jarak = (distance(latTitikCircle!, lngTitikCircle!, latTitikSekarang!,
                lngTitikSekarang!) *
            1000)
        .ceil();
    print('jarak orang ke circle $jarak');
    if (jarak <= 100) {
      return true;
    } else {
      return false;
    }
  }

  double distance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6372.8; // Earth radius in kilometers

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final lat1Radians = _toRadians(lat1);
    final lat2Radians = _toRadians(lat2);

    final a =
        _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
    final c = 2 * asin(sqrt(a));

    return r * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  num _haversin(double radians) => pow(sin(radians / 2), 2);
}
