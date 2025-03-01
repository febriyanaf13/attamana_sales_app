import 'package:attamana_salles_app/app/modules/customer/controllers/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/colors.dart';

class AddCustomerView extends GetView<CustomerController> {
  const AddCustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.controllerNama.text = '';
    controller.controllerAddress.text = '';
    controller.controllerCity.text = '';
    controller.controllerPhone.text = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
                flex: 15,
                child: SizedBox(
                    width: Get.size.width,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CustomTextField(
                            title: 'Nama',
                            hint: 'Tuliskan nama customer',
                            isRequired: true,
                            controller: controller.controllerNama,
                          ),
                          20.height,
                          CustomTextField(
                            title: 'Address',
                            hint: 'Tuliskan alamat customer',
                            isRequired: true,
                            controller: controller.controllerAddress,
                          ),
                          20.height,
                          CustomTextField(
                            title: 'City',
                            hint: 'Tuliskan kota customer',
                            isRequired: true,
                            controller: controller.controllerCity,
                          ),
                          20.height,
                          CustomTextField(
                            title: 'Phone',
                            hint: 'Tuliskan nomer telepon customer',
                            isRequired: true,
                            inputType: const TextInputType.numberWithOptions(),
                            controller: controller.controllerPhone,
                          ),
                          50.height,
                          controller.isLoadingSimpanCustomer.isTrue
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: kAccentColor,
                                  ),
                                )
                              : CustomButton(
                                  onTap: () {
                                    controller.postNewCustomer();
                                  },
                                  text: 'Simpan',
                                  border: 30,
                                  color: kAccentColor,
                                )
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
