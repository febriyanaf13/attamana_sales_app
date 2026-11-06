import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style/colors.dart';

class CustomDropDownSearch<T> extends StatefulWidget {
  final bool isRequired;
  final String title;
  final bool? withTitle;
  final String? hint;
  final List<T>? dataList;
  final double? width;
  final TextEditingController controller;
  final bool? autoFocus;
  final bool? labelSpace;
  final Function(String?) onSubmit;
  final Function(String?) onSave;
  final String? Function(String?) validator;
  final Function(T?)? onSelectedItem;
  final T? initialValue;
  final String Function(T) itemLabel;

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
    required this.itemLabel,
  });

  @override
  State<CustomDropDownSearch<T>> createState() =>
      _CustomDropDownSearchState<T>();
}

class _CustomDropDownSearchState<T> extends State<CustomDropDownSearch<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- TITLE LABEL ---
          if (widget.withTitle == true) ...[
            RichText(
              text: TextSpan(
                text: widget.title,
                style: const TextStyle(
                  color: Color(0xFF475569), // Slate 600
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                children: [
                  if (widget.isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // --- DROPDOWN CORE ---
          CustomDropdown<T>.search(
            hintText: widget.hint ?? 'Pilih...',
            items: widget.dataList ?? [],
            initialItem: widget.initialValue,
            headerBuilder: (context, selectedItem, enabled) {
              return Text(
                selectedItem != null
                    ? widget.itemLabel(selectedItem)
                    : (widget.hint ?? 'Pilih...'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selectedItem != null
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: selectedItem != null
                      ? const Color(0xFF1E293B)
                      : Colors.grey.shade400,
                ),
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Text(
                widget.itemLabel(item),
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? kPrimaryColor : const Color(0xFF475569),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            },
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(12),
              expandedBorderRadius: BorderRadius.circular(12),
              closedFillColor: Colors.white,
              closedBorder:
                  Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              expandedBorder:
                  Border.all(color: kPrimaryColor.withOpacity(0.5), width: 1.5),

              // PERBAIKAN DI SINI:
              searchFieldDecoration: SearchFieldDecoration(
                fillColor: const Color(0xFFF8FAFC),
                // Menggunakan border OutlineInputBorder alih-alih BorderSide langsung
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.5)),
                ),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                widget.onSelectedItem?.call(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
