import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/text_styles.dart';

class MySearchField extends StatefulWidget {
  final List<String>? options; // Make options optional
  final String hintText;
  final String? labelText;
  final ValueChanged<String> onSelected;
  final bool showClearIcon;

  const MySearchField({
    super.key,
    this.options, // Options is now optional
    required this.onSelected,
    this.hintText = "Search...",
    this.labelText,
    this.showClearIcon = false,
  });

  @override
  _MySearchFieldState createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  final TextEditingController _controller = TextEditingController();
  final RxList<String> _filteredOptions = <String>[].obs;
  final RxBool _isDropdownOpen = false.obs;

  @override
  void initState() {
    super.initState();
    _filteredOptions.assignAll(widget.options ?? []); // Handle null case
    _controller.addListener(_filterOptions);
  }

  @override
  void dispose() {
    _controller.removeListener(_filterOptions);
    _controller.dispose();
    super.dispose();
  }

  void _filterOptions() {
    final query = _controller.text.toLowerCase();
    List<String> filtered = (widget.options ?? []) // Handle null case
        .where((option) => option.toLowerCase().contains(query))
        .toList();

    // Sort the filtered options based on the index of the query
    filtered.sort((a, b) {
      final aIndex = a.toLowerCase().indexOf(query);
      final bIndex = b.toLowerCase().indexOf(query);

      if (aIndex == bIndex) {
        // If both start at the same index, sort alphabetically
        return a.toLowerCase().compareTo(b.toLowerCase());
      } else if (aIndex == -1) {
        // If 'a' does not contain the query, put 'b' first
        return 1;
      } else if (bIndex == -1) {
        // If 'b' does not contain the query, put 'a' first
        return -1;
      } else {
        // Sort by the index of the query (lower index comes first)
        return aIndex.compareTo(bIndex);
      }
    });

    _filteredOptions.assignAll(filtered);
  }

  void _selectOption(String option) {
    _controller.text = option;
    widget.onSelected(option);
    _isDropdownOpen.value = false;
  }

  void _clearText() {
    _controller.clear();
    _filterOptions(); // Refresh the filtered options after clearing
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: MyTextStyle.inputLabel,
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: _controller,
          style: MyTextStyle.inputField,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: MyTextStyle.placeholder,
            suffixIcon: Obx(() {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showClearIcon && _controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearText,
                    ),
                ],
              );
            }),
          ),
          onChanged: (value) {
            _isDropdownOpen.value = true;
            _filterOptions();
          },
        ),
        Obx(() {
          if (!_isDropdownOpen.value || _filteredOptions.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            constraints: BoxConstraints(maxHeight: Get.width),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: MyBoxShadows.kMediumShadow,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredOptions[index]),
                  onTap: () {
                    _selectOption(_filteredOptions[index]);
                    widget.onSelected(_filteredOptions[index]);
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}