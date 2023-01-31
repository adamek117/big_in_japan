import 'dart:convert';
import 'dart:async';
import 'package:big_in_japan/views/InitialPage.dart';
import 'package:big_in_japan/models/users.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  late Future<User> futureUser;
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    getRequest();
    //futureUser = fetchUser();
    //getJsonData();
  }

  Future<void> getRequest() async {
    String url = "http://10.0.2.2:3000/users";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    final b = responseData.cast<Map<String, dynamic>>();
    setState(() {
      for (var singleUser in b) {
        User user = User(
          id: singleUser["id"],
          email: singleUser["email"],
          roles: singleUser["roles"].cast<String>(),
        );
        users.add(user);
      }
    });
  }

  bool isCorrectUser(email) {
    return users.any((user) => user.email == email);
  }

  User getUserByEmail(email) {
    return users.where((user) => user.email == email).first;
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
        padding: const EdgeInsets.only(top: 32),
        height: 200.0,
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
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 5.0)),
          suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: const Icon(Icons.clear)),
          hintText: 'Login',
          hintStyle: const TextStyle(
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
          onPressed: (() {
            if (isCorrectUser(login)) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InitialPage(user: getUserByEmail(login))));
            }
          }),
          style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              elevation: 2,
              backgroundColor: Colors.yellowAccent),
          child: const Text(
            "Log  In",
            style: TextStyle(fontSize: 25),
          ),
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
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 5.0)),
        suffixIcon: IconButton(
            onPressed: _controller1.clear, icon: const Icon(Icons.clear)),
        hintText: 'Password',
        hintStyle: const TextStyle(
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
          title: const Text('Big in Japan'),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 0,
        ),
        body: ListView(
          shrinkWrap: false,
          children: [
            titleSection,
            middleSection,
            const SizedBox(height: 10),
            middleSection2,
            const SizedBox(height: 10),
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

