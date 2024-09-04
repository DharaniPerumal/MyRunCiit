// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:myrunciit/roots/roots.dart';
// import 'package:myrunciit/widget/cart.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class Review extends StatefulWidget {
//   var order_id;
//   Review({super.key, required this.order_id});
//
//   @override
//   State<Review> createState() => _ReviewState();
// }
//
// class _ReviewState extends State<Review> {
//   TextEditingController desccontroller = TextEditingController();
//   TextEditingController titlecontroller = TextEditingController();
//
//   String firstName = '';
//   String address_1 = '';
//   String address_2 = '';
//   String zip = '';
//   String phone = '';
//   String email = '';
//   var paymenttype = '';
//   var date = '';
//
//   String preorderstatus = '';
//   var deliveryStatusStatus = '';
//   int qty = 0;
//   var image = '';
//   var itemname = '';
//   var firstProductImage = '';
//   var price;
//   int tax = 0;
//   var subtotal;
//   List productDetails = [];
//
//   Future<void> review_api() async {
//     print('orderstoreid');
//     String url = "$root_web/invoice/${widget.order_id}";
//     print('invoice_details ====>>> $url');
//     dynamic response = await http.get(Uri.parse(url));
//     print('invoice_api${response.body}');
//     print(response.statusCode);
//     print(response);
//     var jsonResponse = jsonDecode(response.body);
//     var status = jsonResponse["status"];
//     var order_id = jsonResponse['status']['Response']['order_id'];
//     print('order_id$order_id');
//   }
//
//   Future<void> invoice_api() async {
//     print('orderstoreid');
//     String url = "$root_web/invoice/${widget.order_id}";
//     print('invoice_details ====>>> $url');
//     dynamic response = await http.get(Uri.parse(url));
//     print('invoice_api${response.body}');
//     print(response.statusCode);
//     print(response);
//     var jsonResponse = jsonDecode(response.body);
//     var status = jsonResponse["Status"]; // Use "Status" instead of "status"
//     print('statusstatus$status');
//     var shippingAddress = jsonResponse["Response"]["shipping_address"];
//     var deliveryStatus = jsonResponse["Response"]["delivery_status"];
//     productDetails = jsonResponse["Response"]["product_details"];
//     paymenttype = jsonResponse["Response"]["payment_type"];
//     date = jsonResponse["Response"]["create_date"];
//
//     print('paymenttype$paymenttype');
//     setState(() {
//       firstName = shippingAddress["firstname"].toString();
//       address_1 = shippingAddress["address1"].toString();
//       address_2 = shippingAddress["address2"].toString();
//       zip = shippingAddress["zip"].toString();
//       phone = shippingAddress["phone"].toString();
//       email = shippingAddress["email"].toString();
//
//       if (productDetails != null && productDetails.isNotEmpty) {
//         var firstProduct = productDetails[0];
//         firstProductImage = firstProduct["image"];
//         print('First Product Image: $firstProductImage');
//         itemname = productDetails[0]["name"];
//         qty = productDetails[0]["qty"];
//         price = double.parse(productDetails[0]["price"].toString());
//         tax = productDetails[0]["tax"];
//         subtotal = double.parse(productDetails[0]["subtotal"].toString());
//       }
//
//       deliveryStatusStatus = deliveryStatus[0]["status"];
//       print('Delivery Status: $deliveryStatusStatus');
//     });
//     print('First Name: $firstName');
//     print('taxtax$tax');
//   }
//
//   @override
//   void initState() {
//     review_api();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xff014282),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.keyboard_arrow_left,
//             size: 35,
//             color: Colors.white,
//           ),
//         ),
//         title: const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Text(
//               "Ratings & Review",
//               style: TextStyle(color: Colors.white, fontSize: 15),
//             )
//           ],
//         ),
//         actions: [ShoppingCart()],
//       ),
//       body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
//               child: Center(
//                   child: Text(
//                 "Fresh Goat(Bone mix)",
//                 style: TextStyle(
//                   fontSize: 17,
//                 ),
//               )),
//             ),
//             Center(
//                 child: Text(
//               "Rate this Product",
//               style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//             )),
//             SizedBox(
//               height: 15,
//             ),
//             Center(
//               child: RatingBar.builder(
//                 initialRating: 0,
//                 minRating: 0,
//                 direction: Axis.horizontal,
//                 allowHalfRating: true,
//                 itemCount: 5,
//                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 itemBuilder: (context, _) => Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 onRatingUpdate: (rating) {
//                   print(rating);
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                   child: Text("Review this Product",
//                       style: TextStyle(
//                           fontSize: 19, fontWeight: FontWeight.bold))),
//             ),
//             Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                         width: size.width,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "Description",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         )),
//                     TextField(
//                       controller: desccontroller,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: 7,
//                       decoration: InputDecoration(
//                           hintText: "Description....",
//                           hintStyle: TextStyle(fontWeight: FontWeight.bold),
//                           border: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(width: 1, color: Colors.grey)),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(width: 1, color: Colors.grey))),
//                     ),
//                   ],
//                 )),
//             Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                         width: size.width,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "Title (Optional)",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         )),
//                     TextField(
//                       controller: titlecontroller,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: 1,
//                       decoration: InputDecoration(
//                           hintText: "Review Title....",
//                           hintStyle: TextStyle(fontWeight: FontWeight.bold),
//                           border: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(width: 1, color: Colors.grey)),
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(width: 1, color: Colors.grey))),
//                     ),
//                   ],
//                 )),
//           ])),
//       bottomNavigationBar: Container(
//         color: Color(0xffc40001),
//         height: 60, // Set the desired height
//         width: size.width,
//         child: InkWell(
//           onTap: () {},
//           child: Center(
//             child: Text(
//               "Submit Review",
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _onRegisterform() async {
//     String url = "$root_web/add_review";
//     Map data = {
//       "pid": ,
//       "user_id": ,
//       "title": "caraway seed",
//       "rating": ,
//       "description": "test",
//       "order_id": "",
//       "sale_id":
//     };
//     print("registeration_Api_connect ====>>> ${data}");
//     http.Response response =
//         await http.post(Uri.parse(url), body: jsonEncode(data));
//     print("registeration_Api_connect ====>>> ${response.body}");
//     print(response.statusCode);
//     var jsonResponse = jsonDecode(response.body);
//     var status = jsonResponse["status"];
//     print('register status$status');
//     if (status == "SUCCESS") {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//       // Fluttertoast.showToast(
//       //     msg: 'Login Successfully...!',
//       //     toastLength: Toast.LENGTH_LONG,
//       //     gravity: ToastGravity.CENTER,
//       //     timeInSecForIosWeb: 3,
//       //     backgroundColor: Color(0xff014282),
//       //     textColor: Colors.white,
//       //     fontSize: 15,
//       //     webPosition: "center");
//       InkWell(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             color: Colors.lightGreen,
//             child: Center(
//                 child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Text(
//                 'Ok',
//                 style: TextStyle(
//                     fontWeight: FontWeight.normal,
//                     color: Colors.white,
//                     fontSize: 15),
//               ),
//             )),
//           ),
//         ),
//       );
//
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.2,
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.all(Radius.circular(5)),
//               ),
//               child: AlertDialog(
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Container(
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "Registered Successfully",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => LoginScreen()),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.lightGreen,
//                           child: Center(
//                               child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Text(
//                               'Ok',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   color: Colors.white,
//                                   fontSize: 15),
//                             ),
//                           )),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           });
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) => ProductScreen()));
//     } else {
//       Fluttertoast.showToast(
//           msg: '${jsonResponse["Message"]}',
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 3,
//           backgroundColor: Color(0xff014282),
//           textColor: Colors.white,
//           fontSize: 15,
//           webPosition: "center");
//     }
//   }
// }
