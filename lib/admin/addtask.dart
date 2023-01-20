  
import 'package:flutter/material.dart';
var _controller = TextEditingController();
String task ="";

var _controller1 = TextEditingController();
String task1 ="";

Widget Addtask1 =(    
        TextField(
            controller: _controller,
              onChanged: (hintText) {
                task = hintText;
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
                                        hintText: 'Add Task',
                                          hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                            fontSize: 20,))));



Widget Addtask2=(    
        TextField(
            controller: _controller1,
              onChanged: (hintText) {
                task1 = hintText;
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
                                        hintText: 'Add Task',
                                          hintStyle: TextStyle(
                                          color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                              fontSize: 20,))));

                                            