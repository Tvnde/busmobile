import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}
class User {
  int id;
  String username;
  String password;

  User({this.id, this.username, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    username: json['username'],
    password: json['password'],
  );
  }
}
class _LoginState extends State<Login> {
  var loginState = '';
  var loginButton = 'LOGIN';

  void findUser() async {
    setState(() {
      loginState = '';
      loginButton = 'Loading...';
    });
    var url = "https://busng.com/forappcheck2";

    Map data = {
      'email': _usernameController.text,
      'password': _passwordController.text
    };
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body,
    );

    var user_details = json.decode(response.body);

    if(user_details["successful"]){
      loginButton = 'LOGIN';
      if(user_details['type'] == 2009) {
        Navigator.pushReplacementNamed(context, '/storekeeper', arguments: {
          'name': user_details['name'],
          'email': user_details['email'],
          'company_name': user_details['company_name'],
          'company_id': user_details['company_id'],
          'user_id': user_details['user_id'],
          'categories': user_details['categories'],
          'products': user_details['all_products'],
        });
      }
      else if(user_details['type'] == 1810) {
        loginButton = 'LOGIN';
        Navigator.pushReplacementNamed(context, '/sales', arguments: {
          'name': user_details['name'],
          'email': user_details['email'],
          'company_name': user_details['company_name'],
          'company_id': user_details['company_id'],
          'user_id': user_details['user_id']

        });
      }
    /* Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              Storekeeper(),
        ),
      ); */
    }
    else if(user_details['error'] == 'No user found'){
      setState(() {
        loginState = "no user found";
        loginButton = 'LOGIN';
      });
    }
    else if(user_details['error'] == 'Invalid Password'){
      setState(() {
        loginState = "incorrect password";
        loginButton = 'LOGIN';
      });
    }
  }

  String _counter, _value = '';

Future scanBarcodeNormal() async {
  String barcodeRes = '';
  barcodeRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
  print(barcodeRes);
  setState(() {
    _value = barcodeRes;
  });
}

  static TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var screen_height = queryData.size.height;
    var screen_width = queryData.size.width;
    var screenBlockHeight = screen_height/100;
    var screenBlockWidth = screen_width/100;
    print(screen_width.toString()+" "+screen_height.toString());
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6FACFF),
                  Color(0xFF568EDA),
                  Color(0xFF4B80C5),
                  Color(0xFF3B6BA2),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: screen_height/35),
                child: Image.asset("assets/login_banner2.png"),
              )
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: screen_width/20.0, top: screen_height/20.0, right: screen_width/20.0,),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset("assets/app_logo.png"),
                    ]
                  ),
                  SizedBox(height: screen_height/5.0),
            Container(
              width: double.infinity,
              height: screen_height/1.9,
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
                        fontSize: screen_height/22,
                        letterSpacing: .6,
                        color: Colors.white70,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screen_height/35,),
                    Text(
                      loginState,
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: screen_width/31.7,
                        fontFamily: "Raleway"
                      ),
                    ),
                    SizedBox(height: screen_height/35,),
                    Text('Email',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: screen_height/35,
                          color: Colors.white70
                      ),
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          hintText: "email",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: screen_height/52,
                          )
                      ),
                    ),
                    SizedBox(height: screen_height/35),
                    Text('Password',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: screen_height/35,
                          color: Colors.white70
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: "password",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: screen_height/52,
                          )
                      ),
                    ),
                    SizedBox(height: screen_height/35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.yellowAccent,
                            fontFamily: 'Raleway',
                            fontSize: screen_height/40,
                          ),)
                      ],
                    )
                  ],
                ),
              ),
            ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              height: screen_height/13,
                              width: screen_width/4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFD7E1EC),
                                    Color(0xFFFFFFFF),
                                  ]
                                ),
                                borderRadius: BorderRadius.circular(6.0)
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: findUser,
                                  child: Center(
                                    child: Text(loginButton,
                                      style: TextStyle(
                                        color: Color(0xFF568EDA),
                                        fontFamily: "Raleway",
                                        fontSize: screen_height/37,
                                        fontWeight: FontWeight.w700
                                      ),),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
/*    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/app_background.jpg'), fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        *//*appBar: AppBar(
          title: Text('Login',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
                fontFamily: 'Montserrat'
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),*//*
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              width: 450,
              height: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/app_logo.png'),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.only(left: 160),
                      child: Image(
                        image: AssetImage('assets/business_plan.png'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 5),
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                              color: Colors.black54,
                            ))
                          ),
                          child: TextField(
                            controller: _usernameController,
                            style: TextStyle(fontSize: 15.0),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.black54)
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                              color: Colors.black54,
                            ))
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: 15),
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.black54)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(child: Text('Forgot Password?', style: TextStyle(color: Colors.white), )),
                  SizedBox(height: 18),
                  ProgressButton(
                    child: Text('Login', style: TextStyle(color: Colors.white),),
                    buttonState: ButtonState.inProgress,
                    onPressed: findUser,
                    backgroundColor: Colors.white24,
                    progressColor: Theme.of(context).primaryColor,
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );*/
  }
}
