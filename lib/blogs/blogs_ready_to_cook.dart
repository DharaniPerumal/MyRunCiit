import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myrunciit/blogs/blogs_desc.dart';
import 'package:myrunciit/blogs/blogs_detailview.dart';
import 'package:myrunciit/blogs/blogs_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

var link_blog3;
var blogs3;

class ReadyToCook extends StatefulWidget {
  @override
  State<ReadyToCook> createState() => _ReadyToCookState();
}

class _ReadyToCookState extends State<ReadyToCook> {
  bool all_blogs = true;
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getblogdetails();
    await get_blogs_api();
    setState(() {
      // Update UI if necessary
    });
  }
  getblogdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      link_blog3 = prefs.getString('bloglink');
    });

    print("link_blog$link_blog3");
  }

  get_blogs_api() async {
    final response = await http.post(
      Uri.parse('$root_web/blogs'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "limit": "all",
      }),
    );
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    print('status_blogs_addressess ===>>> ${jsonResponse}');
    if (status == "SUCCESS") {
      setState(() {
        blogs3 = jsonResponse["response"];
      });

      print('status123_blogs${blogs3}');
      print('status123_response${jsonResponse["response"]}');
      print('status123_response${jsonResponse["response"][0]["image_src"]}');
      if (jsonResponse["response"] != null) {
        print('hhelooo12345');
      }
    }
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
          backgroundColor: const Color(0xff014282),
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'asset/unit-1.png',
                fit: BoxFit.contain,
                height: 32,
              ),
            ],
          ),
        ),
        drawer: Blogs_Drawer(),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Blogs_Detail(
                        blogs_link: null,
                      )),
            );
            return Future.value(true);
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: blogs3?.length ?? 0,
                itemBuilder: (context, index) {
    if (blogs3 != null && blogs3.isNotEmpty && blogs3[index] != null) {
      String summary1 = blogs3[index]['summery'];
      String desc1 = desc_blog;

      String summary = Bidi.stripHtmlIfNeeded(summary1);
      String desc = Bidi.stripHtmlIfNeeded(desc1);
      if (blogs3[index]['blog_category_name'] == "Ready To Cook") {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: InkWell(
              onTap: () async {
                final SharedPreferences prefs =
                await SharedPreferences.getInstance();
                var blog_title = blogs3[index]['title'];
                await prefs.setString('blogstitle', '${blog_title}');
                print('blog_title>>>>$blog_title');

                var blog_summary = blogs3[index]['summery'];
                await prefs.setString(
                    'blogssummary', '${blog_summary}');
                print('blog_summary>>>>$blog_summary');

                var blog_author = blogs3[index]['author'];
                await prefs.setString('blogauthor', '${blog_author}');
                print('blog_author>>>>$blog_author');

                var blog_date = blogs3[index]['date'];
                await prefs.setString('blogdate', '${blog_date}');
                print('blog_date>>>>$blog_date');

                var blog_desc = blogs3[index]['description'];
                await prefs.setString('blogdesc', '${blog_desc}');
                print('blog_desc>>>>$blog_desc');

                var blog_category =
                blogs3[index]['blog_category_name'];
                await prefs.setString(
                    'blogcategory', '${blog_category}');
                print('blog_category>>>>$blog_category');

                var blog_image = blogs3[index]['image_src'];
                await prefs.setString('blogimage', '${blog_image}');
                print('blog_image>>>>$blog_image');

                var blog_link = blogs3[index]['link'];
                await prefs.setString('bloglink', '${blog_link}');
                print('blog_image>>>>$blog_link');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Blogs_Detail(
                        blogs_link: blogs3[index]['link'],
                      )),
                );
              },
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400)),
                child: Row(
                  children: [
                    Container(
                        color: Colors.white,
                        height: 100,
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            blogs3[index]['image_src'],
                            fit: BoxFit.fitHeight,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.6,
                            ),
                            child: AutoSizeText(
                              blogs3[index]['title'],
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Author: ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black)),
                                  Text(blogs3[index]['author'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black)),
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.2,
                              ),
                              Text(blogs3[index]['date'],
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black)),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: size.width * 0.6,
                            height: size.height * 0.08,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey.shade400),
                                    bottom: BorderSide(
                                        color:
                                        Colors.grey.shade400))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: size.width * 0.6,
                                ),
                                child: AutoSizeText(
                                  summary,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    }


                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
