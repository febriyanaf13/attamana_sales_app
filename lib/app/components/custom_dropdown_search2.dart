import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:attamana_salles_app/app/modules/customer/models/customer.dart';
import 'package:attamana_salles_app/app/modules/sales_module/activity/models/existing_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:searchfield/searchfield.dart';

import '../style/colors.dart';

class CustomDropDownSearch2 extends StatefulWidget {
  final bool isRequired;
  final String title;
  final bool? withTitle;
  final String? hint;
  final List<ExistingCustomer>? dataList;
  final double? width;
  final TextEditingController controller;
  final bool? autoFocus;
  final bool? labelSpace;
  final Function(String?) onSubmit;
  final Function(String?) onSave;
  final String? Function(String?) validator;

  final Function(ExistingCustomer?)? onSelectedItem;
  final SearchFieldListItem<String>? initialValue;

  const CustomDropDownSearch2({
    super.key,
    required this.controller,
    this.width,
    this.autoFocus,
    required this.title,
    this.labelSpace,
    required this.onSubmit,
    this.hint,
    this.dataList,
    this.onSelectedItem,
    required this.onSave,
    required this.validator,
    required this.isRequired,
    this.withTitle,
    this.initialValue,
  });

  @override
  State<CustomDropDownSearch2> createState() => _CustomDropDownSearchState();
}

class _CustomDropDownSearchState extends State<CustomDropDownSearch2> {
  var checkText = '';
  String? selectedItem;

  // final List<String> suggestions = [
  //   'United States',
  //   'Germany',
  //   'Washington',
  //   'Paris',
  //   'Jakarta',
  //   'Australia',
  //   'India',
  //   'Czech Republic',
  //   'Lorem Ipsum',
  // ];

  @override
  Widget build(BuildContext context) {
    // print(widget.controller?.text);
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.withTitle == true
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: widget.isRequired ? '* ' : widget.title,
                      style: widget.isRequired
                          ? const TextStyle(color: kErrorColor)
                          : const TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                widget.isRequired ? widget.title : '(Optional)',
                            style: widget.isRequired
                                ? const TextStyle(
                                    color: kPrimaryTextColor,
                                    fontWeight: FontWeight.bold)
                                : const TextStyle(
                                    color: kSecondaryTextColor,
                                    fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ))
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          // Text(widget.title, style: boldTextStyle(color: black, size: 14)),
          // widget.labelSpace.validate() ? 6.height : const Offstage(),
          CustomDropdown<ExistingCustomer>.search(
              hintText: widget.hint,
              items: widget.dataList,
              headerBuilder: (context, selectedItem, enabled) =>
                  Text(selectedItem.namaHotel),
              listItemBuilder: (context, item, isSelected, onItemSelect) {
                return Text(item.namaHotel);
              },
              excludeSelected: false,
              decoration: CustomDropdownDecoration(
                closedBorderRadius: BorderRadius.circular(10),
                expandedBorderRadius: BorderRadius.circular(10),
                closedBorder: Border.all(color: grey),
                expandedBorder: Border.all(color: grey),
              ),
              onChanged: widget.onSelectedItem),
        ],
      ),
    );
  }
}
