import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/httpExceptionClass.dart';

class AuthenticationBlueprint with ChangeNotifier {
  String _tokenFromServer;
  DateTime _expiryDateOfToken;
  String _userID;
  Timer _authTimer;

  bool get isAutheticated {
    return token != null;
  }

  String get token {
    if (_expiryDateOfToken != null &&
        _expiryDateOfToken.isAfter(DateTime.now()) &&
        _tokenFromServer != null) {
      return _tokenFromServer;
    }
    return null;
  }

  String get userID {
    return _userID;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAH_L7Q7Qa7A00d-LoFi7vUWsBy9SowWUg');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HTTPExceptionClass(responseData['error']['message']);
      }
      _tokenFromServer = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDateOfToken = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _automaticLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'tokenFromServer': _tokenFromServer,
        'userID': _userID,
        'expiryDateOfToken': _expiryDateOfToken.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryLogInAutomatically() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      final expiryDate =
          DateTime.parse(extractedUserData['_expiryDateOfToken']);
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _tokenFromServer = extractedUserData['tokenFromServer'];
      _userID = extractedUserData['userID'];
      _expiryDateOfToken = expiryDate;
      notifyListeners();
      _automaticLogout();
      return true;
    } else
      return false;
  }

  Future<void> logout() async {
    _tokenFromServer = null;
    _userID = null;
    _expiryDateOfToken = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _automaticLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    var time_remain = _expiryDateOfToken.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: time_remain), logout);
  }
}
