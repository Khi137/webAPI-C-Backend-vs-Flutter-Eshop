import 'package:flutter/material.dart';
import 'package:flutter_catalog/models/cart.dart';
import 'package:flutter_catalog/services/cart_service.dart';
import 'package:flutter_catalog/services/products_service.dart';
import 'package:flutter_catalog/utils/constant.dart';
import 'package:flutter_catalog/utils/routes.dart';
import 'package:intl/intl.dart';

import '../services/user_service.dart';
import 'cart.dart';
import 'dashboard.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? proID;
  ProductDetailScreen({this.proID});
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState(proID);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? proID;
  _ProductDetailScreenState(this.proID);
  int itemCount = 1;
  var _proList;
  String userID = "";
  String userName = "";
  Future<void> fetchIdUser() async {
    userID = await UserServices.getUserId();
    userName = await UserServices.getUserName();
  }

  Future<void> fetchdetail() async {
    ProductServices.fetchProductbyID(widget.proID.toString()).then((value) => {
          setState(() {
            _proList = value;
          })
        });
  }

  void UpdateCart(int _cartID, int Quantity) async {
    var response = await CartService.updateCart(_cartID, Quantity);
    if (response == "Success") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update Success")));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update Failed")));
    }
  }

  void addCart(String _userID, String productID, int Quantity) async {
    var response = await CartService.AddToCart(_userID, productID, Quantity);
    if (response == "Success") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Add Success")));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Add Failed")));
    }
  }

  void addToCart(String _userID, String productID, int Quantity) async {
    int exist = -1;
    CartService.fetchCart(_userID.toString()).then((value) => {
          setState(() {
            _cartList = value;
            for (int i = 0; i < _cartList.length; i++) {
              if (_cartList[i].productId.toString() == productID.toString()) {
                exist = i;
              }
            }
            if (exist == -1) {
              addCart(_userID, productID, Quantity);
            } else {
              UpdateCart(int.parse(_cartList[exist].id.toString()),
                  int.parse(_cartList[exist].quantity.toString()) + Quantity);
            }
          })
        });
  }

  List<Cart> _cartList = [];
  @override
  void initState() {
    fetchdetail();
    fetchIdUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0", "en_US");
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () {
          return fetchdetail();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffF3F5F7),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 140.0))),
                child: Column(children: [
                  SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            "assets/images/back_icon.png",
                            width: 44,
                            height: 44,
                          ),
                        ),
                        Image.asset(
                          "assets/images/search_icon.png",
                          width: 44,
                          height: 44,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.center,
                    widthFactor: 0.6,
                    child: Container(
                      child: _proList != null
                          ? Image.network(
                              getimageproductURL + _proList["image"].toString(),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/ginger.png",
                              width: 32,
                              height: 32,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                ]),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            _proList != null
                                ? _proList["name"].toString()
                                : "Loading...",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            // InkWell(
                            //   onTap: (() {
                            //     setState(() {
                            //       itemCount++;
                            //     });
                            //   }),
                            //   child: Image.asset(
                            //     "assets/images/add_icon.png",
                            //     width: 32,
                            //     height: 32,
                            //   ),
                            // ),

                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (itemCount > 1) itemCount--;
                                });
                              },
                              child: Image.asset(
                                "assets/images/remove_icon.png",
                                width: 32,
                                height: 32,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "$itemCount",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: (() {
                                setState(() {
                                  itemCount++;
                                });
                              }),
                              child: Image.asset(
                                "assets/images/add_icon.png",
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                        _proList != null
                            ? oCcy
                                    .format(
                                        int.parse(_proList["price"].toString()))
                                    .toString() +
                                " VNĐ"
                            : "Loading....",
                        style: TextStyle(
                            color: Color(0xffFF324B),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      _proList != null
                          ? _proList["description"].toString()
                          : "Loading...",
                      style: TextStyle(
                          color: Color(0xff979899),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        _itemKeyPointsView(
                            "assets/images/organic.png", "50%", "Promotion"),
                        SizedBox(
                          width: 8,
                        ),
                        _itemKeyPointsView("assets/images/expiration.png",
                            "1 Year", "Warranty")
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        _itemKeyPointsView(
                            "assets/images/reviews.png", "4.8", "Reviews"),
                        SizedBox(
                          width: 8,
                        ),
                        _itemKeyPointsView(
                            "assets/images/calories.png", "0%", "Installment")
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: ElevatedButton(
                          onPressed: () {
                            addToCart(userID, proID.toString(), itemCount);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                            shape: StadiumBorder(),
                            backgroundColor: Color(0xff23AA49),
                          ),
                          child: Text("Add to cart")),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemKeyPointsView(String imagePath, String title, String desc) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: Color(0xffF1F1F5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff23AA49)),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(desc,
                    style: TextStyle(fontSize: 14, color: Color(0xff979899))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
