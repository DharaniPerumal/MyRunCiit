import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myrunciit/blogs/all_blogs.dart';
import 'package:myrunciit/blogs/blogs_desc.dart';
import 'package:myrunciit/blogs/blogs_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

var title_blog;
var summary_blog;
var author_blog;
var date_blog;
var desc_blog;
var category_blog;
var image_blog;

class Blogs_Detail extends StatefulWidget {
  var blogs_link;

  Blogs_Detail({super.key, required this.blogs_link});

  @override
  State<Blogs_Detail> createState() => _Blogs_DetailState();
}

class _Blogs_DetailState extends State<Blogs_Detail> {
  bool all_blogs = true;

  @override
  void initState() {
    print('blog_link${widget.blogs_link}');
    setState(() {
      getblogdetails();
      get_blogs();
    });
    super.initState();
  }

  getblogdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      title_blog = prefs.getString('blogstitle');
      summary_blog = prefs.getString('blogssummary');
      author_blog = prefs.getString('blogauthor');
      date_blog = prefs.getString('blogdate');
      desc_blog = prefs.getString('blogdesc');
      category_blog = prefs.getString('blogcategory');
      image_blog = prefs.getString('blogimage');
    });
    print("title_blog$title_blog");
    print("summary_blog$summary_blog");
    print("author_blog$author_blog");
    print("date_blog$date_blog");
    print("desc_blog$desc_blog");
    print("category_blog$category_blog");
    print("image_blog$image_blog");
  }

  getdetails() async {}

  get_blogs() async {
    String url1 = "${widget.blogs_link}";
    print('blogs_link$url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["category"] != null) {
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  @override
  Widget build(BuildContext context) {
    String summary1 = summary_blog;
    String desc1 = desc_blog;

    String summary = Bidi.stripHtmlIfNeeded(summary1);
    String desc = Bidi.stripHtmlIfNeeded(desc1);

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()),
        );
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
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 1,
              itemBuilder: (context, index) {
                if (all_blogs == true) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Blogs_Desc()),
                        );
                      },
                      child: Container(
                        child: Container(
                          // height: size.height * 0.2,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400)),
                          child: Column(
                            children: [
                              Container(
                                  color: Colors.white,
                                  height: size.height * 0.3,
                                  width: size.width,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.network(
                                      image_blog,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      title_blog,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'By ' +
                                              author_blog +
                                              ' / ' +
                                              date_blog,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      summary,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    Text(
                                      desc,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
