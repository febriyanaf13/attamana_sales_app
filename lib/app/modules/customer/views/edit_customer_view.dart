import 'package:attamana_salles_app/app/modules/customer/controllers/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/colors.dart';

class EditCustomerView extends GetView<CustomerController> {
  const EditCustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var index = Get.arguments;

    // Inisialisasi data ke controller
    controller.controllerNama.text = controller.listCustomerSearch[index].nama;
    controller.controllerAddress.text =
        controller.listCustomerSearch[index].address;
    controller.controllerKabupaten.text =
        controller.listCustomerSearch[index].city;
    controller.controllerPhone.text =
        controller.listCustomerSearch[index].phone1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
      appBar: AppBar(
        title: const Text(
          'Edit Customer',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              // Label Seksi
              Text(
                'PERBARUI DATA PELANGGAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Form Card
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
                    CustomTextField(
                      title: 'Nama Lengkap',
                      hint: 'Tuliskan nama customer',
                      isRequired: true,
                      controller: controller.controllerNama,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      title: 'Alamat',
                      hint: 'Tuliskan alamat customer',
                      isRequired: true,
                      controller: controller.controllerAddress,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      title: 'Kota',
                      hint: 'Tuliskan kota customer',
                      isRequired: true,
                      controller: controller.controllerKabupaten,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      title: 'Nomor Telepon',
                      hint: 'Tuliskan nomor telepon customer',
                      isRequired: true,
                      inputType: const TextInputType.numberWithOptions(),
                      controller: controller.controllerPhone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Update Modern
              Obx(() => controller.isLoadingUpdateCustomer.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    )
                  : CustomButton(
                      onTap: () {
                        controller.postUpdateCustomer(
                          controller.listCustomerSearch[index].customerId,
                        );
                      },
                      text: 'UPDATE DATA CUSTOMER',
                      border: 15,
                      height: 55,
                      gradient: LinearGradient(
                        colors: [kPrimaryColor, const Color(0xFF1E3C72)],
                      ),
                    )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
