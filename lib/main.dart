import 'package:flutter/material.dart';
import 'package:myrunciit/main_screen/main_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

var isLoggedIn;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(child: SplashScreen()),
      debugShowCheckedModeBanner: false,
      // routes: {
      //   '/webview': (context) => ipay88()
      // },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYlOGIN = "login";

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              height: 70,
              width: 300,
              child: Image.asset('asset/logo.png', fit: BoxFit.fill),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    isLoggedIn = sharedPref.getBool(KEYlOGIN);

    Future.delayed(Duration(seconds: 3), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Main_screen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Main_screen()),
        );
      }
    });
  }
}