import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/drawer/Info/change_password.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var first_name;
var last_name;
var email;
var phone;
var address1;
var address2;
var country;
var state;
var city;
var zip;

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  TextEditingController moneyController = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zip = TextEditingController();
  int itemCount = 0;
  int selectedContainerIndex = -1;
  var user_id;

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  @override
  void initState() {
    setState(() {
      loaddata();

      myinfo_api_connect();
    });
    super.initState();
  }
  Future<void> myinfo_api_connect() async {
    await getuserid();

    String url = "$root_web/profile/info/$user_id";
    print("urlurl$url");
    dynamic response = await http.get(Uri.parse(url));
    print('myinfo_connect${response.body}');
    print(response.statusCode);
    print(response);

    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];

    if (status == "SUCCESS") {
      var user_info = jsonResponse["Response"]["user_info"];
      if (user_info.isNotEmpty) {
        first_name.text = user_info[0]["username"];
        last_name.text = user_info[0]["surname"];
        email.text = user_info[0]["email"];
        phone.text = user_info[0]["phone"];
        address1.text = user_info[0]["address1"];
        address2.text = user_info[0]["address2"];
        country.text = user_info[0]["country"];
        state.text = user_info[0]["state"];
        city.text = user_info[0]["city"];
        zip.text = user_info[0]["zip"];
        print(first_name.text);
      } else {

      }
    } else {

    }

    print('status$status');
  }


  loaddata() async {
    await getuserid();
  }
  getuserid() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
    });
    print('user_id===>>> $user_id');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50.0,
          backgroundColor: Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 22.0,
            ),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Edit Profile",
                  style:
                      TextStyle(color:Colors.white,fontSize: 15.0, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [ShoppingCart()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: first_name,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "First Name: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "First Name: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: last_name,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "Last Name: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "Last Name: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: email,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "Email: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "Email: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "Phone: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "Phone: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: address1,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "Address1: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "Address1: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: size.height * 0.01,
                // ),
                Container(
                  height: 30,
                  child: TextFormField(
                    controller: address2,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "Address2: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "Address2: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),

                Container(
                  height: 30,
                  child: TextFormField(
                    controller: country,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "Country: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "Country: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),

                Container(
                  height: 30,
                  child: TextFormField(
                    controller: state,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "State: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "State: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),

                Container(
                  height: 30,
                  child: TextFormField(
                    controller: city,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "City: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "City: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),

                Container(
                  height: 30,
                  child: TextFormField(
                    controller: zip,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                      ),
                      prefixText: "Zipcode: ",
                      prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      labelText: "Zipcode: ",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    update_myinfo_api();
                  },
                  child: Container(
                    height: size.height * 0.05,
                    color: Color(0xffb41500),
                    child: const Center(
                        child: Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  width: size.width,
                  color: Colors.transparent,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Change Password ?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffb41500)),
                          textAlign: TextAlign.right,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> update_myinfo_api() async {
    String url = "$root_web/registration/update_info";
    Map data = {
      "firstname": "${first_name.text}",
      "lastname": "${last_name.text}",
      "email": "${email.text}",
      "address1": "${address1.text}",
      "address2": "${address2.text}",
      "phone": "${phone.text}",
      "zip": "${zip.text}",
      "city": "${city.text}",
      "state": "${state.text}",
      "country": "${country.text}",
      "user_id": "$user_id"
    };
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    print("database connectivity${response.body}");
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    var Message = jsonResponse["Message"];
    print('status$status');
    if (status == "SUCCESS") {
      Navigator.pop(context);

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
                            "${Message}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.lightGreen,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    } else if (status == "FAILED") {
      print('hi---failed....!');
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
                            "${Message}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.lightGreen,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    } else {
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
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.lightGreen,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          )),
                        ),
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
