import 'package:flutter/material.dart';
import 'package:flutter_catalog/screens/product_detail.dart';
import 'package:flutter_catalog/services/products_service.dart';
import '../models/api_response.dart';
import '../models/product_data.dart';
import '../utils/constant.dart';
import '../utils/routes.dart';
import '../widgets/product_card.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'dart:convert';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _proList = [];
  @override
  void initState() {
    super.initState();
    ProductServices.fetchProducts().then((value) => {
          setState(() {
            _proList = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Products",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            "assets/images/back_icon.png",
            scale: 2.2,
          ),
        ),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            mainAxisExtent: 225,
          ),
          itemBuilder: (context, index) {
            Product prod = _proList[index];
            return ProductCardWidget(
              imagePath: getimageproductURL + '${prod.image}',
              name: '${prod.name}',
              price: '${prod.price}',
              onTapCallback: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                              proID: '${prod.id}',
                            )));
              },
            );
          },
          itemCount: _proList.length,
        ),
      ),
    );
  }
}
