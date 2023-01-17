

import 'package:big_in_japan/view1.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
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
      String login = "";
      String password = "";
      var _controller = TextEditingController();
      // middle section
      Widget middleSection=(  
           TextField( 
            controller: _controller,
              onChanged: (text) {
                login = text;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                          BorderSide(color: Colors.blueGrey, width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                BorderSide(color: Colors.blue, width: 5.0)),
                                  suffixIcon: IconButton(
                                    onPressed: _controller.clear,
                                      icon: Icon(Icons.clear)), 
                                        hintText: 'Login',
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                                fontSize: 20,)),)
      );
      Color color = Theme.of(context).primaryColor; 
      Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [TextButton(
        child: Text("Login", style: TextStyle(fontSize: 25)),
        onPressed: (() {
          if(login=="a"){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminView()));}
        }),
        style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                elevation: 2,
                backgroundColor: Colors.red),
                ),

        ],);
        

    
    Widget middleSection2=(TextField(
      controller: _controller, 
        onChanged: (text) {
          password = text;
          },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                      BorderSide(color: Colors.blueGrey, width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                            BorderSide(color: Colors.blue, width: 5.0)),
                              suffixIcon: IconButton(
                                onPressed: _controller.clear,
                                  icon: Icon(Icons.clear)),
                                    hintText: 'Hasło',
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                            fontSize: 20,),),
                                              obscureText: true,));
      return Scaffold(
        backgroundColor: Colors.grey,
          appBar: AppBar(
            centerTitle: true,
              title: Text('Big in Japan'),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
        body:Column(children: [
          titleSection,
            middleSection,
              SizedBox(height: 10),
                middleSection2,
                  SizedBox(height: 10),
                    buttonSection],));
      
          /*child:Stack(
          centerTitle: true,
          title: Text('Big in Japan'),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: Colors.grey
        )
        );*/
        
      
          
           
  





     /*return MaterialApp(
      title: 'Big in Japan',
      home: Scaffold(
        appBar: AppBar(
          centerTitle:true,
          title: Text('Big in Japan'),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: Colors.grey,
        ),
        body: Column(children: [
          titleSection,
          middleSection,
          middleSection2,
          buttonSection
          ],
          ),
      ),
    );   
  }*/
}
}
