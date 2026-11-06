import 'package:attamana_salles_app/app/components/custom_datepicker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_dropdown.dart';
import '../../../../components/custom_dropdown_search2.dart';
import '../../../../components/custom_text_field.dart';
import '../../../../style/colors.dart';
import '../../../../style/paddings.dart';
import '../controllers/activity_controller.dart';
import '../models/existing_customer.dart';

class AddActivityView extends GetView<ActivityController> {
  const AddActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var visitId = Get.arguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          visitId == null ? 'Buat Job Visit' : 'Edit Job Visit',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
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
              // --- LABEL SEKSI ---
              Text(
                'RENCANA KUNJUNGAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // --- FORM CARD ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border:
                      Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                ),
                child: Column(
                  children: [
                    // --- CUSTOMER SEARCH ---
                    Obx(() {
                      final selectedCustomer =
                          controller.listExistingCustomer2.firstWhereOrNull(
                        (e) =>
                            e.customerId.toString() ==
                            controller.customerId.value,
                      );

                      return CustomDropDownSearch<ExistingCustomer>(
                        title: 'Pilih Customer',
                        labelSpace: true,
                        isRequired: true,
                        withTitle: true,
                        hint: 'Cari customer...',
                        initialValue: selectedCustomer,
                        dataList: controller.listExistingCustomer2,
                        onSelectedItem: (value) {
                          if (value != null) {
                            controller.customerId.value =
                                value.customerId.toString();
                            controller.textEditingControllerNama.text =
                                value.namaHotel;

                            // ✅ OTOMATIS ISI ALAMAT SAAT CUSTOMER DIPILIH
                            // Pastikan model ExistingCustomer memiliki properti 'address' atau 'alamat'
                            controller.textEditingControllerAlamat.text =
                                value.alamatHotel ?? '';
                          }
                        },
                        validator: (x) {
                          if (controller.customerId.value.isEmpty) {
                            return 'Customer harus dipilih!';
                          }
                          return null;
                        },
                        itemLabel: (item) => item.namaHotel,
                        controller: controller.textEditingControllerNama,
                        onSubmit: (String? p1) {},
                        onSave: (String? p1) {},
                      );
                    }),
                    const SizedBox(height: 20),

                    // ✅ FORM ALAMAT (KLIK UNTUK BUKA PETA)
                    GestureDetector(
                      onTap: () {
                        // Panggil fungsi peta dari controller
                        controller.pickAddressFromMap();
                      },
                      child: AbsorbPointer(
                        // Mencegah keyboard muncul saat form ditekan
                        child: CustomTextField(
                          title: 'Alamat Lengkap',
                          hint: 'Klik untuk memilih lokasi di peta...',
                          isRequired: true,
                          maxLine: 3,
                          // Jika CustomTextField Anda belum support readOnly,
                          // set controller agar tidak bisa diedit manual (opsional)
                          controller: controller.textEditingControllerAlamat,
                          // Suffix icon opsional (jika CustomTextField mendukung)
                          // suffixIcon: const Icon(Icons.map_rounded, color: kPrimaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- TUJUAN KUNJUNGAN ---
                    Obx(() => CustomDropdownButton(
                          title: 'Tujuan Kunjungan',
                          initialValue: controller.action.value,
                          isRequired: true,
                          height: 60,
                          items: controller.listAction.value,
                          onChangeValue: (value) {
                            controller.action.value = value.toString();
                          },
                          validator: 'Tujuan harus dipilih!',
                        )),
                    const SizedBox(height: 20),

                    // --- PENDAMPING (OPTIONAL DROPDOWN) ---
                    Obx(() => CustomDropdownButton(
                          title: 'Pendamping',
                          initialValue: controller.action.value == ''
                              ? null
                              : controller.action.value,
                          isRequired: false,
                          height: 60,
                          items: controller.listAction.value,
                          onChangeValue: (value) {},
                          validator: '',
                        )),
                    const SizedBox(height: 20),

                    // --- TANGGAL VISIT ---
                    Obx(() => CustomDateTimePickerDialog(
                          title: 'Visit',
                          setDateValue: controller.tglVisit.value,
                          onDataChange: (value) {
                            if (value != null) {
                              controller.tglVisit.value = value;
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih tanggal!';
                            }
                            return null;
                          },
                          isRequired: true,
                        )),
                    const SizedBox(height: 20),

                    // --- DESKRIPSI ---
                    CustomTextField(
                      title: 'Keterangan / Notulen',
                      hint: 'Tuliskan rencana atau catatan kunjungan...',
                      isRequired: true,
                      maxLine: 5,
                      controller: controller.textEditingControllerDeskripsi,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- BUTTON SIMPAN ---
              Obx(() => controller.isLoadingSimpanActivity.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor))
                  : CustomButton(
                      onTap: () {
                        if (visitId != null) {
                          controller.updateActivity(visitId);
                        } else {
                          controller.postSimpanActivity();
                        }
                      },
                      text: visitId == null ? 'SIMPAN JADWAL' : 'UPDATE JADWAL',
                      border: 15,
                      height: 55,
                      gradient: LinearGradient(
                        colors: [kPrimaryColor, const Color(0xFF1E3C72)],
                      ),
                    )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
