import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../style/colors.dart';
import '../controllers/teams_controller.dart';

class TeamsView extends GetView<TeamsController> {
  const TeamsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Get.width * 0.6,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 50,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('bg'.png),
                          repeat: ImageRepeat.repeat),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 50,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kPrimaryColor.withOpacity(0.9),
                          kPrimaryColor,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Card(
                                    elevation: 2,
                                    color: white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Image.asset(
                                        'logo_attamana'.png,
                                        scale: 20,
                                      ),
                                    )),
                                10.width,
                                Text(
                                  'Attamana Teams',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: SizedBox(
                      height: 100,
                      width: Get.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: greenColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        '5',
                                        style: Get.textTheme.titleLarge
                                            ?.copyWith(
                                                color: white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          'Aktif',
                                          style: Get.textTheme.bodySmall
                                              ?.copyWith(color: white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              15.width,
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        '5',
                                        style: Get.textTheme.titleLarge
                                            ?.copyWith(
                                                color: white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          'Izin',
                                          style: Get.textTheme.bodySmall
                                              ?.copyWith(color: white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              15.width,
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: errorColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        '5',
                                        style: Get.textTheme.titleLarge
                                            ?.copyWith(
                                                color: white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          'Cuti',
                                          style: Get.textTheme.bodySmall
                                              ?.copyWith(color: white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: 15,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 80,
                    width: Get.width,
                    child: Card(
                      color: kCardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Container(
                                height: Get.height,
                                decoration: BoxDecoration(
                                    color: greenColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset('user_profile'.jpg))),
                            10.width,
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText('Karyawan ${index + 1}',
                                    style: Get.textTheme.titleMedium),
                                5.height,
                                Expanded(
                                  child: AutoSizeText('08123456789',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          color: kSecondaryTextColor)),
                                ),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: kGreenColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'Aktif',
                                style: Get.textTheme.bodySmall
                                    ?.copyWith(color: kWhiteColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
