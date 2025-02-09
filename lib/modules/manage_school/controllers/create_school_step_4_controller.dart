import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateSchoolStep4InfrastructureDetailsController extends GetxController {
  // Text controllers for numeric fields
  final TextEditingController campusSizeController=TextEditingController();
  final numberOfBuildingsController = TextEditingController();
  final numberOfFloorsController = TextEditingController();
  final totalClassroomsController = TextEditingController();



  final availableFacilities = [
    'Library',
    'Auditorium',
    'Cafeteria',
    'Transportation',
    'Hostel',
    'Special Needs Accessible',
    'Smart Classroom',
  ];
  final selectedAvailableFacilities = <String>[].obs;

  // Laboratories checkbox state
  final availableLaboratories =
      ["Physics", "Chemistry", "Biology", "Computer"].obs;
  final selectedLaboratories = <String>[].obs;

  // Sports Facilities checkbox state
  final availableSportsFacilities =
      ["Indoor Games", "Outdoor Games", "Playground"].obs;
  final selectedSportsFacilities = <String>[].obs;
}
