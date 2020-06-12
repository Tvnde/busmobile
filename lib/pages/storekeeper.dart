import 'dart:async';
import 'dart:convert';
import 'package:businessunlimitedsolution/pages/login.dart';
import 'package:businessunlimitedsolution/pages/newstock.dart';
import 'package:businessunlimitedsolution/pages/oldstock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Storekeeper extends StatefulWidget {
  @override
  _StorekeeperState createState() => _StorekeeperState();
}

class Product {
  String name;
  String price_cost;
  String price_selling;
  String quantity;
  String category;
  String details;

  Product(this.name, this.price_cost, this.price_selling, this.category, this.quantity, this.details);

  Map toJson() => {
    'name': name,
    'price_cost': price_cost,
    'price_selling': price_selling,
    'category': category,
    'quantity': quantity,
    'details': details
  };
}

class _StorekeeperState extends State<Storekeeper> {

  Map data = {};
  var companyy = 0;
  var userr = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var codeString = '';
  var currentCategory = 'Select Category';
  var currentProduct = 'Select Product';
  String productName = 'No Product Selected';
  String producttoJson;
  int currentIndex_ = 0;
  var categories_arr = ['string'];
  var products_arr = ['string'];


  void getProducts() async {
    Map data = {
      "company_id": companyy,
      "user_id": userr
    };
    var body = json.encode(data);
    var url = "https://busng.com/allproducts";
    http.Response response = await http.post(url,
                  headers: {"Content-Type": "application/json"},
                  body: body);
    print(json.decode(response.body)[0]);
    Navigator.pushNamed(context, '/oldstock', arguments: {
      'all_products': json.decode(response.body),
      'user_id': userr,
      'company_id': companyy,
    });

  }

  Future scanBarcodeNormal() async {

    String barcodeRes = '';
    barcodeRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
    print(barcodeRes);
    setState(() {
      currentIndex_ = 0;
      codeString = barcodeRes;
    });
  }

