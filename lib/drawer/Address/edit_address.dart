import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/final_order.dart';
import 'package:myrunciit/drawer/Address/address_list.dart';
import 'package:myrunciit/drawer/Info/my_info.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var message;

class EditAddress extends StatefulWidget {
  var edit_name,
      edit_phone,
      edit_email,
      edit_address,
      edit_address1,
      edit_country,
      edit_state,
      edit_city,
      edit_zipcode,
      edit_unique_id;

  EditAddress(
      {Key? key,
      required this.edit_name,
      required this.edit_phone,
      required this.edit_email,
      required this.edit_address,
      required this.edit_address1,
      required this.edit_country,
      required this.edit_state,
      required this.edit_city,
      required this.edit_zipcode,
      required this.edit_unique_id})
      : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();

  int itemCount = 0;
  int selectedContainerIndex = -1;
  var user_id;

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  @override
  initState() {
    setState(() {
      nameController.text = widget.edit_name;
      phoneController.text = widget.edit_phone;
      emailController.text = widget.edit_email;
      address1Controller.text = widget.edit_address;
      address2Controller.text = widget.edit_address1;
      countryController.text = widget.edit_country;
      stateController.text = widget.edit_state;
      cityController.text = widget.edit_city;
      zipcodeController.text = widget.edit_zipcode;
    });
    getuserid();
    getstoreid();
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
    });
    print('edit_address_ugdserid===>>> $user_id');
  }

  getsave_edit() async {
    print('widget.edit_unique_idfd----> ${widget.edit_unique_id} user_id ----> ${user_id}');
    final response = await http.post(
      Uri.parse('$root_web/profile/edit_address'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "unique_id": "${widget.edit_unique_id}",
        "user_id": user_id,
        "name": "${nameController.text}",
        "mobile": "${phoneController.text}",
        "email": "${emailController.text}",
        "street_address": "${address1Controller.text}",
        "street_address2": "${address2Controller.text}",
        "zip_code": "${zipcodeController.text}",
        "cities": "${cityController.text}",
        "state": "${stateController.text}",
        "country": " ${countryController.text}"
      }),
    );
    var jsonResponse = jsonDecode(response.body);
    print('edit_json_response$jsonResponse');
    var status = jsonResponse["status"];
    message = jsonResponse["status"];
    print('status_edit_address ===>>> ${status}');
    if (status == "SUCCESS") {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text("${message}")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressList()),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      print("failure${jsonResponse["Message"]}");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text("${message}")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Center(
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Color(0xFF64DD17),
                        color: Colors.lightGreen,

                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('store_id');
    });
    print('edit_user_id ===>>> $user_id');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff014282),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 35,)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Edit Address",style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold))],
        ),
        actions: [ShoppingCart()],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: nameController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("Phone No:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: phoneController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: emailController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("Street Address:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: address1Controller,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("Street Address1:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: address2Controller,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("Country:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: countryController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("State:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: stateController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("City:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: cityController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("Zipcode:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height * 0.04,
                child: TextFormField(
                  controller: zipcodeController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              InkWell(
                onTap: () {
                  print("clicked =====>>>> ");
                  getsave_edit();
                },
                child: Container(
                  height: size.height * 0.05,
                  color: Color(0xffb41500),
                  child: Center(
                      child: Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
