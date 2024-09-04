import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'add_to_cart.dart';

class Delivery extends StatefulWidget {
  final String categoryName, categoryImage, sale_price, subcategory,current_stock, description, discount , multi_price ,options, brand_name, cod_status, tax, tax_type;
  List product_images = [];

   Delivery({super.key, required this.categoryName, required this.categoryImage,
    required this.sale_price,
    required this.current_stock,
    required this.description,
    required this.product_images,
    required this.subcategory,
    required this.multi_price,
    required this.discount, required this.options, required this.brand_name, required this.cod_status, required this.tax, required this.tax_type,
  });

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  int itemCount = 0;
  TextEditingController zipCodeController = TextEditingController();

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  void showCustomToast() {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        // left: MediaQuery.of(context).size.width * 0.2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0xff404040),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 70, 10),
                child: Center(
                  child: Text(
                    'Sorry no store is available',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  zip_validation() {
    print('zipcode_validation');
    if(zipCodeController.text.isEmpty || zipCodeController.text == "" ){
      print('zipcode_value_empty---->>>> ${zipCodeController.text}');
      showCustomToast();
    }else if(zipCodeController.text.isNotEmpty || zipCodeController.text != ""){
      print('zipcode_value_notempty---->>>> ${zipCodeController.text}');
      get_zipcode(zipCodeController.text);
    }else{
      print('zipcode_value---->>>> ${zipCodeController.text}');
    }
  }

  get_zipcode(k) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = prefs.getString('pin');
    print("enter =>> ${k} == ${a.toString()}");
    if(k.toString() == a.toString())
    {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pickup_delivery', 'delivery');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddToCart(
                sub_category: widget.subcategory,
                tax: widget.tax,
                tax_type: widget.tax_type,
                multi_price: widget.multi_price,
                product_muti_images: widget.product_images,
                categoryName: widget.categoryName,
                categoryImage: widget.categoryImage,
                sale_price: widget.sale_price,
                current_stock: widget.current_stock,
                description: widget.description,
                discount: widget.discount,
                product_id: widget.discount,
                options: widget.options,
                brand_name: widget.brand_name,
                cod_status: widget.cod_status,
              )));
    }
    else
    {
      zipCodeController.text = "";
      FocusManager.instance.primaryFocus?.unfocus();
      showCustomToast();
    }
    // print('get_zipcode ====> entered');
    // String url1 = "$root_web/delivery_zipcode_store/${zipCodeController.text}";
    // dynamic response = await http.get(Uri.parse(url1));
    // var jsonencode = jsonDecode(response.body);
    // var status = jsonencode["status"];
    // print('get_zipcode_delivery ---> $status');
    // if (status == "SUCCESS") {
    //   var delivery_stores = jsonencode["Response"]["delivery_stores"];
    //   print('success_zipcode =====>>>>> ${response.body}');
    //   print('success_zipcode =====>>>>> ${zipCodeController.text}');
    //   print('success_zipcode =====>>>>> ${delivery_stores}');
    //   if( delivery_stores == "Sorry no store is available" ){
    //     print("Sorry no store is available -------- ");
    //   }else{
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => AddToCart(
    //               sub_category: widget.subcategory,
    //               tax: widget.tax,
    //               tax_type: widget.tax_type,
    //               multi_price: widget.multi_price,
    //               product_muti_images: widget.product_images,
    //                 categoryName: widget.categoryName,
    //                 categoryImage: widget.categoryImage,
    //                 sale_price: widget.sale_price,
    //                 current_stock: widget.current_stock,
    //                 description: widget.description,
    //                 discount: widget.discount,
    //                 product_id: widget.discount,
    //                 options: widget.options,
    //               brand_name: widget.brand_name,
    //               cod_status: widget.cod_status,
    //             )));
    //   }
    // } else {
    //   showCustomToast();
    //   print("failure");
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return Future.value(true);
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white),),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Item Details",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)
            ],
          ),
          actions: [
            ShoppingCart(),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.cancel_outlined,color: Colors.red,)),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Fresh groceries, delivered.",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            "Enter your zip code to see if we deliver to your address.",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10), // Add this line for spacing
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 45,
                            width: size.width * 0.65,
                            child: TextField(
                              cursorColor: Colors.black,
                              cursorHeight: 20,
                              cursorWidth: 1,
                              controller: zipCodeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Zip Code',
                                hintStyle: TextStyle(color: Color(0xffdbdbdb),fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(width: 1,color: Color(0xffacacac)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(width: 1,color: Color(0xffacacac)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Add this line for spacing
                        Center(
                          child: InkWell(
                            onTap: () {
                              zip_validation();
                              // get_zipcode();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 47.0,right: 47.0,bottom: 8.0),
                              child: Container(
                                height: size.height * 0.05,
                                color: Color(0xffb41500),
                                child: const Center(
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                        color: Colors.white,fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

