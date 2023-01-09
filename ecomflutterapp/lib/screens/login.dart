import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_catalog/models/user.dart';
import 'package:flutter_catalog/screens/dashboard.dart';
import 'package:flutter_catalog/services/user_service.dart';
import 'package:flutter_catalog/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/routes.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtmail = new TextEditingController();
  TextEditingController txtpass = new TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String test1 = "";
  var _Userlogin;
  Future<void> fetchUser() async {
    UserServices.fetchuserbyUsername(txtmail.text).then((value) => {
          setState(() {
            _Userlogin = value;
            if (_Userlogin['emailConfirmed'] == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email is not confirmed")));
            } else {
              _saveAndRedirectToHome();
            }
          })
        });
  }

  void _loginUser() async {
    var response = await UserServices.login(txtmail.text, txtpass.text);
    if (response == "Wrong") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failed")));
    } else if (response == somethingWentWrong) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failed")));
    } else if (response[1] != null) {
      fetchUser();
    }
  }

  void _saveAndRedirectToHome() async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('userId', _Userlogin['id'].toString());
    await pref.setString('userName', _Userlogin['userName'].toString());
    await pref.setString('ShippingAdress', _Userlogin['address'].toString());
    await pref.setString('ShippingPhone', _Userlogin['phoneNumber'].toString());
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (route) => false);
  }

  bool passenable = true;
  List<Product> products = [];
  String test = "Login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: Form(
        key: formkey,
        child: Stack(children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 36,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/logo_2.png",
                        scale: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      test,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextFormField(
                        controller: txtmail,
                        textAlign: TextAlign.center,
                        validator: (val) =>
                            val!.isEmpty ? 'Invalid Username' : null,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(
                            Icons.person_outline_outlined,
                            color: Color.fromARGB(255, 17, 172, 68),
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(
                              fontSize: 24,
                              color: Color(0xffE0E0E0),
                              fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        )),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextFormField(
                        controller: txtpass,
                        validator: (val) => val!.length < 6
                            ? 'Required at least 6 chars'
                            : null,
                        obscureText: passenable,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.password_outlined,
                            color: Color.fromARGB(255, 17, 172, 68),
                          ),
                          suffix: IconButton(
                              onPressed: () {
                                //add Icon button at end of TextFormField
                                setState(() {
                                  //refresh UI
                                  if (passenable) {
                                    //if passenable == true, make it false
                                    passenable = false;
                                  } else {
                                    passenable =
                                        true; //if passenable == false, make it true
                                  }
                                });
                              },
                              icon: Icon(passenable == true
                                  ? Icons.remove_red_eye
                                  : Icons.password_outlined)),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              fontSize: 24,
                              color: Color(0xffE0E0E0),
                              fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        )),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            _loginUser();
                            // _saveAndRedirectToHome();
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                          shape: StadiumBorder(),
                          backgroundColor: Color(0xff23AA49),
                        ),
                        child: Text("Login")),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
