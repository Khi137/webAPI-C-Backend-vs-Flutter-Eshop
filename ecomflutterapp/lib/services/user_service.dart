import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_catalog/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utils/constant.dart';
import 'package:http/http.dart' as http;

class UserServices {
//login
  static Future login(String username, String password) async {
    HttpOverrides.global = MyHttpOverrides();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({'username': username, 'password': password});
    final response = await http.Client()
        .post(Uri.parse(loginURL), headers: headers, body: msg);
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      return "Wrong";
    } else {
      return somethingWentWrong;
    }
  }

//register
  static Future register(String username, String email, String password,
      String fullname, String address) async {
    HttpOverrides.global = MyHttpOverrides();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({
      'username': username,
      'email': email,
      'password': password,
      'fullname': fullname,
      'address': address
    });
    final response = await http.Client()
        .post(Uri.parse(registerURL), headers: headers, body: msg);
    if (response.statusCode == 200) {
      return "Success";
    } else if (response.statusCode == 404) {
      return "Wrong";
    } else {
      return somethingWentWrong;
    }
  }

//get user by username
  static parseUserByUserName(String responseBody) {
    Map<String, dynamic> data =
        new Map<String, dynamic>.from(json.decode(responseBody));
    return data;
  }

//get user by username
  static Future fetchuserbyUsername(String username) async {
    HttpOverrides.global = MyHttpOverrides();
    final response =
        await http.Client().get(Uri.parse('$getUserURL' + username));
    if (response.statusCode == 200) {
      return compute(parseUserByUserName, response.body);
    } else if (response.statusCode == 404) {
      return "Wrong";
    } else {
      return somethingWentWrong;
    }
  }

  //get  with reference
  static Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('userId') ?? '';
  }

  static Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('userName') ?? '';
  }

  static Future<String> getPhone() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('ShippingPhone') ?? '';
  }

  static Future<String> getAdress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('ShippingAdress') ?? '';
  }

}
