import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants/dynamic_colors.dart';
import '../utils/constants/sizes.dart';

class MyImagePickerField extends StatefulWidget {
  final File? image;
  final ValueChanged<File> onImageSelected;
  final String? label;

  const MyImagePickerField({
    super.key,
    required this.image,
    required this.onImageSelected,
    this.label,
  });

  @override
  _MyImagePickerFieldState createState() => _MyImagePickerFieldState();
}

class _MyImagePickerFieldState extends State<MyImagePickerField> {
  late File? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.onImageSelected(_image!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: MyDynamicColors.activeBlue.withOpacity(0.05),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(MySizes.cardRadiusXs)),
                  border: Border.all(
                    color: MyDynamicColors.primaryColor,
                    width: 1,
                  ),
                ),
                child: _image == null
                    ? Icon(
                  Icons.add_a_photo_rounded,
                  size: 28,
                  color: MyDynamicColors.activeBlue,
                )
                    : ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(MySizes.cardRadiusXs)),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: MySizes.lg,
        ),
        Expanded(
          // Wrap the container with Expanded
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _image == null
                    ? MyDynamicColors.activeBlue
                    : MyDynamicColors.activeBlue,
                borderRadius:
                const BorderRadius.all(Radius.circular(MySizes.cardRadiusXs)),
              ),
              child: Text(
                _image == null
                    ? widget.label != null
                    ? "Select ${widget.label!} Image "
                    : 'Select a Profile Image'
                    : 'Change ${widget.label!} Image', // Use the label
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ),
        ),
        const SizedBox(
          width: MySizes.lg,
        ),
        _image != null
            ? CircleAvatar(
            backgroundColor: MyDynamicColors.activeGreen,
            radius: 14,
            child: const Icon(
              Icons.check_rounded,
              size: 22,
              color: MyDynamicColors.white,
            ))
            : const SizedBox()
      ],
    );
  }
}
