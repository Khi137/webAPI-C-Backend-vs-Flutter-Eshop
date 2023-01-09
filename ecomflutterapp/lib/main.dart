
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_catalog/screens/cart.dart';
import 'package:flutter_catalog/screens/login.dart';
import 'package:flutter_catalog/screens/products.dart';
import 'package:flutter_catalog/screens/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/dashboard.dart';
import 'screens/registration.dart';
import 'screens/splash.dart';
import 'screens/product_detail.dart';
import 'screens/welcome.dart';
import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MobileX",
      theme: ThemeData(fontFamily: GoogleFonts.lato().fontFamily),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        MyRoutes.welcomeRoute: (context) => WelcomeScreen(),
        MyRoutes.registrationRoute: (context) => RegistrationScreen(),
        MyRoutes.loginRoute: (context) => LoginScreen(),
        MyRoutes.dashboardRoute: (context) => DashboardScreen(),
        MyRoutes.productsRoute: (context) => ProductsScreen(),
        MyRoutes.productdetailRoute: (context) => ProductDetailScreen(),
        MyRoutes.cartRoute: (context) => CartScreen(),
        MyRoutes.profileRoute: (context) => ProfileScreen(),
      },
    );
  }
  
}
 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}