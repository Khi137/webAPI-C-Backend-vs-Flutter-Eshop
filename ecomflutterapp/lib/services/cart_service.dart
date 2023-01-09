import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_catalog/models/cart.dart';
import 'package:flutter_catalog/utils/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/product.dart';
import 'package:flutter_catalog/models/api_response.dart';

class CartService {
  static List<Cart> parseCart(String responseBody) {
    var list = json.decode(responseBody) as List<dynamic>;
    List<Cart> products = list.map((model) => Cart.fromJson(model)).toList();
    return products;
  }

//get cart by id
  static Future<List<Cart>> fetchCart(String ID) async {
    HttpOverrides.global = MyHttpOverrides();
    final response = await http.Client().get(Uri.parse('$getCartByIDURL' + ID));
    if (response.statusCode == 200) {
      return compute(parseCart, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not Found');
    } else {
      throw Exception('Can not get cart');
    }
  }

  //add to cart
  static Future AddToCart(String UserId, String ProductId, int Quantity) async {
    HttpOverrides.global = MyHttpOverrides();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode(
        {'userId': UserId, 'productId': ProductId, 'quantity': Quantity});
    final response = await http.Client()
        .post(Uri.parse(addToCartURL), headers: headers, body: msg);
    if (response.statusCode == 200) {
      return "Success";
    } else if (response.statusCode == 404) {
      return "Wrong";
    } else {
      return somethingWentWrong;
    }
  }

  //clear cart
  static Future ClearCart(String UserId) async {
    HttpOverrides.global = MyHttpOverrides();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final response =
        await http.Client().delete(Uri.parse(clearCartURL + UserId));
    if (response.statusCode == 200) {
      return "Success";
    } else if (response.statusCode == 404) {
      return "Wrong";
    } else {
      return somethingWentWrong;
    }
  }

  //update cart
  static Future updateCart(int CartID, int Quantity) async {
    HttpOverrides.global = MyHttpOverrides();
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode({'quantity': Quantity});
    final response = await http.Client().put(
        Uri.parse(updatecartURL + CartID.toString()),
        headers: headers,
        body: msg);
    if (response.statusCode == 200) {
      return "Success";
    } else if (response.statusCode == 404) {
      return "Wrong";
    } else {
      return somethingWentWrong;
    }
  }
}
