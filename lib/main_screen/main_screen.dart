import 'package:flutter/material.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/main_screen/register_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';

class Main_screen extends StatefulWidget {
  const Main_screen({Key? key}) : super(key: key);

  @override
  State<Main_screen> createState() => _Main_screenState();
}

class _Main_screenState extends State<Main_screen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: size.height,
                width: size.width,
                // color: Colors.white,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('asset/bg.jpg'), fit: BoxFit.cover,)),

              ),
            ),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Container(
                  height: size.height*0.15,
                  width: size.width,
                  child:Padding(
                    padding: const EdgeInsets.fromLTRB(45, 15, 45, 50),
                    child: Image.asset('asset/logo.png', fit: BoxFit.contain),
                  ),
                  decoration: const BoxDecoration(color:Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(70.0),
                        bottomRight: Radius.circular(70.0),
                      ),
                      // image: DecorationImage(image: AssetImage('asset/logo.png'),
                      //   fit: BoxFit.fill,
                      //   scale: 1.0
                      //
                      // )
                  ),
                ),
              ),
            SizedBox(height: size.height*0.4),
            Padding(
              padding: const EdgeInsets.only(top: 290),
              child: Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                   children: [

                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         height: size.height*0.04,
                         width: size.width,
                         child: ElevatedButton(onPressed: (){
                           Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => LoginScreen()),
                         );
                           },style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(Color(0xffc40001)), ),
                             child: const Text("Already a customer? Sign in",style: TextStyle(color: Colors.white))
                         ),
                       ),
                     ),
                     SizedBox(height: size.height*0.006),

                     Padding(
                       padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                       child: Container(
                         height: size.height*0.04,

                         width: size.width,
                         child: ElevatedButton(onPressed: (){
                           Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => RegisterScreen()),
                         );
                           },
                             child: const Text("New to Myrunciit ? Create an account", style: TextStyle(color: Colors.black)),style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all<Color>(Colors.white), )

                         ),
                       ),
                     ),
                     SizedBox(height: size.height*0.006),

                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         height: size.height*0.04,

                         width: size.width,
                         child: ElevatedButton(onPressed: (){
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => ProductScreen()),
                           );
                         }, child: const Text("Skip sign in", style: TextStyle(color: Colors.black),),style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all<Color>(Colors.white), )

                         ),
                       ),
                     )
                   ],
    )
              ),
            )],
        ),
      );

  }
}

