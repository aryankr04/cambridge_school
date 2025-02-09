import 'dart:async';

import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/sizes.dart';
import '../utils/constants/text_styles.dart';

class MySearchableDropdown extends StatefulWidget {
  final List<String> options;
  final String hintText;
  final String? labelText;
  final ValueChanged<String> onSelected;
  final bool showClearIcon;

  const MySearchableDropdown({
    super.key,
    required this.options,
    required this.onSelected,
    this.hintText = "Select an option",
    this.labelText,
    this.showClearIcon = false,
  });

  @override
  State<MySearchableDropdown> createState() => _MySearchableDropdownState();
}

class _MySearchableDropdownState extends State<MySearchableDropdown> {
  final TextEditingController _controller = TextEditingController();
  final RxList<String> _filteredOptions = <String>[].obs;
  final RxBool _isDropdownOpen = false.obs;
  final RxString _selectedValue = ''.obs;
  final Duration _debounceDuration = const Duration(milliseconds: 300);
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _filteredOptions.assignAll(widget.options);
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, _filterOptions);
  }

  void _filterOptions() {
    final query = _controller.text.toLowerCase();
    List<String> filtered = widget.options
        .where((option) => option.toLowerCase().contains(query))
        .toList();

    filtered.sort((a, b) {
      final aIndex = a.toLowerCase().indexOf(query);
      final bIndex = b.toLowerCase().indexOf(query);

      if (aIndex == bIndex) {
        return a.toLowerCase().compareTo(b.toLowerCase());
      } else if (aIndex == -1) {
        return 1;
      } else if (bIndex == -1) {
        return -1;
      } else {
        return aIndex.compareTo(bIndex);
      }
    });

    _filteredOptions.assignAll(filtered);
  }

  void _selectOption(String option) {
    _controller.text = option;
    widget.onSelected(option);
    _isDropdownOpen.value = false;
    _selectedValue.value = option;
  }

  void _clearText() {
    _controller.clear();
    _filterOptions();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isDropdownOpen.value = false; // Close on outside tap
      },
      behavior: HitTestBehavior.translucent, // Allows taps to pass through
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null) ...[
            Text(widget.labelText!, style: MyTextStyles.inputLabel),
            const SizedBox(height: 6),
          ],
          TextField(
            controller: _controller,
            style: MyTextStyles.inputField,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: MyTextStyles.placeholder,
              suffixIcon: Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showClearIcon && _controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearText,
                    ),
                  IconButton(
                    icon: Icon(_isDropdownOpen.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down),
                    onPressed: () {
                      _isDropdownOpen.toggle();
                      _filterOptions();
                    },
                  ),
                ],
              )),
            ),
            onTap: () {
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
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredOptions.length,
                  itemBuilder: (context, index) {
                    final option = _filteredOptions[index];
                    return ListTile(
                      tileColor: _selectedValue.value == option
                          ? Colors.grey[200]
                          : null,
                      title: Text(option),
                      onTap: () => _selectOption(option),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}