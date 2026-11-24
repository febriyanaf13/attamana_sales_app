import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../style/colors.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../controllers/sample_form_controller.dart';

/// VERSI 49: form Sample & Pricing (input / edit). Urutan isian mengikuti form web:
/// tanggal, due date, tipe customer & customer, hotel (nama, kategori bintang, provinsi, kota, lokasi, jumlah kamar),
/// tipe barang, estimasi pemakaian, target price, payment term, existing supplier, PIC, foto, note, lalu spesifikasi.
class SampleFormView extends GetView<SampleFormController> {
  const SampleFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        title: Text(controller.modeEdit ? 'Edit Sample' : 'Sample Baru', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
        }
        return Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              // -------------------------------------------------- umum
              const SalesSectionTitle('Data pengajuan', ikon: Icons.event_note_rounded),
              SalesCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: SalesDateField(label: 'Tanggal', controller: controller.cTanggal, wajib: true)),
                        const SizedBox(width: 12),
                        Expanded(child: SalesDateField(label: 'Due date', controller: controller.cDueDate, wajib: true)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Obx(() => SalesPickerField(
                          label: 'Tipe customer',
                          nilai: controller.tipeCustomer.value,
                          hint: 'EXISTING / NEW',
                          onTap: controller.pilihTipeCustomer,
                        )),
                    Obx(() => controller.tipeCustomer.value != 'EXISTING'
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: SalesPickerField(
                              label: 'Customer',
                              wajib: true,
                              nilai: controller.customerNama.value,
                              hint: 'Cari customer',
                              onTap: controller.pilihCustomer,
                            ),
                          )),
                  ],
                ),
              ),

              // -------------------------------------------------- hotel
              const SalesSectionTitle('Hotel', ikon: Icons.apartment_rounded),
              SalesCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SalesTextField(label: 'Nama hotel', controller: controller.cNamaHotel, wajib: true),
                    const SizedBox(height: 14),
                    const SalesFieldLabel('Category hotel'),
                    Obx(() => Row(
                          children: List.generate(5, (i) {
                            final aktif = i < controller.rating.value;
                            return IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => controller.rating.value = (controller.rating.value == i + 1) ? 0 : i + 1,
                              icon: Icon(aktif ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: aktif ? Colors.amber : Colors.grey.shade400, size: 30),
                            );
                          }),
                        )),
                    const SizedBox(height: 8),
                    Obx(() => SalesPickerField(label: 'Provinsi', wajib: true, nilai: controller.provinsi.value, onTap: controller.pilihProvinsi)),
                    const SizedBox(height: 14),
                    Obx(() => SalesPickerField(
                          label: 'Kota / kabupaten',
                          wajib: true,
                          nilai: controller.kota.value,
                          hint: controller.isLoadingKota.isTrue ? 'Memuat...' : 'Pilih',
                          onTap: controller.pilihKota,
                        )),
                    const SizedBox(height: 14),
                    SalesTextField(label: 'Lokasi hotel', controller: controller.cLokasi, wajib: true, maxLines: 2),
                    const SizedBox(height: 14),
                    SalesTextField(label: 'Jumlah kamar', controller: controller.cJumlahKamar, wajib: true, angka: true),
                  ],
                ),
              ),

              // -------------------------------------------------- kebutuhan
              const SalesSectionTitle('Kebutuhan', ikon: Icons.inventory_2_outlined),
              SalesCard(
                child: Column(
                  children: [
                    Obx(() => SalesPickerField(label: 'Tipe barang', wajib: true, nilai: controller.tipeBarang.value, onTap: controller.pilihTipeBarang)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: SalesTextField(label: 'Estimasi pemakaian / bulan', controller: controller.cEstimasi, angka: true, hint: 'Qty')),
                        const SizedBox(width: 12),
                        Expanded(child: SalesTextField(label: 'Target price', controller: controller.cTarget, angka: true, hint: 'Rp')),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Obx(() => SalesPickerField(label: 'Payment term', wajib: true, nilai: controller.paymentTerm.value, onTap: controller.pilihPaymentTerm)),
                  ],
                ),
              ),

              // -------------------------------------------------- existing supplier
              SalesSectionTitle(
                'Existing supplier',
                ikon: Icons.storefront_outlined,
                aksi: TextButton.icon(
                  onPressed: controller.tambahKompetitor,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Tambah'),
                ),
              ),
              SalesCard(
                child: Obx(() => Column(
                      children: List.generate(controller.kompetitor.length, (i) {
                        final k = controller.kompetitor[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: i == controller.kompetitor.length - 1 ? 0 : 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(flex: 3, child: SalesTextField(label: 'Nama supplier', controller: k.nama)),
                              const SizedBox(width: 8),
                              Expanded(flex: 2, child: SalesTextField(label: 'Harga', controller: k.harga, angka: true)),
                              IconButton(
                                onPressed: () => controller.hapusKompetitor(i),
                                icon: const Icon(Icons.remove_circle_outline_rounded, color: kMerah),
                              ),
                            ],
                          ),
                        );
                      }),
                    )),
              ),

              // -------------------------------------------------- PIC & catatan
              const SalesSectionTitle('PIC & catatan', ikon: Icons.badge_outlined),
              SalesCard(
                child: Column(
                  children: [
                    SalesTextField(label: 'PIC (nama & jabatan)', controller: controller.cPic),
                    const SizedBox(height: 14),
                    SalesTextField(label: 'Kontak PIC', controller: controller.cKontakPic),
                    const SizedBox(height: 14),
                    SalesTextField(label: 'Note', controller: controller.cNote, maxLines: 3, maxLength: 255),
                  ],
                ),
              ),

              // -------------------------------------------------- foto
              SalesSectionTitle(
                'Foto',
                ikon: Icons.photo_camera_outlined,
                aksi: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Kamera',
                      onPressed: () => controller.ambilFoto(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_rounded, color: kPrimaryColor),
                    ),
                    IconButton(
                      tooltip: 'Galeri',
                      onPressed: () => controller.ambilFoto(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_rounded, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final lama = controller.fotoLama.toList();
                final baru = controller.fotoBaru.toList();
                if (lama.isEmpty && baru.isEmpty) {
                  return const SalesCard(
                    child: Text('Belum ada foto. Tambah dari kamera atau galeri (opsional).', style: TextStyle(fontSize: 12.5, color: kSlate500)),
                  );
                }
                Widget kotak(Widget gambar, VoidCallback hapus) => Stack(
                      children: [
                        Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: gambar)),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: InkWell(
                            onTap: hapus,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                return GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    ...lama.map((f) => kotak(
                          Image.network(teksDari(f['url']), fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: kSlate100, child: const Icon(Icons.broken_image_outlined))),
                          () => controller.hapusFotoLama(intDari(f['id'])),
                        )),
                    ...List.generate(baru.length, (i) => kotak(
                          Image.file(baru[i], fit: BoxFit.cover),
                          () => controller.fotoBaru.removeAt(i),
                        )),
                  ],
                );
              }),

              // -------------------------------------------------- spesifikasi
              const SalesSectionTitle('Spesifikasi', ikon: Icons.tune_rounded),
              Obx(() {
                if (controller.tipeBarangId.value == 0) {
                  return const SalesCard(
                    child: Text('Pilih tipe barang untuk menampilkan pertanyaan spesifikasi.', style: TextStyle(fontSize: 12.5, color: kSlate500)),
                  );
                }
                if (controller.isLoadingPertanyaan.isTrue) {
                  return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator(color: kPrimaryColor)));
                }
                if (controller.pertanyaan.isEmpty) {
                  return const SalesCard(
                    child: Text('Tidak ada pertanyaan spesifikasi untuk tipe barang ini.', style: TextStyle(fontSize: 12.5, color: kSlate500)),
                  );
                }
                return Column(
                  children: controller.pertanyaan.map((q) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _Pertanyaan(q: q))).toList(),
                );
              }),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() => controller.isLoading.isTrue
          ? const SizedBox()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: controller.isSaving.isTrue ? null : controller.simpan,
                    icon: controller.isSaving.isTrue
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded),
                    label: Text(
                      controller.isSaving.isTrue ? 'Menyimpan...' : (controller.modeEdit ? 'Simpan perubahan' : 'Simpan & ajukan approval'),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ),
              ),
            )),
    );
  }
}

