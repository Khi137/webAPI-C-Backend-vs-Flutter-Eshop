import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalog/screens/cart.dart';
import 'package:flutter_catalog/screens/product_detail.dart';
import 'package:flutter_catalog/screens/profile.dart';
import 'package:flutter_catalog/services/user_service.dart';
import 'package:flutter_catalog/utils/routes.dart';
import '../models/product.dart';
import '../services/products_service.dart';
import '../utils/constant.dart';
import '../widgets/product_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Product> _proList = [];
  String userID = "";
  String userName = "";
  @override
  void initState() {
    fetchIdUser();
    super.initState();
    ProductServices.fetchProducts().then((value) => {
          setState(() {
            _proList = value;
          })
        });
  }

  Future<void> fetchIdUser() async {
    userID = await UserServices.getUserId();
    userName = await UserServices.getUserName();
  }

  var index = 0;
  var index2 = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 36,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                uID: userName,
                              ))),
                  child: Expanded(
                    child: Image.asset(
                      "assets/images/user.png",
                      scale: 3.6,
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello",
                            style: TextStyle(
                                color: Color(0xff979899),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            userName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                          color: Color(0xffF3F5F7),
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                          uID: userID,
                                        ))),
                            child: Icon(
                              CupertinoIcons.shopping_cart,
                              color: Color(0xff23AA49),
                              size: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                          uID: userID,
                                        ))),
                            child: Text(
                              "My Cart",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffF3F5F7),
                    borderRadius: BorderRadius.all(Radius.circular(24))),
                child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Category",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xff979899),
                          fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.all(16),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: Color(0xff23AA49),
                      ),
                    )),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              "assets/images/banner_chrs.png",
              scale: 2.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _seeAllView(context, "Categories"),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    _categoriesView("assets/images/ness.png", "Accessory"),
                    _categoriesView("assets/images/tablet.png", "Tablet"),
                    _categoriesView("assets/images/laptop.png", "Laptop"),
                    _categoriesView("assets/images/phone.png", "Phone")
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                _seeAllView(context, "Best Selling"),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _proList != null && _proList.length > 0
                          ? ProductCardWidget(
                              imagePath:
                                  getimageproductURL + '${_proList[0].image}',
                              name: '${_proList[0].name}',
                              price: '${_proList[0].price}',
                              onTapCallback: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                              proID: '${_proList[0].id}',
                                            )));
                              },
                            )
                          : ProductCardWidget(
                              imagePath:
                                  "https://cdn-icons-png.flaticon.com/512/248/248960.png?w=740&t=st=1671804718~exp=1671805318~hmac=af7d4571f5eae13dd3f935339786a0fe629678c53f925c6b827aa0dbd99bee4a",
                              name: "Bell Pepper Red",
                              price: "1kg, 4\$",
                              onTapCallback: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.productdetailRoute);
                              }),
                    ),
                    Expanded(
                      child: _proList != null && _proList.length > 0
                          ? ProductCardWidget(
                              imagePath: getimageproductURL +
                                  '${_proList[index2].image}',
                              name: '${_proList[1].name}',
                              price: '${_proList[1].price}',
                              onTapCallback: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                              proID: '${_proList[1].id}',
                                            )));
                              },
                            )
                          : ProductCardWidget(
                              imagePath:
                                  "https://cdn-icons-png.flaticon.com/512/248/248960.png?w=740&t=st=1671804718~exp=1671805318~hmac=af7d4571f5eae13dd3f935339786a0fe629678c53f925c6b827aa0dbd99bee4a",
                              name: "Bell Pepper Red",
                              price: "1kg, 4\$",
                              onTapCallback: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.productdetailRoute);
                              }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Widget _seeAllView(BuildContext context, String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      InkWell(
        onTap: () {
          Navigator.pushNamed(context, MyRoutes.productsRoute);
        },
        child: Text(
          "See All",
          style: TextStyle(
              fontSize: 14,
              color: Color(0xff23AA49),
              fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}

Widget _categoriesView(String imagePath, String catName) {
  return Expanded(
    flex: 1,
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 32,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              imagePath,
              scale: 4.0,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          catName,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
        )
      ],
    ),
  );
}
