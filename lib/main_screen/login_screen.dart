
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/main_screen/forgot_password.dart';
import 'package:myrunciit/main_screen/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/main_screen/sub_categories/sub_category_1.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';
var status, first_name1, useremail, usermobilenumber, Storeid, user_id, user_wallet;

FocusNode email_id_focus = FocusNode();
FocusNode password_focus = FocusNode();

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText1 = true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Future<Map<String, dynamic>> authenticate(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print('responsee ==== >...');
    final response = await http.post(
      Uri.parse('$root_web/login/do_login'),
      body: {
        "action" : "login",
        "email" : "${email}",
        "password" : "${password}"
      },
    );
    print('responsee ==== >...1');
    print('responsee ==== >.${response.statusCode}');
    if (response.statusCode == 200) {
      print('responsee==== > ${response.body}');
      return json.decode(response.body);
    } else {
      print('responsee ==== > ${response.body}');
      throw Exception('Failed to authenticate');
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text('Are you sure want to exit?',style: TextStyle(color: Colors.black, fontSize: 18.0),)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.10,
                  width: MediaQuery.of(context).size.width * 0.20,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(child: Text('No',  style: TextStyle(color: Colors.white),)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop(); // This will close the app
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.10,
                  width: MediaQuery.of(context).size.width * 0.20,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  void _submitForm() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(SplashScreenState.KEYlOGIN, true);
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    );
    print('print1');
    if (_formKey.currentState!.validate()) {
      print('print2');

      String email = _emailController.text;
      String password = _passwordController.text;
      if (email.isEmpty && password.isEmpty) {
        print('print3');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return  AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please fill the fields",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Ok',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 15),),
                        )),),
                    ),
                  )
                ],
              ),
            );
          },
        );
        return;
      }
      else if (email.isEmpty || !emailRegExp.hasMatch(email) ) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Invalid email address",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Ok',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 15),),
                        )),),
                    ),
                  )
                ],
              ),
            );
          },
        );
        return;
      }
      else if (email.isEmpty && password.isNotEmpty ) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please enter your Email ID",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Ok',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 15),),
                        )),),
                    ),
                  )
                ],
              ),
            );
          },
        );
        return;
      }
      else if (email.isEmpty || !emailRegExp.hasMatch(email)||password.isEmpty ) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please enter your Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Ok',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 15),),
                        )),),
                    ),
                  )
                ],
              ),
            );
          },
        );
        return;
      }
      else if (email.isEmpty || !emailRegExp.hasMatch(email)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please enter valid email address",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Ok',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 15),),
                        )),),
                    ),
                  )
                ],
              ),
            );
          },
        );
        return;
      }
      else if (password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please enter your Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Ok',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 15),),
                        )),),
                    ),
                  )
                ],
              ),
            );
          },
        );
        return;
      }
      try {
        String url = "$root_web/login/do_login";
        Map data = {"action": "login", "email": "${email}", "password": "${password}"};
        print('data=====> $data');
        http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
        print("database connectivity${response.body}");
        print(response.statusCode);
        print(response);
        var jsonResponse = jsonDecode(response.body);
        status = jsonResponse["status"];
        print('status$status');
        print('successfully login...!$first_name1');
        if (status == "SUCCESS") {
          print('successfully login...!$first_name1');
          Fluttertoast.showToast(
              msg: 'Login Successfully...!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Color(0xff014282),
              textColor: Colors.white,
              fontSize: 15,
              webPosition: "center");

          first_name1 = jsonResponse["Response"]["first_name"];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('first_name', '${first_name1}');


          user_id = jsonResponse["Response"]["id"];
          await prefs.setString('store_id', '${user_id}');

          user_id = jsonResponse["Response"]["id"];
          await prefs.setString('user_id', '${user_id}');
          print('userid>>>>$user_id');

          useremail = jsonResponse["Response"]["email_id"];
          await prefs.setString('email_id', '${useremail}');
          print('useremail>>>>$useremail');

          usermobilenumber = jsonResponse["Response"]["mobile_number"];
          await prefs.setString('phone', '${usermobilenumber}');

          user_wallet = jsonResponse["Response"]["wallet"];
          await prefs.setString('wallet', '${user_wallet}');
          print('user_wallet>>>>${user_wallet}');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductScreen()));
        }
        else {
          print('login failed...!');
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Invalid Username or Password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.lightGreen,
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('Ok',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 15),),
                              )),),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        }

      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(

          body: Stack(
            children: [
              Container(
                height: size.height*0.45,
                width: size.width,
                decoration: BoxDecoration(color: Color(0xff004387),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 40, 0, 0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Let's start with Login!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),textAlign: TextAlign.start,),
                    SizedBox(height: 50,),
                    Center(
                      child: Container(
                        width: 200,
                        child: Image.asset('asset/unit-1.png',fit: BoxFit.fill,),
                      ),
                    )
                  ],
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: size.height*0.27),
                child: Form(
                  key: _formKey,
                  child:
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      height: size.height*0.35,
                      width: size.width,
                      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color and opacity
                            spreadRadius: 1, // Spread radius
                            blurRadius: 1, // Blur radius
                            offset: Offset(0, 3), // Offset from the box
                          ),
                        ],),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                  SizedBox(height: size.height*0.01),
                                  Container(
                                    height: size.height * 0.045,
                                    child: TextFormField(
                                      focusNode: email_id_focus,
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      cursorColor: Colors.black, // Set the cursor color
                                      decoration: InputDecoration(
                                        border: InputBorder.none, // Remove the default border
                                        focusedBorder: OutlineInputBorder( // Add a border when focused
                                          borderSide: BorderSide(color: Colors.grey.shade300), // Set the border color
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        enabledBorder: OutlineInputBorder( // Add an enabled border (for unfocused state)
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10), // Adjust content padding
                                        hintText: 'Email Id',
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                      onFieldSubmitted: (value){
                                        FocusScope.of(context).requestFocus(password_focus);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height*0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Password",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                  SizedBox(height: size.height*0.01),
                                  Container(
                                    height: size.height*0.045,
                                    child: TextFormField(
                                      focusNode: password_focus,
                                      controller: _passwordController,
                                      obscureText: _obscureText1,
                                      keyboardType: TextInputType.emailAddress,
                                      cursorColor: Colors.black, // Set the cursor color
                                      decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText1 = !_obscureText1;
                                            });
                                          },
                                          child: Icon(
                                            _obscureText1 ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),

                                        border: InputBorder.none, // Remove the default border
                                        focusedBorder: OutlineInputBorder( // Add a border when focused
                                          borderSide: BorderSide(color: Colors.grey.shade300), // Set the border color
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        enabledBorder: OutlineInputBorder( // Add an enabled border (for unfocused state)
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        // Adjust content padding
                                        hintText: 'Enter your Password',
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height*0.02),
                              GestureDetector(
                                onTap: _submitForm,
                                child: Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.7,
                                  color: Color(0xFFc40001),
                                  child: Center(

                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Forgotpassword()),
                                );
                              }, child: Text("Forgot Password?", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),))                  ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Stack(
            children: [
              Container(
                color: Color.fromRGBO(4, 68, 132, 3),
                height: size.height*0.09, // Adjust the height as needed
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Container(
                  height: size.height*0.08,
                  width: size.width,
                  decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0)

                  )),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "I don't have an account",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      }, child: Text( "Sign up.",
                        style: TextStyle(color: Colors.blue, fontSize: 13,fontWeight: FontWeight.bold),))
                    ],
                  ),

                ),
              ),
            ],
          ),
        ));
  }
}
