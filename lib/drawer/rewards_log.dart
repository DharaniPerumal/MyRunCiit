import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var rewardsstoreid;



class RewardsLog extends StatefulWidget {
  @override
  _RewardsLogState createState() => _RewardsLogState();
}
class _RewardsLogState extends State<RewardsLog> {
  List rewards = [];
  // List subcategories = [];
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    initData();
    super.initState();
  }
  Future<void> initData() async {
    await rewardsstoreid1();
    getProduct1();
  }
  Future<void>rewardsstoreid1() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      rewardsstoreid = prefs1.getString('store_id');
    });
    print('rewardsstoreid1 ===>>> $rewardsstoreid');
  }



  getProduct1() async {
    print('rewardsstoreid2 ===>>> $rewardsstoreid');

    String url1 = "$root_web/rewards_history/${rewardsstoreid}";
    // https://myrunciit.my/webservice/all_category
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["rewards_history"] != null) {
        setState(() {
          // Access the array of categories from the response
          rewards = jsonResponse['Response']["rewards_history"];
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
          padding: const EdgeInsets.all(8.0),
          child: Text("", textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reward['date'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reward['rewards'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(reward['order_id'], textScaleFactor: 1.5,style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
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
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text("Rewards",style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold))],
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
                      child: Text("Rewards RM 10204.32",style: TextStyle(color: Colors.white, fontSize: 17),),
                    )),
                  )
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,

                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,

                  child: Container(
                    width: size.width*1.6,
                    child: Column(
                        children:<Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Table(
                                columnWidths: {
                                  0: FixedColumnWidth(110.0),// fixed to 100 width
                                  1: FlexColumnWidth(12.0),
                                  2: FixedColumnWidth(120.0),
                                  3: FixedColumnWidth(170.0),// fixed to 100 width
                                  4: FlexColumnWidth(5.0),
                                  // 5: FixedColumnWidth(50.0),//fixed to 100 width
                                },

                                textDirection: TextDirection.rtl,
                                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                                border:TableBorder(top: BorderSide(color: Colors.grey),bottom: BorderSide(color: Colors.grey),horizontalInside: BorderSide(color: Colors.grey),right: BorderSide(color: Colors.grey),left: BorderSide(color: Colors.grey),),
                                children: [
                                  TableRow(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Note",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Date",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Rewards",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Order ID",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("#",textScaleFactor: 1.5,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                          ),
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
