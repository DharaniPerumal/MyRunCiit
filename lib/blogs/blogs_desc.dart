import 'package:flutter/material.dart';
import 'package:myrunciit/blogs/blogs_drawer.dart';

class Blogs_Desc extends StatefulWidget {
  const Blogs_Desc({super.key});

  @override
  State<Blogs_Desc> createState() => _Blogs_DescState();
}

class _Blogs_DescState extends State<Blogs_Desc> {
  bool all_blogs = true;
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
                        Icons.menu,color: Colors.white,size: 25,),
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
              width: size.width ,
              height: size.height,
              color: Colors.blue,
              child:  ListView.builder(
                scrollDirection: Axis.vertical,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child:

                      InkWell(
                        onTap: (){
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const Categories2()),
                          // );

                        },
                        child: Container(

                          child: Container(
                            height: size.height,
                            width: size.width,

                            decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.grey.shade400)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    color: Colors.white,
                                    height: size.height*0.2,width: size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('asset/banner_2.jpg',fit: BoxFit.fitHeight,),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("benefits of honey",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(('By thillai / 2023-10-27')),
                                          Text(('23-11-2023')),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Text(('McCain Potato Smiles are BACK'))
                                    ],
                                  ),
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


      ),
    );

  }
}
