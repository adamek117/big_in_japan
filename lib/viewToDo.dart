import 'package:flutter/material.dart';
import 'main.dart';
import 'loginscreen.dart';
import 'viewToDo.dart';
import 'viewNow.dart';
import 'viewDone.dart';


class AdminViewToDo extends StatelessWidget {
  // up buttonSection
  @override
   Widget build(BuildContext context) {


    Widget titleSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [TextButton(
        child: Text("To-Do", style: TextStyle(fontSize: 25)),
        onPressed: (() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminViewToDo()));}
        ),
        style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                elevation: 2,
                backgroundColor: Colors.white),
                  ),

        TextButton(
        child: Text("Now", style: TextStyle(fontSize: 25)),
        onPressed: (() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminViewNow()));}
        ),
        style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                elevation: 2,
                backgroundColor: Colors.white),
                  ),
        TextButton(
        child: Text("Done", style: TextStyle(fontSize: 25)),
        onPressed: (() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminViewDone()));}
        ),
        style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                elevation: 2,
                backgroundColor: Colors.white),
                  ),

        ],);

      Color color = Theme.of(context).primaryColor; 
      Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
         ElevatedButton(
          onPressed: () {
              Navigator.pop(context);
          },
          child: const Text('Wyloguj się'),
        ),
        ElevatedButton.icon(icon: Icon(Icons.picture_as_pdf), 
        label: Text('Wyeksportuj do PDF-a'), 
        onPressed: () { print("Wyeksportowałeś do PDF-a");},
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: Colors.white)),
        ElevatedButton.icon(icon: Icon(Icons.format_color_fill), 
        label: Text('Zmień kolor'), 
        onPressed: () { print("Funkcja odpowiedzialna za zmiane koloru");},)
        
      ],
    );
   
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle:true,
            title: Text('Admin'),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                backgroundColor: Colors.grey,),
        body: Column(children: [
          titleSection,
          buttonSection,
          ],
          ),
      ),
    );   
    
   }


    










/*Color color = Theme.of(context).primaryColor; 
    //Widget buttonSection = Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //children: [
        //_buildButtonColumn(color, Icons.plus_one_rounded, 'PLUS'),
        //_buildButtonColumn(color, Icons.change_circle, 'CHANGE'),
        //_buildButtonColumn(color, Icons.picture_as_pdf, 'PDF'),
     ] */
}