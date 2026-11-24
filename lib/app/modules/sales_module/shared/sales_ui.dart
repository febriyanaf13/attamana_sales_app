// Komponen & format bersama untuk modul sales (Customer, Tracking SO, Sample & Pricing).
// Dibuat tanpa paket tambahan supaya tidak menambah dependency.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../style/colors.dart';

const kSlate900 = Color(0xFF1E293B);
const kSlate700 = Color(0xFF334155);
const kSlate500 = Color(0xFF64748B);
const kSlate100 = Color(0xFFF1F5F9);
const kSlate50 = Color(0xFFF8FAFC);
const kBiru = Color(0xFF2563EB);
const kHijau = Color(0xFF16A34A);
const kOranye = Color(0xFFEA580C);
const kMerah = Color(0xFFDC2626);
const kUngu = Color(0xFF7C3AED);

// ------------------------------------------------------------------ format

double angkaDari(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int intDari(dynamic v) => angkaDari(v).round();

String teksDari(dynamic v) => v == null ? '' : v.toString();

bool boolDari(dynamic v) => v == true || v == 1 || v == '1' || v == 'true';

/// 1.500 / 1.500,5
String fmtAngka(num v) {
  final f = NumberFormat.decimalPattern('id_ID');
  f.maximumFractionDigits = 2;
  return f.format(v);
}

String fmtRupiah(num v) => 'Rp ${fmtAngka(v)}';

const _bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

/// '2026-11-22' / '2026-11-22 10:15:00' -> '22 Nov 2026' (+ jam bila ada)
String fmtTanggal(String? v, {bool denganJam = false}) {
  if (v == null || v.isEmpty) return '-';
  final d = DateTime.tryParse(v.replaceFirst(' ', 'T'));
  if (d == null) return v;
  final t = '${d.day.toString().padLeft(2, '0')} ${_bulan[d.month - 1]} ${d.year}';
  if (denganJam && v.length > 10) {
    return '$t ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
  return t;
}

String ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Color warnaHex(String hex, {Color cadangan = kSlate500}) {
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 3) h = h.split('').map((c) => '$c$c').join();
  if (h.length != 6) return cadangan;
  final n = int.tryParse(h, radix: 16);
  return n == null ? cadangan : Color(0xFF000000 | n);
}

String inisial(String nama) {
  final kata = nama.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (kata.isEmpty) return '?';
  if (kata.length == 1) return kata.first.substring(0, 1).toUpperCase();
  return (kata[0].substring(0, 1) + kata[1].substring(0, 1)).toUpperCase();
}

// ------------------------------------------------------------------ widget

/// Kotak pencarian dengan tombol hapus.
class SalesSearchBox extends StatelessWidget {
  const SalesSearchBox({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) => TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onChanged: onChanged,
          onSubmitted: onChanged,
          style: const TextStyle(fontSize: 14, color: kSlate900),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
            prefixIcon: const Icon(Icons.search_rounded, color: kPrimaryColor),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: kSlate500),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }
}