  void getInfoQR(String newValue) async {
    Map data2 = {
      'product_name': newValue
    };
    var body = json.encode(data2);
    var url_qr = "https://busng.com/productinfo";
    var response = await http.post(url_qr,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var detail  =json.decode(response.body);
    print(json.decode(response.body)['qr_info']);
    print(detail['product_name']);
    setState(() {
      currentIndex_ = 1;
      currentProduct = newValue;
      productName = detail['product_name'];
      if(detail['qr_info'] == null){
        codeString = 'No Information found';
      } else {
        codeString = detail['qr_info'];
      }
    });
  }


  bool pressed = false;


   /*Widget _newProductTab() {
    codeString = '';
    return Stack(
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
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('New Product',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Raleway",
                      fontSize: 30.0
                  ),
                ),
                SizedBox(height: 30.0,),
                _buildProductName(),
                SizedBox(height: 20.0,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Product Category",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                          fontFamily: "Raleway",
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Color(0xFF4B80C5),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.0,
                                offset: Offset(0,2),
                              )
                            ]
                        ),
                        height: 60.0,
                        child: DropdownButton(
                          hint: Text(
                            "Select Category",
                            style: TextStyle(
                                color: Colors.white54,
                                fontFamily: "Raleway"
                            ),
                          ),
                          dropdownColor: Color(0xFF4B80C5),
                          icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white70,),
                          iconSize: 20.0,
                          isExpanded: true,
                          value: currentCategory,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.0,
                            fontFamily: "Raleway",
                          ),
                          onChanged: (currentValue) {
                            setState(() {
                              currentCategory = currentValue;
                            });
                          },
                          items: categories_arr.map((String DropdownItem1){
                            return DropdownMenuItem<String>(
                              value: DropdownItem1,
                              child: Text(DropdownItem1),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      _buildProductCostPrice(),
                      SizedBox(height: 20.0,),
                      _buildProductSellingPrice(),
                      SizedBox(height: 20.0,),
                      _buildProductQuantity(),
                      SizedBox(height: 20.0,),
                      _buildProductDetails(),
                      SizedBox(height: 20.0,),
                      _buildProductCode(),
                      SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD7E1EC),
                                      Color(0xFFFFFFFF),
                                    ]
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: scanBarcodeNormal,
                                  child: Center(
                                    child: Text("Scan",
                                      style: TextStyle(
                                        color: Color(0xFF568EDA),
                                        fontFamily: "Raleway",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 180,),
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD7E1EC),
                                      Color(0xFFFFFFFF),
                                    ]
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: tester,
                                  child: Center(
                                    child: Text("Save",
                                      style: TextStyle(
                                        color: Color(0xFF568EDA),
                                        fontFamily: "Raleway",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]
                ),
              ],
            ),
          ),
        )
      ],
    );
  }*/

/*  Widget _existingProductTab() {
    codeString = '';
    return Stack(
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
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                DropdownButton(
                  hint: Text(
                    "Select Product",
                    style: TextStyle(
                        color: Colors.white54,
                        fontFamily: "Raleway"
                    ),
                  ),
                  dropdownColor: Color(0xFF4B80C5),
                  icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white70,),
                  iconSize: 20.0,
                  isExpanded: true,
                  value: currentProduct,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18.0,
                    fontFamily: "Raleway",
                  ),
                  onChanged: getInfoQR,
                  items: products_arr.map((String DropdownItem1){
                    return DropdownMenuItem<String>(
                      value: DropdownItem1,
                      child: Text(DropdownItem1),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.0,),
                Text(
                  'NAME',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 16.0
                  ),
                ),
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.yellowAccent,
                  ),
                )
              ],
            ),
          ),
        )

      ],
    );
  }*/

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    MediaQueryData queryData = MediaQuery.of(context);
    var screen_height = queryData.size.height;
    var screen_width = queryData.size.width;
    companyy = data['company_id'];
    userr = data['user_id'];
    var categories2 = ['Select Category'];
    var categories = data['categories'];
    var products2 = ['Select Product'];
    var products = data['products'];
    for(var i=0; i<categories.length; i++){
      String value = categories[i];
      categories2.add(value);
    }
    for(var j=0; j<products.length; j++){
      String value = products[j];
      products2.add(value);
    }
    categories_arr = categories2;
    products_arr = products2;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: screen_width/41.5, top: screen_height/6.83, right: screen_width/41.5,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "StoreKeeper",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screen_width/16.5,
                      fontFamily: "Raleway",
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screen_width/27.5,
                      fontFamily: "Raleway",
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: screen_height/17.1,),
                  Padding(
                    padding: EdgeInsets.only(left: screen_width/8.25, right: screen_width/8.25),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            height: screen_height/5.7,
                            width: screen_width/4.1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFD7E1EC),
                                    Color(0xFFFFFFFF),
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: screen_height/68.3,),
                                    Icon(
                                      Icons.add_circle,
                                      color: Color(0xFF568EDA),
                                      size: 60.0,
                                    ),
                                    SizedBox(height: screen_height/136.5,),
                                    Text(
                                      "New Product",
                                      style: TextStyle(
                                        color: Color(0xFF568EDA),
                                        fontSize: screen_width/27.5,
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, '/newstock', arguments: {
                                    'name': data['name'],
                                    'email': data['email'],
                                    'company_name': data['company_name'],
                                    'company_id': data['company_id'],
                                    'user_id': data['user_id'],
                                    'categories': data['categories'],
                                    'products': data['products'],
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screen_width/5.9,),
                        InkWell(
                          child: Container(
                            height: screen_height/5.7,
                            width: screen_width/4.1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFD7E1EC),
                                    Color(0xFFFFFFFF),
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: screen_height/68.3,),
                                    Icon(
                                      Icons.mode_edit,
                                      color: Color(0xFF568EDA),
                                      size: 60.0,
                                    ),
                                    SizedBox(height: screen_height/136.5,),
                                    Text(
                                      "Edit Product",
                                      style: TextStyle(
                                        color: Color(0xFF568EDA),
                                        fontSize: screen_width/27.5,
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, '/oldstock', arguments: {
                                    'name': data['name'],
                                    'email': data['email'],
                                    'company_name': data['company_name'],
                                    'company_id': data['company_id'],
                                    'user_id': data['user_id'],
                                    'categories': data['categories'],
                                    'products': data['products'],
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screen_width/41.2, top: screen_height/17.2, right: screen_width/41.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.exit_to_app, color: Colors.white,),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
                InkWell(
                  child: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 18.0),),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
    /*return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/app_background.jpg'), fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            FlatButton(
              color: Colors.white24,
              child: Text('Logout',
                style: TextStyle(color: Colors.white70, ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            SizedBox(height: 100,),
            FlatButton(
              color: Colors.white24,
              padding: EdgeInsets.all(10),
              onPressed: getProducts,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.white)
              ),
              child: Center(
                child: Text("Existing Product", style: TextStyle(color:Colors.white)),
              ),
            ),
            SizedBox(height: 18),
            FlatButton(
              color: Colors.white24,
              padding: EdgeInsets.all(10),
              onPressed: () {
                Navigator.pushNamed(context, '/newstock', arguments: {
                  'user_id': userr,
                  'company_id': companyy,
                  'categories': data['categories'],
                });
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.white)
              ),
              child: Center(
                child: Text("New Product", style: TextStyle(color:Colors.white)),
              ),
            )
          ],
        ),
      ),
    );*/
  }
}


