import 'dart:async';
import 'dart:convert';
import 'package:businessunlimitedsolution/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Newstock extends StatefulWidget {
  @override
  _NewstockState createState() => _NewstockState();
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

class _NewstockState extends State<Newstock> {

  Map data = {};

  String _productname;
  String _productprice;
  String _productcat;
  String _productdetails;
  String _productinfo;
  String producttoJson;
  int _productQuantity;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _sellingController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var codeString = '';
  var currentCategory = 'Select Category';
  var userr = 0;
  var companyy = 0;

  Future scanBarcodeNormal() async {

    String barcodeRes = '';
    barcodeRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
    print(barcodeRes);
    setState(() {
      codeString = barcodeRes;
    });
  }


  void tester() async {
    print(codeString);
    Product product1 = Product(_nameController.text, _costController.text, _sellingController.text, currentCategory, _quantityController.text, _detailsController.text);
    Map data = {
      'product_name': product1.name,
      'product_price_cost': product1.price_cost,
      'product_price_selling': product1.price_selling,
      'category': currentCategory,
      'product_details': product1.details,
      'code_info': codeString,
      'product_quantity': product1.quantity,
      'user_id': userr,
      'company_id': companyy,
    };
    var body = json.encode(data);

    var url_product = 'https://busng.com/saveproduct';

    http.Response response = await http.post(url_product,
        headers: {"Content-Type":"application/json"},
        body: body);
    print(response.body);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text('Successful!'),
          content: Image(
            image: AssetImage('assets/success.png'),
          ),
        );
      },
      barrierDismissible: true,
    );

    producttoJson = await  Future.delayed(Duration(seconds: 1), () {return jsonEncode(product1);});
    print('$producttoJson');
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
                      image: AssetImage('assets/success.gif'),
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

  Widget _buildProductName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Product Name",
          style: TextStyle(
            color: Colors.white70,
            fontSize: MediaQuery.of(context).size.width/29.4,
            fontFamily: "Raleway",
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height/68.3,),
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
          height: MediaQuery.of(context).size.height/11.4,
          child: TextField(
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
                  hintText: "Enter Product Name",
                  hintStyle: TextStyle(
                      color: Colors.white54,
                      fontFamily: "Raleway"
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget _buildProductCostPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Product Price (Cost)",
          style: TextStyle(
            color: Colors.white70,
            fontSize: MediaQuery.of(context).size.width/29.4,
            fontFamily: "Raleway",
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height/68.3,),
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
          height: MediaQuery.of(context).size.height/11.4,
          child: TextField(
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
                  hintText: "Enter Product Cost Price",
                  hintStyle: TextStyle(
                      color: Colors.white54,
                      fontFamily: "Raleway"
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget _buildProductSellingPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Product Price (Selling)",
          style: TextStyle(
            color: Colors.white70,
            fontSize: MediaQuery.of(context).size.width/29.4,
            fontFamily: "Raleway",
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height/68.3,),
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
          height: MediaQuery.of(context).size.height/11.4,
          child: TextField(
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
                  hintText: "Enter Product Selling Price",
                  hintStyle: TextStyle(
                      color: Colors.white54,
                      fontFamily: "Raleway"
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget _buildProductQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Product Quantity",
          style: TextStyle(
            color: Colors.white70,
            fontSize: MediaQuery.of(context).size.width/29.4,
            fontFamily: "Raleway",
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height/68.3,),
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
          height: MediaQuery.of(context).size.height/11.4,
          child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.white70,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height/68.3),
                  prefixIcon: Icon(
                    Icons.dialpad,
                    color: Colors.white,
                  ),
                  hintText: "Enter Product Quantity",
                  hintStyle: TextStyle(
                      color: Colors.white54,
                      fontFamily: "Raleway"
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Product Details",
          style: TextStyle(
            color: Colors.white70,
            fontSize: MediaQuery.of(context).size.width/29.4,
            fontFamily: "Raleway",
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height/68.3,),
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
          height: MediaQuery.of(context).size.height/11.4,
          child: TextField(
              controller: _detailsController,
              style: TextStyle(
                color: Colors.white70,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height/68.3),
                  prefixIcon: Icon(
                    Icons.create,
                    color: Colors.white,
                  ),
                  hintText: "Product Description",
                  hintStyle: TextStyle(
                      color: Colors.white54,
                      fontFamily: "Raleway"
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget _buildProductCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Product Code",
          style: TextStyle(
            color: Colors.white70,
            fontSize: MediaQuery.of(context).size.width/29.4,
            fontFamily: "Raleway",
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height/68.3,),
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
            height: MediaQuery.of(context).size.height/11.4,
            child: Text(
              "Code Information: "+codeString,
              style: TextStyle(
                color: Colors.white70,
              ),
            )
        ),
      ],
    );
  }
  bool pressed = false;
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
    userr = data['user_id'];
    companyy = data['company_id'];
    print(data['user_id']);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('New Product',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Raleway",
                        fontSize: screen_width/13.7
                    ),
                  ),
                  SizedBox(height: screen_height/22.8,),
                  _buildProductName(),
                  SizedBox(height: screen_height/34.2,),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Product Category",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screen_width/29.3,
                            fontFamily: "Raleway",
                          ),
                        ),
                        SizedBox(height: screen_height/68.3,),
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
                          height: screen_height/11.4,
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
                              fontSize: screen_width/23,
                              fontFamily: "Raleway",
                            ),
                            onChanged: (currentValue) {
                              setState(() {
                                currentCategory = currentValue;
                              });
                            },
                            items: categories2.map((String DropdownItem1){
                              return DropdownMenuItem<String>(
                                value: DropdownItem1,
                                child: Text(DropdownItem1),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: screen_height/34.2),
                        _buildProductCostPrice(),
                        SizedBox(height: screen_height/34.2),
                        _buildProductSellingPrice(),
                        SizedBox(height: screen_height/34.2),
                        _buildProductQuantity(),
                        SizedBox(height: screen_height/34.2),
                        _buildProductDetails(),
                        SizedBox(height: screen_height/34.2),
                        _buildProductCode(),
                        SizedBox(height: screen_height/34.2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                height: screen_height/17.1,
                                width: screen_width/5.1,
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
                            SizedBox(width: screen_width/2.3),
                            InkWell(
                              child: Container(
                                height: screen_height/17.1,
                                width: screen_width/5.1,
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
                                          fontSize: screen_width/27.4,
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
