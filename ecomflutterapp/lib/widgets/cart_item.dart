import 'package:flutter/material.dart';
import 'package:flutter_catalog/models/cart.dart';
import 'package:intl/intl.dart';
import '../models/cart_data.dart';
import '../utils/constant.dart';
import 'dart:math';

class CartItemWidget extends StatefulWidget {
  final Cart item;
  const CartItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int itemCount = 0;
  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0", "en_US");
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.item.image != null
              ? Expanded(
                  child: Image.network(
                  getimageproductURL + widget.item.image.toString(),
                  width: 80,
                  height: 80,
                ))
              : Expanded(
                  child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/248/248960.png?w=740&t=st=1671804718~exp=1671805318~hmac=af7d4571f5eae13dd3f935339786a0fe629678c53f925c6b827aa0dbd99bee4a",
                  width: 60,
                  height: 60,
                )),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.productName.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                    widget.item.price != null
                        ? "Unit price: " +
                            oCcy
                                .format(int.parse(widget.item.price.toString()))
                                .toString()
                        : "Loading....",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 8,
                ),
                Text(
                    widget.item.price != null
                        ? "Total: " +
                            oCcy
                                .format((int.parse(
                                        widget.item.price.toString()) *
                                    int.parse(widget.item.quantity.toString())))
                                .toString()
                        : "Calculating...",
                    style: TextStyle(
                        color: Color(0xffFF324B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Qty: " + widget.item.quantity.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
