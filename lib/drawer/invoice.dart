import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Invoice extends StatefulWidget { 
  var order_id;
  Invoice({super.key, required this.order_id});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  var order_id;
  String firstName = '';
  String address_1 = '';
  String address_2 = '';
  String zip = '';
  String phone = '';
  String email = '';
  String city = '';
  String state = '';
  String country = '';
  String short_country = '';
  double totalSubtotal = 0.0;
  double delivery_charge1 = 0.0;
  double grandtotal = 0.0;
  double totaltax = 0.0;
  var coupon;
  var paymenttype = '';

  var delivery_charge;

  var date = '';

  String preorderstatus = '';
  var deliveryStatusStatus = '';
  int qty = 0;
  var image = '';
  var itemname = '';
  var firstProductImage = '';
  var price;
  int tax = 0;
  var subtotal;
  List productDetails = [];
  Future<void> invoice_api() async {
    print('orderstoreid');
    String url = "$root_web/invoice/${widget.order_id}";
    print('invoice_details ====>>> $url');
    dynamic response = await http.get(Uri.parse(url));
    print('invoice_api${response.body}');
    print(response.statusCode);
    print(response);
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["Status"]; // Use "Status" instead of "status"
    print('statusstatus$status');
    var shippingAddress = jsonResponse["Response"]["shipping_address"];
    var deliveryStatus = jsonResponse["Response"]["delivery_status"];
    productDetails = jsonResponse["Response"]["product_details"];
    paymenttype = jsonResponse["Response"]["payment_type"];
    date = jsonResponse["Response"]["create_date"];
    delivery_charge = jsonResponse["Response"]["delivery_charge"];
    coupon = jsonResponse["Response"]["coupon"];
    grandtotal = double.parse(jsonResponse["Response"]["total_amount"].toString());

    print('paymenttype-----------$paymenttype-----------coupon-------  -  -${coupon} ------------ totalamount--------al--------${grandtotal}');
    setState(() {
      for(var t=0;t<productDetails.length;t++) 
      {
        setState(() {
          print(productDetails.length);
          totalSubtotal +=  double.parse(productDetails[t]["subtotal"].toString());
          print('totalSubtotal$totalSubtotal');
          totaltax += double.parse(productDetails[t]["tax"].toStringAsFixed(2));
          print('totaltax$totaltax');
        });
      }
      firstName = shippingAddress["firstname"].toString();
      address_1 = shippingAddress["address1"].toString();
      address_2 = shippingAddress["address2"].toString();
      zip = shippingAddress["zip"].toString();
      phone = shippingAddress["phone"].toString();
      email = shippingAddress["email"].toString();
      city = shippingAddress["cities"].toString();
      state = shippingAddress["state"].toString();
      short_country = shippingAddress["short_country"].toString();
      country = shippingAddress["country"].toString();

      deliveryStatusStatus = deliveryStatus[0]["status"];
      print('Delivery Status: $deliveryStatusStatus');
    });
    print('First Name: $firstName');
    print('taxtax$tax');
  }

  @override
  void initState() {
    print("order_id ------>>>>> ${widget.order_id}");
    super.initState();
    setState(() {
      totalSubtotal;

    });
    invoice_api();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);        return Future.value(true);
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: Colors.white,
            ),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Invoice",
                style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [ShoppingCart()],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            // height: size.height,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Image.asset('asset/logo.png', fit: BoxFit.fill),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Order Id: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                              width: size.width * 0.25,
                              color: Colors.white,
                              child: AutoSizeText(
                                widget.order_id,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text('Billed To:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text('First Name: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    width: size.width *0.7,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      firstName,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      maxLines: 2,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('Last Name: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    width: size.width * 0.2,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      maxLines: 2,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                color: Colors.white,
                                height: size.height * 0.05,
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Address:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                    if (address_1 != null || address_1 != 'null' )
                                      AutoSizeText(
                                        address_1,
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                        maxLines: 4,
                                      ),
                                  ],
                                )
                            ),
                            if (zip != null)
                              AutoSizeText(
                                "Zip: $zip",
                                style: TextStyle(color: Colors.black, fontSize: 14),
                                maxLines: 4,
                              ),
                            Row(
                              children: [
                                Text('Phone: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15)),
                                Container(
                                    width: size.width * 0.6,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      phone,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      maxLines: 1,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('E-mail: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14)),
                                Container(
                                    width: size.width * 0.6,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      email,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                      maxLines: 2,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Shipped To:',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text('First Name: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    width: size.width * 0.6,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      "$firstName",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      maxLines: 2,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('Last Name: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    width: size.width * 0.6,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      "santhilaaa",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      maxLines: 2,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                color: Colors.white,
                                height: size.height * 0.05,
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Address:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    if (address_1 != null || address_1 != 'null' )
                                      AutoSizeText(
                                        address_1,
                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                        maxLines: 4,
                                      ),
                                  ],
                                )),
                            if (zip != null)
                              AutoSizeText(
                                "Zip: $zip",
                                style: TextStyle(color: Colors.black, fontSize: 14),
                                maxLines: 4,
                              ),
                            Row(
                              children: [
                                Text('Phone: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15)),
                                Container(
                                    width: size.width * 0.6,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      "$phone",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      maxLines: 1,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text('E-mail: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14)),
                                Container(
                                    width: size.width * 0.6,
                                    color: Colors.white,
                                    child: AutoSizeText(
                                      "$email",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                      maxLines: 2,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Details:',
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text('Payment Method: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,)),
                              Container(
                                  width: size.width * 0.6,
                                  color: Colors.white,
                                  child: AutoSizeText(
                                    paymenttype.toString(),
                                    style:
                                        TextStyle(color: Colors.black, fontSize: 14),
                                    maxLines: 2,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order Date:',
                                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                                AutoSizeText(
                                      date,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                              ],
                            ),
                          // Text('Pre Order Details:',
                          //     style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Row(
                          //   children: [
                          //     Text('Pre Order Status: ',
                          //         style: TextStyle(
                          //             color: Colors.black,
                          //             fontSize: 15,)),
                          //     Container(
                          //         width: size.width * 0.6,
                          //         color: Colors.white,
                          //         child: AutoSizeText(
                          //           deliveryStatusStatus,
                          //           style:
                          //               TextStyle(color: Colors.black, fontSize: 14),
                          //           maxLines: 2,
                          //         )),
                          //   ],
                          // ),
                          SizedBox(
                            height: 25,
                          ),
                          Text('Payment Invoice',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productDetails.length,
                        itemBuilder: (context, index) {



                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: size.width,
                                // height: size.height*0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: size.height * 0.15,
                                      width: size.width * 0.3,
                                      child: Image.network(
                                        productDetails[index]["image"],
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 4),
                                        child: Container(
                                            color: Colors.white,
                                            // height: size.height * 0.06,
                                            width: size.width * 0.45,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  productDetails[index]
                                                      ["name"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                  maxLines: 4,
                                                ),
                                              ],
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 4),
                                        child: Container(
                                            // height: size.height*0.08,
                                            width: size.width * 0.4,
                                            child: Text(
                                              'Seller: MyRunciit',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 4),
                                        child: Container(
                                            // height: size.height*0.08,
                                            width: size.width * 0.4,
                                            child: Text(
                                              'Qty: ' +
                                                  productDetails[index]["qty"]
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 4, 4, 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Unit Cost:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "RM ",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                // text: 'This item costs ',
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                    text:
                                                        productDetails[index]
                                                                ["price"]
                                                            .toStringAsFixed(2),
                                                    style: new TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 4),
                                        child: Container(
                                            // height: size.height*0.08,
                                            width: size.width * 0.4,
                                            child: Text(
                                              'Tax: ' +
                                                  productDetails[index]["tax"]
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 8, 4),
                                        child: Container(
                                            // height: size.height*0.08,
                                            width: size.width * 0.4,
                                            child: Text(
                                              'Total: RM' +
                                                  productDetails[index]
                                                          ["subtotal"]
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold),
                                            )),
                                      ),
                                    ],
                                  ),
                                ])),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: size.height * 0.5,
                            width: size.width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Sub Total Amount:   ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Tax:   ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Delivery Charge:   ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Coupon Discount:   ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  'Grand Total:   ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: size.height * 0.5,
                            width: size.width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'RM${totalSubtotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                Text(
                                  'RM${totaltax.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                Text(
                                  'RM${delivery_charge}.00',
                                  // 'RM ${double.parse(delivery_charge).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                Text(
                                  'RM${coupon}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                Divider(),
                                Text(
                                  'RM${grandtotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )


                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
