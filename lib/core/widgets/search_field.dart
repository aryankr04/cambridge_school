import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
import 'package:cambridge_school/core/utils/constants/sizes.dart';
import 'package:cambridge_school/core/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySearchField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final ValueChanged<String> onSelected;
  final bool showClearIcon;
  final List<String>? options;
  final TextEditingController? controller;

  MySearchField({
    super.key,
    this.options,
    required this.onSelected,
    this.hintText = "Search...",
    this.labelText,
    this.showClearIcon = false,
    this.controller,
  });

  final RxList<String> _filteredOptions = <String>[].obs;
  final RxBool _isDropdownOpen = false.obs;
  final RxString _textValue = "".obs; // Observable for text value

  @override
  Widget build(BuildContext context) {
    TextEditingController textController =
        controller ?? TextEditingController();

    // Initialize filtered options
    _filteredOptions.assignAll(options ?? []);

    void filterOptions() {
      final query = textController.text.toLowerCase();
      List<String> filtered = (options ?? [])
          .where((option) => option.toLowerCase().contains(query))
          .toList();

      // Sort results based on query match
      filtered.sort((a, b) {
        final aIndex = a.toLowerCase().indexOf(query);
        final bIndex = b.toLowerCase().indexOf(query);
        return aIndex.compareTo(bIndex);
      });

      _filteredOptions.assignAll(filtered);
      _isDropdownOpen.value = filtered.isNotEmpty;
    }

    void selectOption(String option) {
      textController.text = option;
      _textValue.value = option;
      onSelected(option);
      _isDropdownOpen.value = false;
    }

    void clearText() {
      textController.clear();
      _textValue.value = "";
      filterOptions();
    }

    textController.addListener(() {
      _textValue.value = textController.text;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: MyTextStyle.labelLarge),
          const SizedBox(height: 6),
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: MySizes.md),
          child: Column(
            children: [
              Obx(() => TextField(
                    onTap: () => _isDropdownOpen.value = true,
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: hintText,
                      suffixIcon: showClearIcon && _textValue.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: clearText,
                            )
                          : const SizedBox.shrink(),
                    ),
                    onChanged: (_) => filterOptions(),
                    onSubmitted: (value) {
                      onSelected(value);
                    },
                  )),
              Obx(() {
                if (!_isDropdownOpen.value) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    boxShadow: MyBoxShadows.kLightShadow,
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => selectOption(_filteredOptions[index]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: MySizes.sm + 4, horizontal: MySizes.md),
                          child: Text(
                            _filteredOptions[index],
                            style: MyTextStyle.bodyMedium,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
