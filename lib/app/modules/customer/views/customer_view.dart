import 'package:attamana_salles_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../style/colors.dart';
import '../../sales_module/shared/sales_ui.dart';
import '../controllers/customer_controller.dart';
import '../models/customer.dart';

/// VERSI 49: list customer dirapikan.
/// - Kotak cari selalu tampil, pencarian di server per kata (nama, corporate, perusahaan, telepon, kota, provinsi, alamat).
/// - Urutan A–Z / order terakhir / terbaru.
/// - Kartu ringkas: inisial berwarna tier, nama, corporate & kota, tier, jumlah SO & SO terakhir; detail dibuka di kartu.
/// - Data dimuat bertahap saat di-scroll (tanpa tombol halaman).
class CustomerView extends GetView<CustomerController> {
  const CustomerView({Key? key}) : super(key: key);

  static const _urut = {
    'nama': 'A – Z',
    'order_terakhir': 'Order terakhir',
    'baru': 'Terbaru'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Column(
          children: [
            const Text('Customer Saya',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Obx(() => Text(
                  controller.isLoadingCustomer.isTrue &&
                          controller.listCustomerSearch.isEmpty
                      ? 'Memuat...'
                      : '${fmtAngka(controller.totalCustomer.value)} customer',
                  style: const TextStyle(fontSize: 11.5, color: Colors.white70),
                )),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Tambah customer',
            onPressed: () {
              controller.resetForm();
              Get.toNamed(Routes.ADD_CUSTOMER);
            },
            icon: const Icon(Icons.person_add_alt_1_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(66),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: SalesSearchBox(
              controller: controller.controllerSearch,
              hint: 'Cari nama, kota, telepon, corporate...',
              onChanged: (v) => controller.kataCari.value = v,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Obx(() => SalesFilterChips(
                pilihan: _urut,
                aktif: controller.urut.value,
                onPilih: controller.ubahUrut,
              )),
          const SizedBox(height: 6),
          Expanded(
            child: RefreshIndicator(
              color: kPrimaryColor,
              onRefresh: () async => controller.getCustomer(),
              child: Obx(() {
                if (controller.isLoadingCustomer.isTrue &&
                    controller.listCustomerSearch.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor));
                }
                if (controller.listCustomerSearch.isEmpty) {
                  return SalesKosong(
                    judul: controller.controllerSearch.text.isEmpty
                        ? 'Belum ada customer'
                        : 'Customer tidak ditemukan',
                    pesan: controller.controllerSearch.text.isEmpty
                        ? 'Customer yang di-assign ke Anda akan tampil di sini.'
                        : 'Coba kata lain, misalnya nama kota atau nomor telepon.',
                    ikon: Icons.groups_2_outlined,
                  );
                }
                final n = controller.listCustomerSearch.length;
                return ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: n + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == n) return _footer();
                    return _CustomerCard(
                        index: index,
                        data: controller.listCustomerSearch[index]);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Obx(() {
      if (controller.isLoadingMore.isTrue) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: kPrimaryColor))),
        );
      }
      final habis = controller.curretPage.value >= controller.totalPages.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: habis
              ? Text(
                  'Semua ${fmtAngka(controller.totalCustomer.value)} customer sudah tampil',
                  style: const TextStyle(fontSize: 12, color: kSlate500))
              : TextButton(
                  onPressed: controller.muatBerikutnya,
                  child: const Text('Muat lebih banyak')),
        ),
      );
    });
  }
}

class _CustomerCard extends StatefulWidget {
  const _CustomerCard({required this.index, required this.data});

  final int index;
  final Customer data;

  @override
  State<_CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<_CustomerCard> {
  bool buka = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final index = widget.index;
    final warnaTier = data.tierWarna.isEmpty
        ? kPrimaryColor
        : warnaHex(data.tierWarna, cadangan: kPrimaryColor);
    final sub = [data.corporate, data.city]
        .where((e) => e.isNotEmpty && e != '-')
        .join(' • ');
    final telp = data.phone1 != '-'
        ? data.phone1
        : (data.picHp.isNotEmpty ? data.picHp : '');

    return SalesCard(
      padding: EdgeInsets.zero,
      onTap: () => setState(() => buka = !buka),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 6, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: warnaTier.withOpacity(0.14),
                  child: Text(inisial(data.namaTampil),
                      style: TextStyle(
                          color: warnaTier,
                          fontWeight: FontWeight.w900,
                          fontSize: 15)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.namaTampil,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: kSlate900)),
                      if (sub.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(sub,
                            style: const TextStyle(
                                fontSize: 12,
                                color: kSlate500,
                                fontWeight: FontWeight.w600)),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (data.tier.isNotEmpty)
                            SalesBadge(
                                teks: data.tier,
                                warna: warnaTier,
                                ikon: Icons.workspace_premium_rounded),
                          SalesBadge(
                            teks: data.jumlahSo == 0
                                ? 'Belum ada SO'
                                : '${data.jumlahSo} SO',
                            warna: data.jumlahSo == 0 ? kSlate500 : kBiru,
                            ikon: Icons.receipt_long_rounded,
                          ),
                          if (data.soTerakhir.isNotEmpty)
                            SalesBadge(
                                teks: 'Terakhir ${fmtTanggal(data.soTerakhir)}',
                                warna: kHijau,
                                ikon: Icons.history_rounded),
                          if (data.statusCrm.isNotEmpty &&
                              data.statusCrm.toUpperCase() != 'AKTIF')
                            SalesBadge(teks: data.statusCrm, warna: kOranye),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Edit',
                      onPressed: () =>
                          Get.toNamed(Routes.EDIT_CUSTOMER, arguments: index),
                      icon: const Icon(Icons.edit_note_rounded, color: kBiru),
                    ),
                    Icon(
                        buka
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade400),
                  ],
                ),
              ],
            ),
          ),
          if (telp.isNotEmpty)
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: telp));
                Get.snackbar('Disalin', 'Nomor $telp disalin',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(70, 0, 14, 12),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, size: 14, color: kSlate500),
                    const SizedBox(width: 6),
                    Text(telp,
                        style: const TextStyle(
                            fontSize: 12.5,
                            color: kSlate700,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    const Icon(Icons.copy_rounded, size: 12, color: kSlate500),
                  ],
                ),
              ),
            ),
          if (buka)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: const BoxDecoration(
                color: kSlate50,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: Column(
                children: [
                  SalesInfoRow('Perusahaan',
                      data.companyName == '-' ? '' : data.companyName),
                  SalesInfoRow(
                      'Alamat', data.address == '-' ? '' : data.address),
                  SalesInfoRow(
                      'Kota / Provinsi',
                      [data.city, data.state]
                          .where((e) => e.isNotEmpty && e != '-')
                          .join(', ')),
                  SalesInfoRow(
                      'PIC',
                      [data.pic, data.picHp]
                          .where((e) => e.isNotEmpty)
                          .join(' — ')),
                  SalesInfoRow('Email', data.email),
                  SalesInfoRow('Payment term', data.paymentTerms),
                  if (data.kode.isNotEmpty) SalesInfoRow('Kode', data.kode),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
