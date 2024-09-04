import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var store_id;

class category_banners extends StatefulWidget {
  const category_banners({super.key});

  @override
  State<category_banners> createState() => _category_bannersState();
}

class _category_bannersState extends State<category_banners> {
  StreamController<List> _banner_viewedController = StreamController<List>();

  List banner = [];

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    print('gridview3store_id===>>> $store_id');
    get_banner();
  }

  @override
  void initState() {
    setState(() {
      getstoreid();
      get_banner();
    });
    super.initState();
  }

  @override
  void dispose() {
    _banner_viewedController.close();
    super.dispose();
  }

  get_banner() async {
    String url1 = "$root_web/banner/2";
    print('success_most ----------->  $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["category_banner"] != null) {
        setState(() {
          banner = jsonResponse['Response']["category_banner"];
          _banner_viewedController.add(banner);
          print(banner);
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
        body: StreamBuilder<List>(
          stream: _banner_viewedController.stream,
          builder: (context, snapshot) {
            if ((snapshot.hasData)) {
              List<dynamic> most = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: banner.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            children: [
                              SafeArea(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                      Border.all(color: Colors.grey.shade100)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          height: 100,
                                          width: MediaQuery.of(context).size.width * 0.48,
                                          // color: Colors.orange,
                                          child: banner[index]["banner_image"] !=
                                              null
                                              ? Image.network(
                                            banner[index]["banner_image"]
                                                .toString(),
                                            errorBuilder: (BuildContext
                                            context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                  'asset/dummy.jpg');
                                            },
                                            fit: BoxFit.fill,
                                          )
                                              : Image.asset('asset/dummy.jpg'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                          banner[index]["category_name"].toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),


                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )),);
  }
}
