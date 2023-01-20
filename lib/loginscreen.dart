import 'dart:convert';
import 'package:big_in_japan/InitialPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/users.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  List _data = [];
  List<User> users = [];

  @override
  void initState() {
    getJsonData();
  }

  Future<void> getJsonData() async {
    final String response = await rootBundle.loadString('assets/users.json');
    final data = await jsonDecode(response);
    setState(() {
      _data = data['users'];
      for (var user in _data) {
        List<User> items = [];
        users.add(
          User(
              id: user["id"],
              email: user['email'],
              roles: user['roles'].cast<String>()),
        );
      }
    });
  }

  bool isCorrectUser(email) {
    return users.any((user) => user.email == email);
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
        padding: const EdgeInsets.only(top: 32),
        height: 300.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
        ),
        child: Center(child: Image.asset('assets/kanban.jpg')));

    String login = "";
    String password = "";
    var _controller = TextEditingController();
    var _controller1 = TextEditingController();
    // middle section
    Widget middleSection = (TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _controller,
      onChanged: (hintText) {
        login = hintText;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 5.0)),
          suffixIcon: IconButton(
              onPressed: () => _controller.clear(), icon: Icon(Icons.clear)),
          hintText: 'Login',
          hintStyle: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
            fontSize: 20,
          )),
    ));

    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          child: Text(
            "Log  In",
            style: TextStyle(fontSize: 25),
          ),
          onPressed: (() {
            if (isCorrectUser(login)) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InitialPage()));
            }
          }),
          style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              elevation: 2,
              backgroundColor: Colors.yellowAccent),
        ),
      ],
    );

    Widget middleSection2 = (TextField(
      controller: _controller1,
      onChanged: (hintText) {
        password = hintText;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 5.0)),
        suffixIcon:
            IconButton(onPressed: _controller1.clear, icon: Icon(Icons.clear)),
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.italic,
          fontSize: 20,
        ),
      ),
      obscureText: true,
    ));
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Big in Japan'),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 0,
        ),
        body: Column(
          children: [
            titleSection,
            middleSection,
            SizedBox(height: 10),
            middleSection2,
            SizedBox(height: 10),
            buttonSection
          ],
        ));
  }
}
  
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

