import 'package:flutter/material.dart';
import 'main.dart';

class AdminView extends StatelessWidget {
  // up buttonSection
  @override
   Widget build(BuildContext context) {


    Widget titleSection = Container(
    padding: const EdgeInsets.all(32),
    child: const Text(
      'Zaloguj się na swoje konto, aby uzyskać dostęp do swojej TO-DO-LISTY',
      softWrap: true,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

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