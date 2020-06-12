import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:businessunlimitedsolution/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:progress_button/progress_button.dart';

class FormCard extends StatefulWidget {
  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
      width: double.infinity,
      height: 300.0,
      decoration: BoxDecoration(
          color: Color.fromRGBO(75, 128, 197, 0.8),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0
            ),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -12.0),
                blurRadius: 10.0
            )
          ]
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Login",
              style: TextStyle(
                fontSize: 30.0,
                letterSpacing: .6,
                color: Colors.white70,
                fontFamily: "Raleway",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30.0,),
            Text('Email',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 20.0,
                  color: Colors.white70
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "email",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 13.0,
                  )
              ),
            ),
            SizedBox(height: 20.0,),
            Text('Password',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 20.0,
                  color: Colors.white70
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "password",
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 13.0,
                  )
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontFamily: 'Raleway',
                    fontSize: 16.0,
                  ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}


