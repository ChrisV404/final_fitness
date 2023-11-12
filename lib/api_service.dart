import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'constants.dart';
import '../user_model.dart';

class ApiService {
  
  // Login user
  Future<User?> login(email, password) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              <String, String>{"email": email, "password": password}));
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        log(jsonResponse);
        return userFromJson(jsonResponse);
      } else {
        log('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  // Register user
  Future<String?> register(firstName, lastName, email, password) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.registerEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
            "tracked": {}
          }));
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        log(jsonResponse);
        return jsonResponse;
      } else {
        log('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
