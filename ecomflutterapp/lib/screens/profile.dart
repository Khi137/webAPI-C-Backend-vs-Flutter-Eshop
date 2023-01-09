import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalog/models/user.dart';
import 'package:flutter_catalog/screens/welcome.dart';
import 'package:flutter_catalog/services/user_service.dart';
import 'package:flutter_catalog/utils/constant.dart';
import 'package:flutter_catalog/widgets/appbar_widget.dart';
import 'package:flutter_catalog/widgets/button_widget.dart';
import 'package:flutter_catalog/widgets/numbers_widget.dart';
import 'package:flutter_catalog/widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String? uID;
  ProfileScreen({this.uID});
  @override
  _ProfileScreenState createState() => _ProfileScreenState(uID);
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? uID;
  _ProfileScreenState(this.uID);
  var _Userlogin;
  Future<void> fetchUser() async {
    UserServices.fetchuserbyUsername(widget.uID.toString()).then((value) => {
          setState(() {
            _Userlogin = value;
          })
        });
  }

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(children: [
        // Container(
        //     decoration: BoxDecoration(
        //         image: DecorationImage(
        //   image: AssetImage("assets/images/welcome_bg.png"),
        //   fit: BoxFit.cover,
        // ))),
        ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            _Userlogin != null
                ? ProfileWidget(
                    imagePath: _Userlogin["avatar"].toString() == "null"
                        ? "https://cdn-icons-png.flaticon.com/512/2102/2102647.png"
                        : getimageuserURL + _Userlogin["avatar"].toString(),
                    onClicked: () async {},
                  )
                : ProfileWidget(
                    imagePath:
                        "https://cdn-icons-png.flaticon.com/512/248/248960.png?w=740&t=st=1671804718~exp=1671805318~hmac=af7d4571f5eae13dd3f935339786a0fe629678c53f925c6b827aa0dbd99bee4a",
                    onClicked: () async {},
                  ),
            Center(
                child: ButtonWidget(
              text: 'Log out',
              onClicked: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (route) => false);
              },
            )),
            const SizedBox(height: 24),
            _Userlogin != null
                ? buildName(
                    _Userlogin["fullName"].toString(),
                    _Userlogin["email"].toString(),
                    _Userlogin["phoneNumber"].toString())
                : buildName("Chưa cập nhật", "Loading...", "Chưa cập nhật"),
            const SizedBox(height: 24),
            Center(child: buildUpgradeButton()),
            const SizedBox(height: 10),
            _Userlogin != null
                ? buildAbout(_Userlogin["address"].toString())
                : buildAbout("Chưa cập nhật địa chỉ"),
          ],
        ),
      ]),
    );
  }

  Widget buildName(String fullname, String email, String phonenumber) => Column(
        children: [
          Text(
            fullname == "null" ? "Chưa cập nhật" : fullname,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            phonenumber == "null"
                ? "Contact at: Chưa cập nhật"
                : "Contact at: " + phonenumber,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade Profile',
        onClicked: () {},
      );

  Widget buildAbout(String address) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              address == "null" ? "Chưa cập nhật" : address,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
