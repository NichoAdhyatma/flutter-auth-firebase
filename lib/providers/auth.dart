import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  Future<void> signUp(String email, String password) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCBCcz_adtPMnOEiJT2QsCjYAh4dfIGSRQ");

    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
            "token": "nicho"
          },
        ),
      );

      var responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw responseData["error"]["message"];
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCBCcz_adtPMnOEiJT2QsCjYAh4dfIGSRQ");

    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
            "token": "nicho"
          },
        ),
      );

      var responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw responseData["error"]["message"];
      }
    } catch (err) {
      rethrow;
    }
  }
}
