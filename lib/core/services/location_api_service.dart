import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationApiService {
  static const String _baseUrl =
      'https://countriesnow.space/api/v0.1/countries';
  static const countriesStateURL =
      'https://countriesnow.space/api/v0.1/countries/states';
  static const cityURL =
      'https://countriesnow.space/api/v0.1/countries/state/cities/q?country';

  Future<List<String>> fetchCountries() async {
    try {
      var url = Uri.parse(_baseUrl);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          final List<dynamic> countriesJson = data['data'];
          return countriesJson
              .map((json) => json['country'] as String)
              .toList();
        } else {
          throw Exception('Failed to load countries: ${data['msg']}');
        }
      } else {
        throw Exception(
            'Failed to load countries: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  Future<List<String>> fetchStates(String countryName) async {
    try {
      var url = Uri.parse(countriesStateURL);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          final List<dynamic> countryData = data['data'];
          final List<dynamic> statesData = countryData.firstWhere(
              (element) => element['name'] == countryName)['states'];
          return statesData.map((state) => state['name'] as String).toList();
        } else {
          throw Exception('Failed to load states: ${data['msg']}');
        }
      } else {
        throw Exception('Failed to load states: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load states: $e');
    }
  }

  Future<List<String>> fetchCities(
      {required String country, required String state}) async {
    try {
      var url = Uri.parse("$cityURL=$country&state=$state");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          return List<String>.from(data["data"].map((x) => x));
        } else {
          throw Exception('Failed to load cities: ${data['msg']}');
        }
      } else {
        throw Exception('Failed to load cities: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }
}
