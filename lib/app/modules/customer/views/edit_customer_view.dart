import 'package:attamana_salles_app/app/modules/customer/controllers/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_field.dart';
import '../../../style/colors.dart';

class EditCustomerView extends GetView<CustomerController> {
  const EditCustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var index = Get.arguments;
    controller.controllerNama.text = controller.listCustomerSearch[index].nama;
    controller.controllerAddress.text =
        controller.listCustomerSearch[index].address;
    controller.controllerCity.text = controller.listCustomerSearch[index].city;
    controller.controllerPhone.text =
        controller.listCustomerSearch[index].phone1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
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
                          controller.isLoadingUpdateCustomer.isTrue
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: kAccentColor,
                                  ),
                                )
                              : CustomButton(
                                  onTap: () {
                                    controller.postUpdateCustomer(controller
                                        .listCustomerSearch[index].customerId);
                                  },
                                  text: 'Update',
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
