import 'package:flutter/material.dart';
import 'package:businessunlimitedsolution/pages/login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 7),
        () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
        },
    );
  }
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/app_background.jpg'), fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("BUS Mobile",
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
        ),
        body: Container(
          child: Center(
            child: Image(
                image: AssetImage('assets/app_logo.png')
            ),
          ),
        ),
      ),
    );
  }
}
