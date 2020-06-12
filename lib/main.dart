import 'package:businessunlimitedsolution/pages/oldstock.dart';
import 'package:flutter/material.dart';
import 'package:businessunlimitedsolution/pages/splash.dart';
import 'package:businessunlimitedsolution/pages/login.dart';
import 'package:businessunlimitedsolution/pages/maindashboard.dart';
import 'package:businessunlimitedsolution/pages/storekeeper.dart';
import 'package:businessunlimitedsolution/pages/sales.dart';
import 'package:businessunlimitedsolution/pages/newstock.dart';

void main() => runApp(MaterialApp(
  home: Splash(),
  routes: {
    '/login': (context) => Login(),
    '/dashboard': (context) => MainDashboard(),
    '/storekeeper': (context) => Storekeeper(),
    '/newstock': (context) => Newstock(),
    '/oldstock': (context) => Oldstock(),
    '/sales': (context) => Sales(),
  },
));