/// Deretan chip filter horizontal. [jumlah] opsional: angka di belakang label.
class SalesFilterChips extends StatelessWidget {
  const SalesFilterChips({
    super.key,
    required this.pilihan,
    required this.aktif,
    required this.onPilih,
    this.jumlah,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final Map<String, String> pilihan; // kode -> label
  final String aktif;
  final Function(String) onPilih;
  final Map<String, int>? jumlah;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        children: pilihan.entries.map((e) {
          final dipilih = e.key == aktif;
          final n = jumlah == null ? null : jumlah![e.key];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onPilih(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: dipilih ? kPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dipilih ? kPrimaryColor : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(e.value,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: dipilih ? Colors.white : kSlate700)),
                    if (n != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: dipilih ? Colors.white.withOpacity(0.25) : kSlate100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('$n',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: dipilih ? Colors.white : kSlate500)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SalesBadge extends StatelessWidget {
  const SalesBadge({super.key, required this.teks, required this.warna, this.ikon});

  final String teks;
  final Color warna;
  final IconData? ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ikon != null) ...[
            Icon(ikon, size: 12, color: warna),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              teks,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: warna, fontSize: 10.5, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesCard extends StatelessWidget {
  const SalesCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEEF2F6)),
            boxShadow: [
              BoxShadow(color: kSlate900.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 6)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class SalesSectionTitle extends StatelessWidget {
  const SalesSectionTitle(this.judul, {super.key, this.ikon, this.aksi});

  final String judul;
  final IconData? ikon;
  final Widget? aksi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
      child: Row(
        children: [
          if (ikon != null) ...[
            Icon(ikon, size: 18, color: kPrimaryColor),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(judul.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w900, color: kSlate500, letterSpacing: 1.1)),
          ),
          if (aksi != null) aksi!,
        ],
      ),
    );
  }
}

/// Baris label : nilai
class SalesInfoRow extends StatelessWidget {
  const SalesInfoRow(this.label, this.nilai, {super.key, this.lebarLabel = 118, this.tebal = false});

  final String label;
  final String nilai;
  final double lebarLabel;
  final bool tebal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: lebarLabel,
            child: Text(label, style: const TextStyle(fontSize: 12.5, color: kSlate500)),
          ),
          Expanded(
            child: Text(nilai.isEmpty ? '-' : nilai,
                style: TextStyle(
                    fontSize: 12.5,
                    color: kSlate900,
                    fontWeight: tebal ? FontWeight.w800 : FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// Batang progres qty: [nilai] dari [total] dengan label kecil.
class SalesQtyBar extends StatelessWidget {
  const SalesQtyBar({
    super.key,
    required this.label,
    required this.nilai,
    required this.total,
    required this.warna,
    this.satuan = '',
  });

  final String label;
  final double nilai;
  final double total;
  final Color warna;
  final String satuan;

  @override
  Widget build(BuildContext context) {
    final rasio = total <= 0 ? 0.0 : (nilai / total).clamp(0.0, 1.0).toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 11.5, color: kSlate500))),
              Text('${fmtAngka(nilai)} / ${fmtAngka(total)}${satuan.isEmpty ? '' : ' $satuan'}',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: kSlate700)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: rasio,
              minHeight: 6,
              backgroundColor: kSlate100,
              valueColor: AlwaysStoppedAnimation<Color>(warna),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stepper horizontal sederhana: [urutan] dari [total] langkah sudah dicapai.
class SalesStepBar extends StatelessWidget {
  const SalesStepBar({super.key, required this.urutan, required this.total, this.warna = kHijau});

  final int urutan;
  final int total;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final aktif = i < urutan;
        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: aktif ? warna : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class SalesKosong extends StatelessWidget {
  const SalesKosong({super.key, required this.judul, this.pesan = '', this.ikon = Icons.inbox_rounded});

  final String judul;
  final String pesan;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: Get.height * 0.18),
        Icon(ikon, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text(judul,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kSlate700)),
        if (pesan.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 6, 40, 0),
            child: Text(pesan,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: kSlate500)),
          ),
      ],
    );
  }
}

/// Pilihan dari daftar dalam bottom sheet dengan pencarian lokal.
Future<T?> pilihDariDaftar<T>({
  required String judul,
  required List<T> data,
  required String Function(T) label,
  String Function(T)? subLabel,
}) {
  final cari = ''.obs;
  return Get.bottomSheet<T>(
    Container(
      height: Get.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(judul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kSlate900)),
                ),
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close_rounded)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: false,
              onChanged: (v) => cari.value = v.toLowerCase(),
              decoration: InputDecoration(
                hintText: 'Cari...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: kSlate50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              final hasil = data.where((e) {
                final t = '${label(e)} ${subLabel == null ? '' : subLabel(e)}'.toLowerCase();
                return cari.value.isEmpty || t.contains(cari.value);
              }).toList();
              if (hasil.isEmpty) {
                return const Center(child: Text('Tidak ada data', style: TextStyle(color: kSlate500)));
              }
              return ListView.separated(
                itemCount: hasil.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 20, endIndent: 20),
                itemBuilder: (_, i) => ListTile(
                  title: Text(label(hasil[i]), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: subLabel == null ? null : Text(subLabel(hasil[i]), style: const TextStyle(fontSize: 12)),
                  onTap: () => Get.back(result: hasil[i]),
                ),
              );
            }),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

