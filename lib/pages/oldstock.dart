import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Oldstock extends StatefulWidget {
  @override
  _OldstockState createState() => _OldstockState();
}

class Product {
  String name;
  String price;
  String category;
  String details;

  Product(this.name, this.price, this.category, this.details);

  Map toJson() => {
    'name': name,
    'price': price,
    'category': category,
    'details': details
  };
}

class _OldstockState extends State<Oldstock> {

  Map data = {};

  String _productname;
  String _productprice;
  String _productcat;
  String _productdetails;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _sellingController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  var currentProduct = 'Select Item';
  var productCode = '';
  var companyy = 0;
  var productName = '';
  var productCost = '';
  var productSelling = '';
  var productInfo = '';

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
    var details = json.decode(response.body);
    setState(() {
      this.currentProduct = newValue;
      productName = newValue;
      _costController.text = details['cost_price'];
      _sellingController.text = details['selling_price'];
      _nameController.text = newValue;
      productCost = details['cost_price'];
      productSelling = details['selling_price'];
      if(details['qr_info'] == null){
        productCode = 'No Information found';
      } else {
        productCode = details['qr_info'];
      }
    });
  }

  Future scanBarcodeNormal() async {

    String barcodeRes = '';
    barcodeRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
    print(barcodeRes);
    setState(() {
      productCode = barcodeRes;
    });
  }

  void saveInfo() async {
    Map data = {
      'qr_string': productCode,
      'product_name': currentProduct,
      'new_name': _nameController.text,
      'company_id': companyy,
      'product_cost': _costController.text,
      'product_selling': _sellingController.text,
    };
    var body = json.encode(data);
    var url_info = 'https://busng.com/saveinfo';
    http.Response response = await http.post(url_info,
                  headers: {"Content-Type": "application/json"},
                  body: body);
    print(response.body);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 20.6),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height/2.4,
            child: Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 41.1, top: MediaQuery.of(context).size.height / 34.15, right: MediaQuery.of(context).size.width / 41.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Successful!",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: MediaQuery.of(context).size.width/13.7,
                      fontFamily: "Raleway",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 68.3,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6.83,
                    child: Image(
                      image: AssetImage('assets/success.png'),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/68.3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: MediaQuery.of(context).size.height/20,
                          width: MediaQuery.of(context).size.width/5.2,
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
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text("Close",
                                  style: TextStyle(
                                    color: Color(0xFF568EDA),
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w700,
                                    fontSize: MediaQuery.of(context).size.width/27.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      barrierDismissible: true,
    );

  }


  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    MediaQueryData queryData = MediaQuery.of(context);
    var screen_height = queryData.size.height;
    var screen_width = queryData.size.width;
    var products = data['products'];
    companyy = data['company_id'];
    var products2 = ['Select Item'];
    for(var i=0; i<products.length; i++){
      String value = products[i];
      products2.add(value);
    }
    return Scaffold(
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
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: screen_height/6.83, horizontal: screen_width/13.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropdownButton(
                    hint: Text(
                      "Select Product(Product Name)",
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
                      fontSize: screen_width/22.8,
                      fontFamily: "Raleway",
                    ),
                    onChanged: getInfoQR,
                    items: products2.map((String DropdownItem1){
                      return DropdownMenuItem<String>(
                        value: DropdownItem1,
                        child: Text(DropdownItem1),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: screen_height/34.2,),
                  TextField(
                    controller: _nameController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height/68.3),
                          prefixIcon: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          hintText: "No Product Selected(Cost Price)",
                          hintStyle: TextStyle(
                              color: Colors.white54,
                              fontFamily: "Raleway"
                          )
                      ),
                  ),
                  SizedBox(height: 20.0,),
                  TextField(
                    controller: _costController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height/68.3),
                          prefixIcon: Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                          ),
                          hintText: "No Product Selected(Selling Price)",
                          hintStyle: TextStyle(
                              color: Colors.white54,
                              fontFamily: "Raleway"
                          )
                      )
                  ),
                  SizedBox(height: screen_height/34.2,),
                  TextField(
                    controller: _sellingController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height/68.3),
                          prefixIcon: Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                          ),
                          hintText: "No Product Selected",
                          hintStyle: TextStyle(
                              color: Colors.white54,
                              fontFamily: "Raleway"
                          )
                      )
                  ),
                  SizedBox(height: screen_height/34.2,),
                  TextField(
                    controller: _detailsController,
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontSize: screen_width/27.2
                    ),
                  ),
                  Text(
                    productCode,
                    style: TextStyle(
                      fontSize: screen_width/16.44,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  SizedBox(height: screen_height/22.7,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: screen_height/17.1,
                          width: screen_width/5.2,
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
                                    fontSize: screen_width/27.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screen_width/3.4,),
                      InkWell(
                        child: Container(
                          height: screen_height/17.1,
                          width: screen_width/5.2,
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
                              onTap: saveInfo,
                              child: Center(
                                child: Text("Save",
                                  style: TextStyle(
                                    color: Color(0xFF568EDA),
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w700,
                                    fontSize: screen_width/27.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screen_width/41.1, top: screen_height/17.1),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/storekeeper', arguments: {
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
                InkWell(
                  child: Text("Back", style: TextStyle(color: Colors.white, fontSize: screen_width/27.4),),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/storekeeper', arguments: {
                      'name': data['name'],
                      'email': data['email'],
                      'company_name': data['company_name'],
                      'company_id': data['company_id'],
                      'user_id': data['user_id'],
                      'categories': data['categories'],
                      'products': data['products'],
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
