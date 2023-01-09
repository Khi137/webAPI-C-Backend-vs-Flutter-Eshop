import 'package:flutter/material.dart';
import 'package:flutter_catalog/models/cart.dart';
import 'package:flutter_catalog/services/cart_service.dart';
import 'package:flutter_catalog/services/invoice_service.dart';
import 'package:intl/intl.dart';
import '../models/cart_data.dart';
import '../services/products_service.dart';
import '../services/user_service.dart';
import '../utils/routes.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  final String? uID;
  CartScreen({this.uID});

  @override
  State<CartScreen> createState() => _CartScreenState(uID);
}

class _CartScreenState extends State<CartScreen> {
  String? uID;
  _CartScreenState(this.uID);
  List<Cart> _cartList = [];
  int checkout = 0;
  String phone = "";
  String address = "";
  @override
  void initState() {
    fetchUser();
    super.initState();
    CartService.fetchCart(widget.uID.toString()).then((value) => {
          setState(() {
            _cartList = value;
            ImageProductCart();
          })
        });
  }

  Future<void> fetchUser() async {
    phone = await UserServices.getPhone();
    address = await UserServices.getAdress();
  }

  Future<void> ImageProductCart() async {
    for (int i = 0; i < _cartList.length; i++) {
      ProductServices.fetchProductbyID(_cartList[i].productId.toString())
          .then((value) => {
                setState(() {
                  _cartList[i].image = value['image'];
                  _cartList[i].productName = value['name'];
                  _cartList[i].price = value['price'];
                  checkout += (int.parse(_cartList[i].price.toString()) *
                      int.parse(_cartList[i].quantity.toString()));
                })
              });
    }
  }

  void AddInvoice(String _userID, String shippingphone, String shippingaddress,
      int total) async {
    if (checkout > 0) {
      var response = await InvoiceService.AddInvoice(
          _userID, shippingphone, shippingaddress, total);
      if (response == "Success") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Add Success")));
        ClearCart(_userID);
        Navigator.pushNamed(context, MyRoutes.dashboardRoute);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Add Failed")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Can not checkout")));
    }
  }

  void ClearCart(String _userID) async {
    var response = await CartService.ClearCart(_userID);
    if (response == "Success") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Clear cart")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Clear Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0", "en_US");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cart",
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
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: _cartList.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  item: _cartList[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                    onPressed: () {
                      AddInvoice(uID.toString(), phone.toString(),
                          address.toString(), checkout);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      shape: StadiumBorder(),
                      backgroundColor: Color(0xff23AA49),
                    ),
                    child: Text("Checkout: " +
                        oCcy.format(checkout).toString() +
                        ' VNĐ')),
              )
            ]),
          )
        ],
      ),
    );
  }
}
