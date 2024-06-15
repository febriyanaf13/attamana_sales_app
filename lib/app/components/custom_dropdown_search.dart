import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:searchfield/searchfield.dart';

import '../style/colors.dart';

class CustomDropDownSearch extends StatefulWidget {
  final bool isRequired;
  final String title;
  final bool? withTitle;
  final String? hint;
  final List? dataList;
  final double? width;
  final TextEditingController controller;
  final bool? autoFocus;
  final bool? labelSpace;
  final Function(String?) onSubmit;
  final Function(String?) onSave;
  final String? Function(String?) validator;

  final Function(SearchFieldListItem<String>)? onSelectedItem;
  final SearchFieldListItem<String>? initialValue;

  const CustomDropDownSearch({
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
  State<CustomDropDownSearch> createState() => _CustomDropDownSearchState();
}

class _CustomDropDownSearchState extends State<CustomDropDownSearch> {
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
          SearchField<String>(
            hint: widget.hint,
            initialValue: widget.initialValue,
            suggestionState: Suggestion.expand,
            suggestionAction: SuggestionAction.next,
            textInputAction: TextInputAction.done,
            controller: widget.controller,

            searchInputDecoration: const InputDecoration(
              contentPadding: EdgeInsets.all(20),
              // hintText: widget.hint,
              hintStyle: TextStyle(color: kSecondaryTextColor),
              // enabledBorder: OutlineInputBorder(
              //     borderSide: const BorderSide(
              //       color: Colors.black45,
              //     ),
              //     borderRadius: BorderRadius.circular(25)),
              // focusedBorder: OutlineInputBorder(
              //     borderSide: const BorderSide(color: grey),
              //     borderRadius: BorderRadius.circular(25)),
            ),
            marginColor: grey,
            itemHeight: 50,
            suggestionsDecoration: SuggestionDecoration(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: cardLightColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: grey),
            ),

            // suggestionItemDecoration: BoxDecoration(
            //
            //     borderRadius: BorderRadius.circular(8),
            //     shape: BoxShape.rectangle,
            //
            //     border: Border.all(
            //         color: grey,
            //         style: BorderStyle.solid,
            //         width: 1.0)),
            validator: widget.validator,
            onSubmit: widget.onSubmit,
            onSaved: widget.onSave,
            onSearchTextChanged: (query) {
              final filter = widget.dataList!
                  .where((element) => element['text']
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .toList();
              return filter
                  .map((e) => SearchFieldListItem<String>(e['text']))
                  .toList();
            },
            onSuggestionTap: widget.onSelectedItem,
            suggestionStyle: Get.textTheme.bodyMedium,
            suggestions: widget.dataList!
                .map(
                  (e) => SearchFieldListItem<String>(
                    e['text'] ?? '-',
                    item: e['value'],
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e['text'] ?? '-',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
