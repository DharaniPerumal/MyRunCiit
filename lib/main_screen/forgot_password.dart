
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/roots/roots.dart';

class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      print('Email: $email');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

       return WillPopScope(
         onWillPop: () async {
           Navigator.pop(context);        return Future.value(true);
         },

         child: Scaffold(

            body: Stack(
              children: [
                Container(
                  height: size.height*0.45,
                  width: size.width,

                  decoration: BoxDecoration(
                      color:Color(0xff004387),

                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(70.0),
                        bottomRight: Radius.circular(70.0),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 50, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [

                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          },

                            icon: Icon(Icons.keyboard_arrow_left, size: 30,color: Colors.white,),

                          ),

                          Text("Forgot Your Password ?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                          SizedBox(height: 50,),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Center(
                          child: Container(
                            width: 200,
                            child: Image.asset('asset/unit-1.png',fit: BoxFit.fill,),
                            // image: DecorationImage(image: AssetImage('asset/unit-1.png')),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(120, 150, 120, 150),
                //   child: Image(image: AssetImage('asset/logo.png')),
                // ),


                Padding(
                  padding: EdgeInsets.only(top: size.height*0.27),
                  child: Form(
                    key: _formKey,
                    child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        height: size.height*0.40,
                        width: size.width,
                        // color: Colors.cyan,
                        decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color and opacity
                              spreadRadius: 1, // Spread radius
                              blurRadius: 1, // Blur radius
                              offset: Offset(0, 1), // Offset from the box
                            ),
                          ],),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
                          child: Column(

                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text("Do not worry, you will receice an email with instruction to reset your password. Please enter your login email.", style: TextStyle(fontSize: 15),),
                                  SizedBox(height: 8,),
                                  Container(
                                    height: size.height*0.05,

                                    child: TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
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
                                        hintText: 'Email ID',
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your email';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height*0.03),
                              InkWell(
                                onTap: () async {
                                  print('forgot_password');
                                  String url = "$root_web/login/forget";
                                  Map data = {"email": "${_emailController.text}"};
                                  http.Response response =
                                      await http.post(Uri.parse(url), body: jsonEncode(data));
                                  print("forgot_connect${response.body}");
                                  print(response.statusCode);
                                  print(response);
                                  var jsonResponse = jsonDecode(response.body);
                                  var status = jsonResponse["status"];//Message
                                  print('status$status');
                                  if (status == "SUCCESS") {
                                    Fluttertoast.showToast(
                                        msg: '${jsonResponse["Message"]}',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Color(0xff014282),
                                        textColor: Colors.white,
                                        fontSize: 15,
                                        webPosition: "center");
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => ProductScreen()));
                                  } else {
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
                                                          "Please fill details!",
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
                                },
                                child: Container(
                                  height: size.height*0.05,
                                  width: size.width*0.7,
                                  color: Color(0xFFc40001),
                                  child: Center(child: Text("Continue",style: TextStyle(color: Colors.white, fontSize: 15),)),
                                ),
                              ),
                          ]),
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
                    // color: Colors.white,
                    height: size.height*0.08,
                    width: size.width,
                    decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0)

                    )),
                    child:
                    Center(
                      child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text( "Back",
                        style: TextStyle(color: Colors.blue, fontSize: 20),)),
                    ),

                  ),
                ),
              ],
            ),
          ),
       );
  }
}
