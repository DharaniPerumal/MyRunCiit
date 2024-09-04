import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/drawer/Address/add_address.dart';
import 'package:myrunciit/drawer/Address/address_list_grid.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var user_id;

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  int itemCount = 0;
  List shipping_address = [];

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  @override
  void initState() {
    setState(() {
      getstoreid();
    });
    super.initState();
  }
  getstoreid() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs1.getString('store_id');
    });
    print('StoreId2 ===>>> $user_id');
  }
  getaddresslist() async {
    String url1 = "$root_web/profile/address_list/0/${user_id}";
    print('address_list_out$url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    print("list response =>> ${jsonResponse}");
    var status = jsonResponse["status"];
    if (status == "SUCCESS") {
      // List shipping_address = jsonResponse["Response"]["user_address"]["shipping_address"];
      setState(() {
        shipping_address = jsonResponse["response"];
      });

      print('shipping_saddress ====>>>> ${shipping_address}');
      print('shipping_saddreasdss ====>>>> ${shipping_address.length}');
    } else {
      print("failusdfre${jsonResponse["Message"]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => YourAccount()),
        );
        return Future.value(true);
      },
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(onPressed: (){
          //   Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => YourAccount()),
          // );
            Navigator.pop(context);
          },icon: const Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Address List", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18.0),)
            ],
          ),
          actions: [
            ShoppingCart(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAddress()),
              ).then((value) => AddressListGrid());
              },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(
                      color: Colors.grey.shade500,width: 1.0
                    ))
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Add New Address",style: TextStyle(fontSize: 17),),
                      Icon(Icons.chevron_right, size: 25,)
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height:size.height ,
                      child: AddressListGrid()),
                ),
              ],
            ),
          ) ,
        ),
      ),
    );
  }
}
