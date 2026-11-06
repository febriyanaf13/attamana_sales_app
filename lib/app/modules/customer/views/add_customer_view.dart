import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_controller.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_field.dart';
import '../../../components/custom_dropdown_search2.dart';
import '../../../style/colors.dart';

class AddCustomerView extends GetView<CustomerController> {
  const AddCustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Tambah Customer',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INFORMASI PELANGGAN',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.5)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      title: 'Nama Lengkap',
                      hint: 'Masukkan nama customer',
                      isRequired: true,
                      controller: controller.controllerNama,
                    ),
                    const SizedBox(height: 20),

                    // --- DROPDOWN PROVINSI ---
                    CustomDropDownSearch<dynamic>(
                      controller: controller.controllerProvinsi,
                      title: 'Provinsi',
                      isRequired: true,
                      withTitle: true,
                      hint: 'Pilih Provinsi...',
                      dataList: controller.listProvinsi,
                      itemLabel: (item) => item['nama_provinsi'].toString(),
                      onSelectedItem: (value) {
                        if (value != null) {
                          controller.provinsiId.value =
                              value['provinsi_id'].toString();
                          controller.controllerProvinsi.text =
                              value['nama_provinsi'].toString();

                          // Panggil fungsi ambil kabupaten saat provinsi dipilih
                          controller.getKabupaten(controller.provinsiId.value);
                        }
                      },
                      onSubmit: (String? p1) {},
                      onSave: (String? p1) {},
                      validator: (String? p1) {},
                    ),

                    const SizedBox(height: 20),

// --- DROPDOWN KABUPATEN (Baru) ---
                    CustomDropDownSearch<dynamic>(
                      controller: controller.controllerKabupaten,
                      title: 'Kabupaten / Kota',
                      isRequired: true,
                      withTitle: true,
                      hint: controller.provinsiId.isEmpty
                          ? 'Pilih provinsi terlebih dahulu'
                          : 'Pilih Kabupaten...',
                      dataList: controller.listKabupaten,
                      // Key sesuai JSON kabupaten: nama_kabupaten
                      itemLabel: (item) => item['nama_kabupaten'].toString(),
                      onSelectedItem: (value) {
                        if (value != null) {
                          // Simpan key sesuai JSON kabupaten: kabupaten_id
                          controller.kabupatenId.value =
                              value['kabupaten_id'].toString();
                          controller.controllerKabupaten.text =
                              value['nama_kabupaten'].toString();
                        }
                      },
                      onSubmit: (String? p1) {},
                      onSave: (String? p1) {},
                      validator: (String? p1) {},
                    ),

                    const SizedBox(height: 20),
                    CustomTextField(
                      title: 'Alamat',
                      hint: 'Masukkan alamat lengkap',
                      isRequired: true,
                      controller: controller.controllerAddress,
                    ),
                    const SizedBox(height: 20),
                    // CustomTextField(
                    //   title: 'Kota',
                    //   hint: 'Masukkan kota',
                    //   controller: controller.controllerCity,
                    //   isRequired: true,
                    // ),
                    // const SizedBox(height: 20),
                    CustomTextField(
                      title: 'Nomor Telepon',
                      hint: 'Contoh: 08123456789',
                      inputType: TextInputType.phone,
                      controller: controller.controllerPhone,
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Obx(() => controller.isLoadingSimpanCustomer.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor))
                  : CustomButton(
                      onTap: () => controller.postNewCustomer(),
                      text: 'SIMPAN DATA CUSTOMER',
                      border: 15,
                      height: 55,
                      gradient: const LinearGradient(
                          colors: [kPrimaryColor, Color(0xFF1E3C72)]),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
