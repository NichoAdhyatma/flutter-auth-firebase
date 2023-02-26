import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String idToken = "", userId = "";
  DateTime? expiredIn;

  String tempidToken = "", tempuserId = "";
  DateTime? tempexpiredIn;

  Timer? authTimer;

  Future<void> tempData() async {
    idToken = tempidToken;
    userId = tempuserId;
    expiredIn = tempexpiredIn;
    final sharedPref = await SharedPreferences.getInstance();
    final authTemp = json.encode(
      {
        'token': tempidToken,
        'userId': tempuserId,
        'expired': tempexpiredIn!.toIso8601String(),
      },
    );

    sharedPref.setString('authData', authTemp);
    autoLogout();
    notifyListeners();
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (idToken.isNotEmpty && expiredIn!.isAfter(DateTime.now())) {
      return idToken;
    } else {
      return null;
    }
  }

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

      tempidToken = responseData["idToken"];
      tempuserId = responseData["localId"];
      tempexpiredIn = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
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

      tempidToken = responseData["idToken"];
      tempuserId = responseData["localId"];
      tempexpiredIn = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
    } catch (err) {
      rethrow;
    }
  }

  void logout() async {
    userId = '';
    idToken = '';
    expiredIn = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();

    notifyListeners();
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer!.cancel();
    }
    final expired = tempexpiredIn!.difference(DateTime.now()).inSeconds;

    authTimer = Timer(
      Duration(seconds: expired),
      logout,
    );
  }

  Future<bool> autoLogin() async {
    final sharedpref = await SharedPreferences.getInstance();
    if (!sharedpref.containsKey('authData')) {
      return false;
    }

    final authData = json.decode(sharedpref.get('authData').toString())
        as Map<String, dynamic>;
    final expiredTemp = DateTime.parse(authData["expired"]);

    if (expiredTemp.isBefore(DateTime.now())) {
      return false;
    }

    idToken = authData["token"];
    userId = authData["userId"];
    expiredIn = expiredTemp;

    notifyListeners();
    return true;
  }
}
