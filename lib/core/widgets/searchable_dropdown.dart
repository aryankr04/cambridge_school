import 'dart:async';

import 'package:cambridge_school/core/utils/constants/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/text_styles.dart';

class MySearchableDropdown extends StatefulWidget {
  final List<String> options;
  final String hintText;
  final String? labelText;
  final ValueChanged<String> onSelected;
  final bool showClearIcon;
  final bool isValidate;
  final String? errorText;

  const MySearchableDropdown({
    super.key,
    required this.options,
    required this.onSelected,
    this.hintText = "Select an option",
    this.labelText,
    this.showClearIcon = false,
    this.isValidate = true,
    this.errorText,
  });

  @override
  State<MySearchableDropdown> createState() => _MySearchableDropdownState();
}

class _MySearchableDropdownState extends State<MySearchableDropdown> {
  final TextEditingController _controller = TextEditingController();
  final RxList<String> _filteredOptions = <String>[].obs;
  final RxBool _isDropdownOpen = false.obs;
  final RxString _selectedValue = RxString('');
  final Duration _debounceDuration = const Duration(milliseconds: 300);
  Timer? _debounceTimer;
  final RxString _errorText = RxString('');

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
    widget.onSelected(option); // Always pass a non-null String
    _isDropdownOpen.value = false;
    _selectedValue.value = option;
    _validate();
  }

  void _clearText() {
    _controller.clear();
    _filterOptions();
    widget.onSelected(''); // Always pass a non-null String (empty string)
    _selectedValue.value = '';
    _validate();
  }

  void _validate() {
    if (widget.isValidate && _selectedValue.value.isEmpty) {
      _errorText.value = widget.errorText ?? 'Please select an option';
    } else {
      _errorText.value = '';
    }
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
            Text(widget.labelText!, style: MyTextStyle.inputLabel),
            const SizedBox(height: 6),
          ],
          FocusScope(
            child: Focus(
              onFocusChange: (focus) {
                if (!focus) {
                  _isDropdownOpen.value = false;
                  _validate();
                }
              },
              child: TextField(
                controller: _controller,
                style: MyTextStyle.inputField,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: MyTextStyle.placeholder,
                  suffixIcon: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showClearIcon &&
                          _controller.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _clearText();
                          },
                        ),
                      IconButton(
                        icon: Icon(_isDropdownOpen.value
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                        onPressed: () {
                          _isDropdownOpen.toggle();
                          _filterOptions();
                          _validate();
                        },
                      ),
                    ],
                  )),
                  errorText:
                  _errorText.value.isNotEmpty ? _errorText.value : null,
                  errorStyle: const TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                      borderSide: _errorText.value.isNotEmpty
                          ? const BorderSide(color: Colors.red)
                          : BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: _errorText.value.isNotEmpty
                          ? const BorderSide(color: Colors.red)
                          : BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderSide: _errorText.value.isNotEmpty
                          ? const BorderSide(color: Colors.red)
                          : BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                      borderSide: _errorText.value.isNotEmpty
                          ? const BorderSide(color: Colors.red)
                          : BorderSide.none),
                ),
                onTap: () {
                  _isDropdownOpen.value = true;
                  _filterOptions();
                  _validate();
                },
                onChanged: (value) {
                  _validate();
                },
                onSubmitted: (value) {
                  _validate();
                },
              ),
            ),
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
                      onTap: () {
                        _selectOption(option);
                      },
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