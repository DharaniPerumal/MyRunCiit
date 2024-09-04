import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/main_screen/main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/radio_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobnumController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  TextEditingController _address1Controller = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _zipController = TextEditingController();

  FocusNode firstNameFocu = FocusNode();
  FocusNode lastNameFocu = FocusNode();
  FocusNode emailIdFocu = FocusNode();
  FocusNode mobileNoFocu = FocusNode();
  FocusNode passwordFocu = FocusNode();
  FocusNode confirmpasswordFocu = FocusNode();

  FocusNode address1Fpcu = FocusNode();
  FocusNode address2Focu = FocusNode();
  FocusNode ageFocu = FocusNode();
  FocusNode cityFocu = FocusNode();
  FocusNode stateFocu = FocusNode();
  FocusNode countryFocu = FocusNode();
  FocusNode zipCodeFocu = FocusNode();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      print('Email: $email');
      print('Password: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: size.height * 0.45,
              width: size.width,
              decoration: BoxDecoration(
                  color: Color(0xff004387),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70.0),
                    bottomRight: Radius.circular(70.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 50, 0, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Register your account. !",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Center(
                      child: Container(
                        width: 200,
                        child: Image.asset(
                          'asset/unit-1.png',
                          fit: BoxFit.fill,
                        ),
                        // image: DecorationImage(image: AssetImage('asset/unit-1.png')),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.27),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Container(
                    height: size.height * 1.2,
                    width: size.width,
                    // color: Colors.cyan,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.1), // Shadow color and opacity
                          spreadRadius: 1, // Spread radius
                          blurRadius: 1, // Blur radius
                          offset: Offset(0, 1), // Offset from the box
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.01),
                            TextFormField(
                              focusNode: firstNameFocu,
                              controller: _firstnameController,
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'First Name',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(lastNameFocu);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: lastNameFocu,
                              controller: _lastnameController,
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Last Name',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(emailIdFocu);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Last name'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: emailIdFocu,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Email Address',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(mobileNoFocu);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Email Address'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: mobileNoFocu,
                              controller: _mobnumController,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Mobile Phone',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocu);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Mobile Phone'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: passwordFocu,
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(confirmpasswordFocu);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Password'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: confirmpasswordFocu,
                              controller: _confirmpasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(address1Fpcu);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Confirm Password'; // Corrected error message
                                } else if (_passwordController.text !=
                                    _confirmpasswordController.text) {
                                  return 'Password and Confirm Password are not same';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: address1Fpcu,
                              controller: _address1Controller,
                              keyboardType: TextInputType.streetAddress,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Address Line 1',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(address2Focu);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Address Line 1"'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: address2Focu,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(ageFocu);
                              },
                              controller: _address2Controller,
                              keyboardType: TextInputType.streetAddress,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Address Line 2',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Address Line 2'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: ageFocu,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(cityFocu);
                              },
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Age',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Age'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            MyRadioWidget(),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: cityFocu,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(stateFocu);
                              },
                              controller: _cityController,
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'City',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your City'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: stateFocu,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(countryFocu);
                              },
                              controller: _stateController,
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'State',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your State'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: countryFocu,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(zipCodeFocu);
                              },
                              controller: _countryController,
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Country',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Country'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            TextFormField(
                              focusNode: zipCodeFocu,
                              controller: _zipController,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove the default border
                                focusedBorder: OutlineInputBorder(
                                  // Add a border when focused
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade300), // Set the border color
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // Add an enabled border (for unfocused state)
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10), // Adjust content padding
                                hintText: 'Zip',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Zip'; // Corrected error message
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
                            InkWell(
                              onTap: () {
                                print('pressed register button ====>>>> ');
                                validation();
                              },
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.7,
                                color: Color(0xFFc40001),
                                child: Center(
                                    child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )),
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
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            color: Color.fromRGBO(4, 68, 132, 3),
            height: size.height * 0.09, // Adjust the height as needed
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Container(
              // color: Colors.white,
              height: size.height * 0.08,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Have account ?",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Login.",
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final for_all = SnackBar(content: Text('Give required fields'));
  final first_name = SnackBar(content: Text('First name is required'));
  final last_name = SnackBar(content: Text('Last name is required'));
  final email = SnackBar(content: Text('Email Id is required'));
  final phone_no = SnackBar(content: Text('Phone no. is required'));
  final phone_no_length =
      SnackBar(content: Text('Phone No. Should be greater than 10 numbers'));
  final password1 = SnackBar(content: Text('password is required'));
  final password2 = SnackBar(content: Text('Confirm password is required'));
  final password3 =
      SnackBar(content: Text('Password and Confirm Password are not Same'));

  final password = SnackBar(content: Text('password is required'));
  final address1 = SnackBar(content: Text('Address 1 is required'));
  final address2 = SnackBar(content: Text('Address 2 is required'));
  final age = SnackBar(content: Text('Age is required'));
  final city = SnackBar(content: Text('City is required'));
  final state = SnackBar(content: Text('State is required'));
  final country = SnackBar(content: Text('Country is required'));
  final zip_code = SnackBar(content: Text('Zipcode is required'));

  void validation() {
    print('validation ====>>>> ');
    if ((_firstnameController.text.toString().isEmpty ||
            _firstnameController.text.toString() == null) &&
        (_lastnameController.text.toString().isEmpty ||
            _lastnameController.text.toString() == null) &&
        (_emailController.text.toString().isEmpty ||
            _emailController.text.toString() == null) &&
        (_mobnumController.text.toString().isEmpty ||
            _mobnumController.text.toString() == null) &&
        (_passwordController.text.toString().isEmpty ||
            _passwordController.text.toString() == null) &&
        (_confirmpasswordController.text.toString().isEmpty ||
            _confirmpasswordController.text.toString() == null) &&
        (_address1Controller.text.toString().isEmpty ||
            _address1Controller.text.toString() == null) &&
        (_cityController.text.toString().isEmpty ||
            _cityController.text.toString() == null) &&
        (_stateController.text.toString().isEmpty ||
            _stateController.text.toString() == null) &&
        (_countryController.text.toString().isEmpty ||
            _countryController.text.toString() == null) &&
        (_zipController.text.toString().isEmpty ||
            _zipController.text.toString() == null)) {
      ScaffoldMessenger.of(context).showSnackBar(for_all);
    } else if (_firstnameController.text.toString().isEmpty ||
        _firstnameController.text.toString() == null) {
      print('validation ====>>>> 1 ');
      ScaffoldMessenger.of(context).showSnackBar(first_name);
    } else if (_lastnameController.text.toString().isEmpty ||
        _lastnameController.text.toString() == null) {
      print('validation ====>>>> 2 ');
      ScaffoldMessenger.of(context).showSnackBar(last_name);
    } else if (_emailController.text.toString().isEmpty ||
        _emailController.text.toString() == null) {
      print('validation ====>>>> 3 ');
      ScaffoldMessenger.of(context).showSnackBar(email);
    } else if (_mobnumController.text.toString().isEmpty ||
        _mobnumController.text.toString() == null) {
      print('validation ====>>>> 4 ');
      ScaffoldMessenger.of(context).showSnackBar(phone_no);
    } else if (_passwordController.text.toString().isEmpty ||
        _passwordController.text.toString() == null) {
      print('validation ====>>>> 5 ');
      ScaffoldMessenger.of(context).showSnackBar(password1);
    } else if (_confirmpasswordController.text.toString().isEmpty ||
        _confirmpasswordController.text.toString() == null) {
      print('validation ====>>>> 5 ');
      ScaffoldMessenger.of(context).showSnackBar(password2);
    } else if (_passwordController.text != _confirmpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(password3);
    } else if (_address1Controller.text.toString().isEmpty ||
        _address1Controller.text.toString() == null) {
      print('validation ====>>>> 6 ');
      ScaffoldMessenger.of(context).showSnackBar(address1);
    } else if (_cityController.text.toString().isEmpty ||
        _cityController.text.toString() == null) {
      print('validation ====>>>> 9 ');
      ScaffoldMessenger.of(context).showSnackBar(city);
    } else if (_stateController.text.toString().isEmpty ||
        _stateController.text.toString() == null) {
      print('validation ====>>>> 10 ');
      ScaffoldMessenger.of(context).showSnackBar(state);
    } else if (_countryController.text.toString().isEmpty ||
        _countryController.text.toString() == null) {
      print('validation ====>>>> 11 ');
      ScaffoldMessenger.of(context).showSnackBar(country);
    } else if (_zipController.text.toString().isEmpty ||
        _zipController.text.toString() == null) {
      print('validation ====>>>> 1221 ');
      ScaffoldMessenger.of(context).showSnackBar(zip_code);
    } else {
      print('validation ====>>>> 1221 df');
      _onRegisterform();
    }
  }

  Future<void> _onRegisterform() async {
    String url = "$root_web/registration/add_info";
    Map data = {
      "username": "${_firstnameController.text}",
      "surename": "${_lastnameController.text}",
      "phone": _mobnumController.text,
      "password1": "${_passwordController.text}",
      "password2": "${_confirmpasswordController.text}",
      "address1": "${_address1Controller.text}",
      "address2": "${_address2Controller.text}",
      "age": _ageController.text,
      "city": "${_cityController.text}",
      "state": "${_stateController.text}",
      "country": "${_countryController.text}",
      "zip": _zipController.text,
      "email": "${_emailController.text}"
    };
    print("registeration_Api_connect ====>>> ${data}");
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    print("registeration_Api_connect ====>>> ${response.body}");
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    print('register status$status');
    if (status == "SUCCESS") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      // Fluttertoast.showToast(
      //     msg: 'Login Successfully...!',
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 3,
      //     backgroundColor: Color(0xff014282),
      //     textColor: Colors.white,
      //     fontSize: 15,
      //     webPosition: "center");
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
      );

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
                            "Registered Successfully",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
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
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ProductScreen()));
    } else {
      Fluttertoast.showToast(
          msg: '${jsonResponse["Message"]}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
    }
  }
}
