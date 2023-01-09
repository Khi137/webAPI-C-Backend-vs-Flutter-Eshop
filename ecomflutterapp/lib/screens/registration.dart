import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_catalog/services/user_service.dart';
import 'package:flutter_catalog/utils/constant.dart';
import '../utils/routes.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool passenable = true;
  TextEditingController txtmail = new TextEditingController();
  TextEditingController txtusername = new TextEditingController();
  TextEditingController txtphonenumber = new TextEditingController();
  TextEditingController txtfullname = new TextEditingController();
  TextEditingController txtpass = new TextEditingController();
  TextEditingController txtaddress = new TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void _register() async {
    var response = await UserServices.register(txtusername.text, txtmail.text,
        txtpass.text, txtfullname.text, txtaddress.text);
    if (response == somethingWentWrong) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please check your input")));
    } else if (response == "Wrong") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please check your input")));
    } else if (response == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Success Register, Please confirm your email")));
      Navigator.pushNamed(context, MyRoutes.loginRoute);
    }
  }

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
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "Registration",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: txtmail,
                        validator: (val) =>
                            val!.isEmpty ? 'Invalid Gmail' : null,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          labelText: "Gmail",
                          prefixIcon: Icon(
                            Icons.mail_outline_outlined,
                            color: Color.fromARGB(255, 17, 172, 68),
                          ),
                          hintText: "Gmail",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xffE0E0E0),
                              fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: txtusername,
                        validator: (val) =>
                            val!.isEmpty ? 'Invalid Username' : null,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize: 16,
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
                              fontSize: 16,
                              color: Color(0xffE0E0E0),
                              fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        )),
                  ),
                  SizedBox(
                    height: 15,
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
                            fontSize: 16,
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
                              fontSize: 16,
                              color: Color(0xffE0E0E0),
                              fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        )),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          _register();
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        shape: StadiumBorder(),
                        backgroundColor: Color(0xff23AA49),
                      ),
                      child: Text("Confirmation")),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "When you click on “Confirmation”, you agree to all  ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xffA9A9AA),
                            fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(
                              text: "terms of use",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff5D5FEF))),
                        ],
                      ),
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
