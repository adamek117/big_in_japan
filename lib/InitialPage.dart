import 'package:big_in_japan/admin/Done.dart';
import 'package:big_in_japan/admin/ToDo.dart';
import 'package:flutter/material.dart';

import 'admin/Now.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  List pages = [];
  int _currentIndex = 0;
  @override
  void initState() {
    setState(() {
      pages = [ToDo(), Now(), Done()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel), label: 'In Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done')
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
