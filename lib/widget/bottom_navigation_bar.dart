import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('Content for selected tab goes here'),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: 0, // Set the initial index
          selectedItemColor: Colors.blue, // Color of the selected item
          unselectedItemColor: Colors.grey, // Color of unselected items
          onTap: (int index) {
            // Respond to item tap
            // You can change the content based on the selected tab index
            print('Tapped on item $index');
          },
        ),
      ),
    );
  }
}
