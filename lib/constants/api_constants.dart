import 'dart:convert';
import 'package:http/http.dart' as http;
/* -- LIST OF Constants used in APIs -- */

// Example
const String tSecretAPIKey = "cwt_live_b2da6ds3df3e785v8ddc59198f7615ba";

// API for searching State, City, and Country using PinCode


class ApiService {
  final String openCageApiKey;

  ApiService({required this.openCageApiKey});

  Future<Map<String, dynamic>> getLocationDetails(String pincode) async {
    final response = await http.get(
      Uri.parse('https://api.opencagedata.com/geocode/v1/json?q=$pincode&key=$openCageApiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load location details. Please check your internet connection.');
    }
  }
}
