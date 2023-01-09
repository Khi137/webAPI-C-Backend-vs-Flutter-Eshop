import 'dart:convert';
import 'dart:io';
import 'package:flutter_catalog/utils/constant.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class InvoiceService {
  //add Invoice
  static Future AddInvoice(String userId, String shippingPhone,
      String shippingAddress, int total) async {
    HttpOverrides.global = MyHttpOverrides();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({
      'userId': userId,
      'shippingPhone': shippingPhone,
      'shippingAddress': shippingAddress,
      'total': total
    });
    final response = await http.Client()
        .post(Uri.parse(addInvoiceURL), headers: headers, body: msg);
    if (response.statusCode == 200) {
      return "Success";
    } else if (response.statusCode == 404) {
      return "Wrong";
    } else {
      return somethingWentWrong;
    }
  }
}
