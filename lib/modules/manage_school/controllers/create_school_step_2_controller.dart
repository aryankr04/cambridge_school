import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateSchoolStep2LocationDetailsController extends GetxController {
  // Initialize LocationDetails
  final TextEditingController addressController=TextEditingController();
  final TextEditingController streetController=TextEditingController();
  final TextEditingController cityController=TextEditingController();
  final TextEditingController stateController=TextEditingController();
  final TextEditingController districtController=TextEditingController();
  final TextEditingController zipCodeController=TextEditingController();
  final TextEditingController countryController=TextEditingController();

  final TextEditingController landmarksNearbyController=TextEditingController();
  // Observables for dropdown or dynamically selected values
  var selectedState = ''.obs;
  var selectedCountry = ''.obs;
  // List of predefined options for dropdowns (can be extended or loaded from APIs)
  var states = [
    'Bihar',
    'Uttar Pradesh',
    'Maharashtra',
    'Tamil Nadu',
    'Karnataka',
    'Punjab'
  ].obs;

  var countries = [
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia'
  ].obs;


}