/// Field tanggal (yyyy-MM-dd) yang terikat ke [controller]; tampil dd Mmm yyyy.
class SalesDateField extends StatefulWidget {
  const SalesDateField({
    super.key,
    required this.label,
    required this.controller,
    this.wajib = false,
    this.bisaDikosongkan = false,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final bool wajib;
  final bool bisaDikosongkan;
  final VoidCallback? onChanged;

  @override
  State<SalesDateField> createState() => _SalesDateFieldState();
}

class _SalesDateFieldState extends State<SalesDateField> {
  Future<void> _pilih() async {
    final awal = DateTime.tryParse(widget.controller.text) ?? DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(2015),
      lastDate: DateTime(DateTime.now().year + 2, 12, 31),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: kPrimaryColor, onPrimary: Colors.white, onSurface: kSlate900),
        ),
        child: child!,
      ),
    );
    if (d != null) {
      setState(() => widget.controller.text = ymd(d));
      widget.onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => widget.wajib && widget.controller.text.isEmpty ? '${widget.label} wajib diisi' : null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalesFieldLabel(widget.label, wajib: widget.wajib),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _pilih,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: kSlate50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: state.hasError ? kMerah : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 16, color: kSlate500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.controller.text.isEmpty ? 'Pilih tanggal' : fmtTanggal(widget.controller.text),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: widget.controller.text.isEmpty ? Colors.grey.shade400 : kSlate900),
                    ),
                  ),
                  if (widget.bisaDikosongkan && widget.controller.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        setState(() => widget.controller.clear());
                        widget.onChanged?.call();
                      },
                      child: const Icon(Icons.close_rounded, size: 18, color: kSlate500),
                    ),
                ],
              ),
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(state.errorText!, style: const TextStyle(color: kMerah, fontSize: 11.5)),
            ),
        ],
      ),
    );
  }
}

class SalesFieldLabel extends StatelessWidget {
  const SalesFieldLabel(this.label, {super.key, this.wajib = false});

  final String label;
  final bool wajib;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: kSlate700),
          children: [
            if (wajib) const TextSpan(text: ' *', style: TextStyle(color: kMerah)),
          ],
        ),
      ),
    );
  }
}

/// TextFormField bergaya seragam
class SalesTextField extends StatelessWidget {
  const SalesTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.wajib = false,
    this.angka = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool wajib;
  final bool angka;
  final int maxLines;
  final int? maxLength;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesFieldLabel(label, wajib: wajib),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          keyboardType: angka ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          validator: (v) => wajib && (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kSlate900),
          decoration: InputDecoration(
            hintText: hint.isEmpty ? label : hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5, fontWeight: FontWeight.w400),
            filled: true,
            fillColor: kSlate50,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPrimaryColor, width: 1.4)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kMerah)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kMerah)),
          ),
        ),
      ],
    );
  }
}

/// Field pilihan (tap -> bottom sheet). [nilai] teks yang tampil.
class SalesPickerField extends StatelessWidget {
  const SalesPickerField({
    super.key,
    required this.label,
    required this.nilai,
    required this.onTap,
    this.hint = 'Pilih',
    this.wajib = false,
    this.aktif = true,
  });

  final String label;
  final String nilai;
  final String hint;
  final VoidCallback onTap;
  final bool wajib;
  final bool aktif;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => wajib && nilai.isEmpty ? '$label wajib dipilih' : null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalesFieldLabel(label, wajib: wajib),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: aktif ? onTap : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: aktif ? kSlate50 : kSlate100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: state.hasError ? kMerah : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(nilai.isEmpty ? hint : nilai,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: nilai.isEmpty ? Colors.grey.shade400 : kSlate900)),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: kSlate500),
                ],
              ),
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(state.errorText!, style: const TextStyle(color: kMerah, fontSize: 11.5)),
            ),
        ],
      ),
    );
  }
}
