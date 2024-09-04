import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrunciit/blogs/all_blogs.dart';
import 'package:myrunciit/blogs/blogs_author.dart';
import 'package:myrunciit/blogs/blogs_detailview.dart';
import 'package:myrunciit/blogs/blogs_meat_shop.dart';
import 'package:myrunciit/blogs/blogs_ready_to_cook.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';

var myValue;
var blogs5;

class Blogs_Drawer extends StatefulWidget {
  const Blogs_Drawer({Key? key});

  @override
  State<Blogs_Drawer> createState() => _Blogs_DrawerState();
}

class _Blogs_DrawerState extends State<Blogs_Drawer> {
  bool recentSelected = true;

  Future<void> _fetchAndSortBlogs() async {
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
      blogs5 = jsonResponse["response"];
      print('status123_blogs${blogs5}');
      print('status123_response${jsonResponse["response"]}');
      print('status123_response${jsonResponse["response"][0]["image_src"]}');
      if (jsonResponse["response"] != null) {
        // Sort blogs by date in descending order
        blogs5.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
        print('hhelooo12345');
      }
    }
  }

  make_asc()
  {
    setState(() {
      if(blogs5 != null)
      {
        blogs5.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      }
    });
  }

  make_popular()
  {
    setState(() {
      if(blogs5 != null)
      {
        blogs5.sort((a, b) =>
            int.parse(b['number_of_view']).compareTo(int.parse(a['number_of_view'])));
      }
    });
  }

  @override
  void initState() {
    _fetchAndSortBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('myvalue2 ===>>> $myValue');

    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: size.height * 0.13,
            decoration: BoxDecoration(
                color: Color(0xff014282),
                image: DecorationImage(image: AssetImage('asset/unit-1.png'))),
          ),
          Container(
            color: Colors.white,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  color: Colors.white,
                  height: size.height * 0.05,
                  child: ListTile(
                    title: Text(
                      'All Blogs',
                      style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllBlogs()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  color: Colors.white,
                  height: size.height * 0.05,
                  child: ListTile(
                    title: Text('Meat Shop',
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlogsMeatShop()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  color: Colors.white,
                  height: size.height * 0.05,
                  child: ListTile(
                    title: Text("Ready To Cook",
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadyToCook()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  color: Colors.white,
                  height: size.height * 0.05,
                  child: ListTile(
                    title: Text("Thillai",
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlogsAuthor()),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        recentSelected = true;
                        make_asc();
                      });
                    },
                    child: Container(
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: recentSelected ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.grey.shade400)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Recent',
                            style: TextStyle(
                                color: recentSelected
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        recentSelected = false;
                        make_popular();
                      });
                    },
                    child: Container(
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: recentSelected ? Colors.white : Colors.black,
                          border: Border.all(color: Colors.grey.shade400)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Popular',
                            style: TextStyle(
                                color: recentSelected
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (recentSelected == true)
                FutureBuilder(
                  future: _fetchAndSortBlogs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: size.height,
                          width: size.width,
                          color: Colors.white,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: blogs5.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: InkWell(
                                    onTap: () async {
                                      final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      var blog_title = blogs5[index]['title'];
                                      await prefs.setString(
                                          'blogstitle', '${blog_title}');
                                      print('blog_title>>>>$blog_title');

                                      var blog_summary =
                                      blogs5[index]['summery'];
                                      await prefs.setString(
                                          'blogssummary', '${blog_summary}');
                                      print('blog_summary>>>>$blog_summary');

                                      var blog_author = blogs5[index]['author'];
                                      await prefs.setString(
                                          'blogauthor', '${blog_author}');
                                      print('blog_author>>>>$blog_author');

                                      var blog_date = blogs5[index]['date'];
                                      await prefs.setString(
                                          'blogdate', '${blog_date}');
                                      print('blog_date>>>>$blog_date');

                                      var blog_desc =
                                      blogs5[index]['description'];
                                      await prefs.setString(
                                          'blogdesc', '${blog_desc}');
                                      print('blog_desc>>>>$blog_desc');

                                      var blog_category =
                                      blogs5[index]['blog_category_name'];
                                      await prefs.setString(
                                          'blogcategory', '${blog_category}');
                                      print('blog_category>>>>$blog_category');

                                      var blog_image =
                                      blogs5[index]['image_src'];
                                      await prefs.setString(
                                          'blogimage', '${blog_image}');
                                      print('blog_image>>>>$blog_image');

                                      var blog_link = blogs5[index]['link'];
                                      await prefs.setString(
                                          'bloglink', '${blog_link}');
                                      print('blog_image>>>>$blog_link');

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Blogs_Detail(
                                              blogs_link: blogs5[index]
                                              ['link'],
                                            )),
                                      );
                                    },
                                    child: Container(
                                      height: size.height * 0.15,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade400)),
                                      child: Row(
                                        children: [
                                          Container(
                                              color: Colors.white,
                                              height: 100,
                                              width: 100,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                  blogs5[index]['image_src'],
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: size.width * 0.4,
                                                  ),
                                                  child: AutoSizeText(
                                                    blogs5[index]['title'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(blogs5[index]['date'])
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: blogs5.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            child: InkWell(
                              onTap: () async {
                                final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                var blog_title = blogs5[index]['title'];
                                await prefs.setString(
                                    'blogstitle', '${blog_title}');
                                print('blog_title>>>>$blog_title');

                                var blog_summary = blogs5[index]['summery'];
                                await prefs.setString(
                                    'blogssummary', '${blog_summary}');
                                print('blog_summary>>>>$blog_summary');

                                var blog_author = blogs5[index]['author'];
                                await prefs.setString(
                                    'blogauthor', '${blog_author}');
                                print('blog_author>>>>$blog_author');

                                var blog_date = blogs5[index]['date'];
                                await prefs.setString(
                                    'blogdate', '${blog_date}');
                                print('blog_date>>>>$blog_date');

                                var blog_desc = blogs5[index]['description'];
                                await prefs.setString(
                                    'blogdesc', '${blog_desc}');
                                print('blog_desc>>>>$blog_desc');

                                var blog_category =
                                blogs5[index]['blog_category_name'];
                                await prefs.setString(
                                    'blogcategory', '${blog_category}');
                                print('blog_category>>>>$blog_category');

                                var blog_image = blogs5[index]['image_src'];
                                await prefs.setString(
                                    'blogimage', '${blog_image}');
                                print('blog_image>>>>$blog_image');

                                var blog_link = blogs5[index]['link'];
                                await prefs.setString(
                                    'bloglink', '${blog_link}');
                                print('blog_image>>>>$blog_link');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Blogs_Detail(
                                        blogs_link: blogs5[index]['link'],
                                      )),
                                );
                              },
                              child: Container(
                                height: size.height * 0.15,
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Row(
                                  children: [
                                    Container(
                                        color: Colors.white,
                                        height: 100,
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            blogs5[index]['image_src'],
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 20),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: size.width * 0.4,
                                            ),
                                            child: AutoSizeText(
                                              blogs5[index]['title'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(blogs5[index]['date'])
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
            ]),
          )
        ],
      ),
    );
  }
}