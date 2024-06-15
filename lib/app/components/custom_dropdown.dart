import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<Map<String, Object>>? items;
  final double? height, iconSize;
  final bool isRequired;
  final String title;
  final bool? withTitle;
  final TextStyle? textStyle;
  final Function(Object?)? onChangeValue;
  final String validator;
  final TextEditingController? controller;
  final String? initialValue;

  const CustomDropdownButton({
    Key? key,
    this.items,
    required this.validator,
    this.height,
    this.iconSize,
    this.withTitle = true,
    this.textStyle,
    required this.onChangeValue,
    required this.isRequired,
    required this.title,
    this.controller,
    this.initialValue,
  }) : super(key: key);

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

String? selectedValue;

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
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
                              text: widget.isRequired
                                  ? widget.title
                                  : '(Optional)',
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
          ],
        ),
        DropdownButtonFormField2(
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero, isDense: true),
          isExpanded: true,
          hint: Text(
            widget.initialValue == '' || widget.initialValue == null
                ? 'Pilih'
                : "${widget.initialValue}",
            style: widget.textStyle == null
                ? Theme.of(context).textTheme.bodyMedium
                : widget.textStyle!,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // hint: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          // iconOnClick: const Icon(Icons.arrow_drop_up, color: Colors.black54),
          // iconSize: widget.iconSize == null ? 25 : widget.iconSize!,
          // buttonHeight: widget.height ?? 50,
          // buttonPadding: const EdgeInsets.only(left: 5, right: 10),
          // dropdownDecoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(25),
          // ),
          items: widget.items
              ?.map((item) => DropdownMenuItem<Object>(
                    value: item['value'],
                    child: Text(item['text'].toString(),
                        style: widget.textStyle == null
                            ? Theme.of(context).textTheme.bodyMedium
                            : widget.textStyle!),
                  ))
              .toList(),
          onChanged: widget.onChangeValue,
          validator: (value) {
            print('ini $value');
            if (value == null && widget.initialValue == null) {
              return 'harus diisi';
            }
            return null;
          },
          onSaved: (value) {
            selectedValue = value.toString();
          },
        ),
      ],
    );
  }
}
