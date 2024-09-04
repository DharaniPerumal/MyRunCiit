import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController moneyController = TextEditingController();
  TextEditingController current_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  int itemCount = 0;
  int selectedContainerIndex = -1; // Initialize to -1 (no selection)
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  var user_id;
  void initState() {
    getuserid();
    super.initState();
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
    });
    print('user_id===>>> $user_id');
  }

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff014282),
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white),),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Change Password",style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold),)],
        ),
        actions: [ShoppingCart()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Password",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Container(
              height: 40,
              child: TextFormField(
                controller: current_password,
                obscureText: _obscureText1,

                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  // hintText: "First Name:",
                  // prefixText: "Current Password",
                  labelText: "Current Password",
                  prefixStyle: TextStyle(color: Colors.grey.shade400,fontSize: 13),
                  labelStyle: TextStyle(color: Colors.grey.shade400,fontSize: 13),
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

                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              "New Password",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
        Container(
          height: 40,
          child: TextFormField(
            controller: new_password,

            keyboardType: TextInputType.name,
            obscureText: _obscureText2,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              // prefixText: "New Password",
              labelText: "New Password",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText2 = !_obscureText2;
                  });
                },
                child: Icon(
                  _obscureText2 ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        )            ,SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              "Confirm New Password",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Container(
              height: 40,
              child: TextFormField(
                controller: confirm_password,
                obscureText: _obscureText3,

                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  // hintText: "First Name:",
                  // prefixText: "Confirm New Password",
                  labelText: "Confirm New Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixStyle: TextStyle(color: Colors.grey.shade400,fontSize: 13),
                  labelStyle: TextStyle(color: Colors.grey.shade400,fontSize: 13),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText3 = !_obscureText3;
                      });
                    },
                    child: Icon(
                      _obscureText3 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade400,
                    ),
                  ),

                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            InkWell(
              onTap: (){
                change_password_api();
              },

              child: Container(
                height: size.height * 0.05,
                color: Color(0xffb41500),
                child: Center(
                    child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
  Future<void> change_password_api() async {
    String url = "$root_web/update_password/${user_id}/${current_password.text}/${new_password.text}/${confirm_password.text}";
    Map data = {
      "old_password": "${current_password.text}",
      "new_password": "${new_password.text}",
      "confirm_new_password": "${confirm_password.text}",
      "user_id": "${user_id}"
    };
    print('map_data ---> ${data}');
    http.Response response =
    await http.post(Uri.parse(url), body: jsonEncode(data));
    print("database connectivity${response.body}");
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    var Message = jsonResponse["Message"];
    print('status$status');
    if (status == "SUCCESS") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
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
                            "${Message}",
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.lightGreen,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Ok', style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 15),),
                          )),),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }else if(status == "FAILED"){
      print('hi---failed....!');
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
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
                            "${Message}",
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.lightGreen,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Ok', style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 15),),
                          )),),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }else{
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Something went wrong...!try again...",
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.lightGreen,
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Ok', style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 15),),
                          )),),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }


}
