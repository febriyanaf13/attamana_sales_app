import 'package:attamana_salles_app/app/utils/extension_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../style/colors.dart';
import '../../../style/paddings.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: kPagePadding, right: kPagePadding, left: kPagePadding),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: kPrimaryColor, width: 5),
                              color: kWhiteColor,
                              image: DecorationImage(
                                  image: AssetImage(
                                    'user_profile'.png,
                                  ),
                                  fit: BoxFit.fill)),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                          )),
                      const SizedBox(
                        height: kElementPadding,
                      ),
                      Text(controller.nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.titleLarge
                              ?.copyWith(color: kPrimaryColor)),
                      Text(controller.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: kPrimaryTextColor)),
                    ],
                  ),
                  const SizedBox(
                    height: kContainerPadding,
                  ),
                  // GestureDetector(
                  //     child: Row(
                  //   children: [
                  //     Expanded(
                  //       child: Row(
                  //         children: [
                  //           const Icon(Icons.person, color: kDarkGreyColor),
                  //           const SizedBox(
                  //             width: kElementPadding,
                  //           ),
                  //           Text(
                  //             'Data Pribadi',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyLarge
                  //                 ?.copyWith(color: kPrimaryTextColor),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     const Expanded(
                  //         child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //       children: [
                  //         Icon(
                  //           Icons.keyboard_arrow_right,
                  //           color: kPrimaryTextColor,
                  //         )
                  //       ],
                  //     ))
                  //   ],
                  // )),
                  // const SizedBox(
                  //   height: kElementPadding,
                  // ),
                  // GestureDetector(
                  //   onTap: () => Get.toNamed(Routes.OUR_TIM),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Row(
                  //         children: [
                  //           SvgPicture.asset(
                  //               'assets/icons/clarity_users-solid.svg'),
                  //           SizedBox(
                  //             width: kElementPadding,
                  //           ),
                  //           Text(
                  //             'Tim Kami',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText1
                  //                 ?.copyWith(color: kSecondaryTextColor),
                  //           )
                  //         ],
                  //       )),
                  //       Expanded(
                  //           child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           SizedBox(
                  //             width: 5,
                  //           ),
                  //           Icon(
                  //             Icons.keyboard_arrow_right,
                  //             color: kSecondaryTextColor,
                  //           )
                  //         ],
                  //       ))
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: kElementPadding,
                  // ),
                  // GestureDetector(

                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Row(
                  //         children: [
                  //           SvgPicture.asset('assets/icons/icon-faq.svg'),
                  //           const SizedBox(
                  //             width: kElementPadding,
                  //           ),
                  //           Text(
                  //             'FAQ',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText1
                  //                 ?.copyWith(color: kPrimaryTextColor),
                  //           )
                  //         ],
                  //       )),
                  //       Expanded(
                  //           child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           const Icon(
                  //             Icons.keyboard_arrow_right,
                  //             color: kPrimaryTextColor,
                  //           )
                  //         ],
                  //       ))
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: kElementPadding,
                  // ),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.password,
                              color: kDarkGreyColor,
                            ),
                            const SizedBox(
                              width: kElementPadding,
                            ),
                            Text(
                              'Update Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: kPrimaryTextColor),
                            ),
                            const Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: kPrimaryTextColor,
                                )
                              ],
                            ))
                          ],
                        ),
                        onTap: () => controller.onTapUpdatePassword(),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: kElementPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout,
                              color: kErrorColor,
                            ),
                            const SizedBox(
                              width: kElementPadding,
                            ),
                            Text(
                              'Keluar',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: kPrimaryTextColor),
                            ),
                            const Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: kPrimaryTextColor,
                                )
                              ],
                            ))
                          ],
                        ),
                        onTap: () => controller.onTapLogout(),
                      )),
                    ],
                  )
                ],
              ),
            ),
            Obx(() => Positioned(
                bottom: 10,
                right: 20,
                child: Text(
                  'Version ${controller.version}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: kSecondaryTextColor),
                )))
          ],
        ),
      )),
    );
  }
}
