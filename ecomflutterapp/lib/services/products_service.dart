import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_catalog/utils/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/product.dart';
import 'package:flutter_catalog/models/api_response.dart';

class ProductServices {
  static List<Product> parseProduct(String responseBody) {
    var list = json.decode(responseBody) as List<dynamic>;
    List<Product> products =
        list.map((model) => Product.fromJson(model)).toList();
    return products;
  }

  static parseProductDetail(String responseBody) {
    Map<String, dynamic> data =
        new Map<String, dynamic>.from(json.decode(responseBody));
    return data;
  }

//get all products
  static Future<List<Product>> fetchProducts() async {
    HttpOverrides.global = MyHttpOverrides();
    final response = await http.Client().get(Uri.parse('$productsURL'));
    if (response.statusCode == 200) {
      return compute(parseProduct, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can not get products');
    }
  }

  //get product by id
  static Future fetchProductbyID(String ID) async {
    HttpOverrides.global = MyHttpOverrides();
    final response =
        await http.Client().get(Uri.parse('$productdetailURL' + ID));
    if (response.statusCode == 200) {
      return compute(parseProductDetail, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can not get products');
    }
  }
}
