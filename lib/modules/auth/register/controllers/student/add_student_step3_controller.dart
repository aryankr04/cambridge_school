import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/services/location_api_service.dart';

class StudentStep3FormController extends GetxController {
  final step3FormKey = GlobalKey<FormState>();
  final LocationApiService apiService = LocationApiService();


  final TextEditingController houseAddressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final RxString selectedCountry = ''.obs;

  final RxString selectedState = RxString('');
  final RxString selectedDistrict = RxString('');
  final RxString selectedCity = RxString('');
  final RxList<String> countries = <String>[].obs;
  final RxList<String> states = <String>[].obs;
  final RxList<String> cities = <String>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final countriesData = await apiService.fetchCountries();
      countries.value = countriesData;
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      print("Error fetching countries: $e");
    }
  }

  Future<void> fetchStates(String countryName) async {
    isLoading.value = true;
    errorMessage.value = '';
    states.value = [];
    selectedState.value = '';
    cities.value = [];
    selectedCity.value = '';

    try {
      final statesData = await apiService.fetchStates(countryName);
      states.value = statesData;
      print(states);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      print("Error fetching states: $e");
    }
  }

  Future<void> fetchCities(String countryName, String stateName) async {
    isLoading.value = true;
    errorMessage.value = '';
    cities.value = [];
    selectedCity.value = '';

    try {
      final citiesData =
          await apiService.fetchCities(country: countryName, state: stateName);
      cities.value = citiesData;
      print(citiesData);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      print("Error fetching cities: $e");
    }
  }

  void onCountrySelected(String value) {
    selectedCountry.value = value;
    fetchStates(value);
  }

  void onStateSelected(String value) {
    selectedState.value = value;
    fetchCities(selectedCountry.value, value);
  }

  void clearForm() {
    houseAddressController.clear();
    pinCodeController.clear();
    selectedState.value = '';
    selectedCity.value = '';
  }

  @override
  void onClose() {
    houseAddressController.dispose();
    pinCodeController.dispose();
    super.onClose();
  }

  bool isFormValid() {
    return step3FormKey.currentState?.validate() ?? false;
  }
}
