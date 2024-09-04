import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

var user_id, Message, sesion_msg;

class _AddAddressState extends State<AddAddress> {
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

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  // get_add_address() async {
  //   final response = await http.post(
  //     Uri.parse('$root_web/profile/add_address'),
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode({
  //       "user_id": user_id,
  //       "name": "${nameController.text}",
  //       "mobile": "${phoneController.text}",
  //       "email": "${emailController.text}",
  //       "street_address": "${address1Controller.text}",
  //       "street_address2": "${address2Controller.text}",
  //       "zip_code": "${zipcodeController.text}",
  //       "cities": "${cityController.text}",
  //       "state": "${stateController.text}",
  //       "country" :"${countryController.text}"
  //     }),
  //   );
  //   var jsonResponse = jsonDecode(response.body);
  //   print('status_add_data_response ===>>> ${response}');
  //   print('status_add_data_response ===>>> ${jsonResponse}');
  //   var status = jsonResponse["status"];
  //   var sesion_msg = jsonResponse["message"];
  //   print('status_add_data ===>>> ${status}');
  //   print('status_add_data_message ===>>> ${sesion_msg}');
  //   if (status == "SUCCESS") {
  //     print('status_add_data ===>>>');
  //       Navigator.pop(context);
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Center(child: Text('$sesion_msg')),
  //         actions: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context).pop(false);
  //                 },
  //                 child: Center(
  //                   child: Container(
  //                     width: 100,
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Colors.lightGreen,
  //                       border: Border.all(color: Colors.white),
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     child: Center(child: Text('Ok',  style: TextStyle(color: Colors.white),)),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: 7,),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }else{
  //     Navigator.pop(context);
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Center(child: Text('$sesion_msg')),
  //         actions: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context).pop(false);
  //                 },
  //                 child: Center(
  //                   child: Container(
  //                     width: 100,
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Colors.lightGreen,
  //                       border: Border.all(color: Colors.white),
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     child: Center(child: Text('Ok',  style: TextStyle(color: Colors.white),)),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: 7,),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  get_add_address() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    print('add_address -------> ${user_id}');
    String url = "$root_web/profile/add_address";
    Map data = {
      "user_id": user_id,
      "name": "${nameController.text}",
      "mobile": "${phoneController.text}",
      "email": "${emailController.text}",
      "street_address": "${address1Controller.text}",
      "street_address2": "${address2Controller.text}",
      "zip_code": "${zipcodeController.text}",
      "cities": "${cityController.text}",
      "state": "${stateController.text}",
      "country" :"${countryController.text}"
    };
    print('map_data ---> ${data}');
    http.Response response =
    await http.post(Uri.parse(url), body: jsonEncode(data));
    print("database connectivity${response.body}");
    var jsonResponse = jsonDecode(response.body);
    print('status_add_data_response ===>>> ${response}');
    print('status_add_data_response ===>>> ${jsonResponse}');
    var status = jsonResponse["status"];
    var sesion_msg = jsonResponse["message"];
    print('status_add_data ===>>> ${status}');
    print('status_add_data_message ===>>> ${sesion_msg}');
    if (status == "SUCCESS") {
      print('status_add_data ===>>>');
        Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text('$sesion_msg')),
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
                        color: Colors.lightGreen,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text('Ok',  style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ),
                SizedBox(width: 7,),
              ],
            ),
          ],
        ),
      );
    }else{
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text('$sesion_msg')),
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
                        color: Colors.lightGreen,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text('Ok',  style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ),
                SizedBox(width: 7,),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff014282),
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text("Add Address",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)],
        ),
        actions: [ShoppingCart()],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name:",style: TextStyle(fontWeight: FontWeight.bold),),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text("Phone No:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
                  controller: phoneController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.phone,
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
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),  Text("Email:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),  Text("Street Address:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),  Text("Street Address1:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),  Text("Country:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),  Text("State:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),  Text("City:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),  Text("Zipcode:",style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: size.height*0.04,
                child:
                TextFormField(
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
                    // // hintText: "First Name:",
                    // prefixText: "First Name:",
                    // labelText: "First Name:",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              InkWell(
                onTap:(){
                  validation();
                  // get_add_address();
                },
                child: Container(
                  height: size.height * 0.05,
                  color: Color(0xffb41500),
                  child: const Center(
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  final for_all = SnackBar(content: Text('Give required fields'));
  final first_name = SnackBar(content: Text('Name is required'));
  // final last_name = SnackBar(content: Text('Last name is required'));
  final email = SnackBar(content: Text('Email is required'));
  final phone_no = SnackBar(content: Text('Phone No is required'));
  final phone_no_length = SnackBar(content: Text('Phone No. must be greater than 10 digit'));
  // final password = SnackBar(content: Text('password is required'));
  final address1 = SnackBar(content: Text('Street Address is required'));
  final address2 = SnackBar(content: Text('Street Address1 is required'));
  // final age = SnackBar(content: Text('Age is required'));
  final city = SnackBar(content: Text('City is required'));
  final state = SnackBar(content: Text('State is required'));
  final country = SnackBar(content: Text('Country is required'));
  final zip_code = SnackBar(content: Text('Zipcode is required'));

  void validation() {
    print('validation ====>>>> ');
    if ((nameController.text.toString().isEmpty ||
        nameController.text.toString() == null) &&
        (emailController.text.toString().isEmpty ||
            emailController.text.toString() == null) &&
        (phoneController.text.toString().isEmpty ||
            phoneController.text.toString() == null) &&
        (address1Controller.text.toString().isEmpty ||
            address1Controller.text.toString() == null) &&
        (address2Controller.text.toString().isEmpty ||
            address2Controller.text.toString() == null) &&
        (cityController.text.toString().isEmpty ||
            cityController.text.toString() == null) &&
        (stateController.text.toString().isEmpty ||
            stateController.text.toString() == null) &&
        (countryController.text.toString().isEmpty ||
            countryController.text.toString() == null) &&
        (zipcodeController.text.toString().isEmpty ||
            zipcodeController.text.toString() == null)) {
      ScaffoldMessenger.of(context).showSnackBar(for_all);
    } else if (nameController.text.toString().isEmpty ||
        nameController.text.toString() == null) {
      print('validation ====>>>> 1 ');
      ScaffoldMessenger.of(context).showSnackBar(first_name);
    } else if (phoneController.text.toString().isEmpty ||
        phoneController.text.toString() == null) {
      print('validation ====>>>> 4 ');
      ScaffoldMessenger.of(context).showSnackBar(phone_no);
    }else if (phoneController.text.length <= 9) {
      print('validation ====>>>> 4 ');
      ScaffoldMessenger.of(context).showSnackBar(phone_no_length);
    } else if (emailController.text.toString().isEmpty ||
        emailController.text.toString() == null) {
      print('validation ====>>>> 3 ');
      ScaffoldMessenger.of(context).showSnackBar(email);
    } else if (address1Controller.text.toString().isEmpty ||
        address1Controller.text.toString() == null) {
      print('validation ====>>>> 6 ');
      ScaffoldMessenger.of(context).showSnackBar(address1);
    } else if (address2Controller.text.toString().isEmpty ||
        address2Controller.text.toString() == null) {
      print('validation ====>>>> 7 ');
      ScaffoldMessenger.of(context).showSnackBar(address2);
    } else if (countryController.text.toString().isEmpty ||
        countryController.text.toString() == null) {
      print('validation ====>>>> 11 ');
      ScaffoldMessenger.of(context).showSnackBar(country);
    } else if (stateController.text.toString().isEmpty ||
        stateController.text.toString() == null) {
      print('validation ====>>>> 10 ');
      ScaffoldMessenger.of(context).showSnackBar(state);
    } else if (cityController.text.toString().isEmpty ||
        cityController.text.toString() == null) {
      print('validation ====>>>> 9 ');
      ScaffoldMessenger.of(context).showSnackBar(city);
    } else if (zipcodeController.text.toString().isEmpty ||
        zipcodeController.text.toString() == null) {
      print('validation ====>>>> 1221 ');
      ScaffoldMessenger.of(context).showSnackBar(zip_code);
    } else {
      print('validation ====>>>> 1221 df');
      get_add_address();
    }
  }
}
