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
    this.controller, // Allow a pre-existing TextEditingController to be passed in
  });

  final RxList<String> _filteredOptions = <String>[].obs;
  final RxBool _isDropdownOpen = false.obs;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = controller ?? TextEditingController();
    // Initialize filtered options using the passed options or an empty list.
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
      onSelected(option);
      _isDropdownOpen.value = false;
    }

    void clearText() {
      textController.clear();
      filterOptions();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: MyTextStyle.labelLarge),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: showClearIcon && textController.text.isNotEmpty
                ? IconButton(
                icon: const Icon(Icons.clear), onPressed: clearText)
                : const SizedBox.shrink(),
          ),
          onChanged: (_) => filterOptions(),
          onSubmitted: (value) {
            onSelected(value);
          },
        ),
        Obx(() {
          if (!_isDropdownOpen.value) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4)
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _filteredOptions[index],
                    style: MyTextStyle.bodyMedium,
                  ),
                  onTap: () => selectOption(_filteredOptions[index]),
                );
              },
            ),
          );
        }),
      ],
    );
  }
  void dispose() {
    // Dispose of the controller only if it was created internally.
    if (controller == null) {
      controller?.dispose(); // Dispose if created in build
    }

  }
}