import 'package:big_in_japan/screens/screens.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big in Japan',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //primarySwatch: Colors.blue,
      ),
    //initialRoute: HomeScreen.routeName,
    // routes: {
      //HomeScreen.routeName:(context) => HomeScreen(),
      //DetailsScreen.routeName :(context) => DetailsScreen()   
       //},
       home: HomeScreen(), 
    );
  }
}