class _Pertanyaan extends StatelessWidget {
  const _Pertanyaan({required this.q});

  final PertanyaanSample q;

  @override
  Widget build(BuildContext context) {
    return SalesCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Obx(() {
        final terpilih = q.jawabanId.value; // dibaca di sini agar Obx selalu punya nilai reaktif
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q.pertanyaan, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: kSlate900)),
              const SizedBox(height: 8),
              if (q.pilihanGanda)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: q.pilihan.map((p) {
                    final id = intDari(p['jawaban_id']);
                    final dipilih = terpilih == id;
                    return ChoiceChip(
                      label: Text(teksDari(p['jawaban'])),
                      selected: dipilih,
                      selectedColor: kPrimaryColor.withOpacity(0.15),
                      labelStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: dipilih ? kPrimaryColor : kSlate700),
                      onSelected: (_) => q.jawabanId.value = id,
                    );
                  }).toList(),
                ),
              if (q.perluIsian) ...[
                if (q.pilihanGanda) const SizedBox(height: 10),
                TextField(
                  controller: q.isian,
                  maxLines: q.pilihanGanda ? 1 : 2,
                  decoration: InputDecoration(
                    hintText: 'Jawaban',
                    filled: true,
                    fillColor: kSlate50,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                ),
              ],
            ],
          );
      }),
    );
  }
}
