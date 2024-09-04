import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/drawer/Address/address_list_grid.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


var transactionstoreid;


class MyTransaction extends StatefulWidget {
  @override
  _MyTransactionState createState() => _MyTransactionState();
}
class _MyTransactionState extends State<MyTransaction> {
  List rewards = [];
  ScrollController _scrollController = ScrollController();

  // List subcategories = [];

  @override
  void initState() {
    initData();
    super.initState();
  }
  Future<void> initData() async {
    await transactionstoreid1();
    getProduct1();
  }
  Future<void>transactionstoreid1() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      transactionstoreid = prefs1.getString('store_id');
    });
    print('transactionstoreid1 ===>>> $transactionstoreid');
  }



  getProduct1() async {

    String url1 = "$root_web/transaction_history/${transactionstoreid}";
    // https://myrunciit.my/webservice/all_category
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["transaction_history"] != null) {
        setState(() {
          // Access the array of categories from the response
          rewards = jsonResponse['Response']["transaction_history"];
          print("hello20");
          print(rewards);


        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }
  TableRow buildTableRow(int index) {
    var reward = rewards[index];
    return TableRow(

      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Text(reward['date'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reward['status'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reward['amount'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reward['description'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reward['ref_id'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Text((index + 1).toString(), textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),

      ],
    );
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
          backgroundColor: Color(0xff014282),
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text("My Transaction")],
          ),
          actions: [ShoppingCart()],
        ),
        body:                  SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: Colors.black,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Your Transaction",style: TextStyle(color: Colors.white, fontSize: 17),),
                    )),
                  )
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,

                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,

                  child: Container(
                    width: size.width*1.75,
                    child: Column(
                        children:<Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Table(
                                columnWidths: {
                                  0: FixedColumnWidth(110.0),// fixed to 100 width
                                  1: FlexColumnWidth(5.0),
                                  2: FixedColumnWidth(100.0),
                                  3: FixedColumnWidth(130.0),// fixed to 100 width
                                  4: FlexColumnWidth(6.0),
                                  5: FixedColumnWidth(50.0),//fixed to 100 width
                                },

                                textDirection: TextDirection.rtl,
                                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                                border:TableBorder(top: BorderSide(color: Colors.grey),bottom: BorderSide(color: Colors.grey),horizontalInside: BorderSide(color: Colors.grey),right: BorderSide(color: Colors.grey),left: BorderSide(color: Colors.grey),),
                                children: [
                                  const TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Date",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Status",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Amount",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Description",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Transaction ID",textScaleFactor: 1.5 ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("#",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),

                                      ]
                                  ),
                                  for (var index = 0; index < rewards.length; index++)
                                    buildTableRow(index),


                                ],
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),


      ),
    );
  }
}
