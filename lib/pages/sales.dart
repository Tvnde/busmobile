import 'dart:async';
import 'dart:convert';
import 'package:businessunlimitedsolution/pages/storekeeper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

class Sales extends StatefulWidget {
  @override
  _SalesState createState() => _SalesState();
}

class Product {
  int id;
  String name;
  int quantity;
  double price;
  double sale_price;

  Product({this.id, this.name, this.price, this.quantity, this.sale_price});

  Map toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'price': price,
    'sale_price': sale_price
  };
}

var products = <Product>[

];



class _SalesState extends State<Sales> {
  Widget tableBody() => DataTable(
    sortColumnIndex: 0,
    columns: <DataColumn>[
      DataColumn(
        label: Text('Product Name',
        style: TextStyle(color: Colors.white70),
        ),
        numeric: false,
        tooltip: 'Scan Product'
      ),
      DataColumn(
        label: Text('Quantity',
        style: TextStyle(color: Colors.white70),
        ),
        numeric: true,
      ),
      DataColumn(
        label: Text('Price',
        style: TextStyle(color: Colors.white70),
        ),
        numeric: true,
      )
    ],
    rows: products.map((product) => DataRow(
      cells: [
        DataCell(
            Text(product.name,style: TextStyle(color: Colors.white70)),
            showEditIcon: false,
            placeholder: false
        ),
        DataCell(
          Row(
            children: <Widget>[
              new IconButton(
                  icon: Icon(Icons.remove, color: Colors.white70,),
                  onPressed: () {
                    setState(() {
                      if(product.quantity > 1) {
                        product.quantity--;
                        product.price = product.sale_price * product.quantity;
                        totalPrice = totalPrice - product.sale_price;
                      }
                    });
                  }
              ),
              new Text(product.quantity.toString(), style: TextStyle(color: Colors.white70),),
              new IconButton(
                  icon: new Icon(Icons.add, color: Colors.white70,),
                  onPressed: (){
                    setState(() {
                      product.quantity++;
                      product.price = product.sale_price * product.quantity;
                      totalPrice = totalPrice + product.sale_price;
                    });
                  }
              ),
            ],
          ),
          showEditIcon: false,
          onTap: (){
            setState(() {
              product.quantity++;
              product.price = product.sale_price * product.quantity;
            });
          },
          placeholder: false,
        ),
        DataCell(
          Text(product.price.toString(),style: TextStyle(color: Colors.white70)),
          showEditIcon: false,
          placeholder: false
        )
      ]
    )).toList(),
  );
  double totalPrice = 0.0;

  void testAddProduct() async {
    Map data = {
      "product_info": 'this is a test qr for a product'
    };
    var body = json.encode(data);
    var url_product = 'https://busng.com/getproduct';
    http.Response response = await http.post(url_product,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print(response.body);
    var holder1 = json.decode(response.body);
    print(holder1);
    print(holder1['product_name']);
    print(holder1['selling_price']);
    products.add(Product(id: holder1['id'], name: holder1['product_name'], price: double.parse(holder1['selling_price']), quantity: 1, sale_price: double.parse(holder1['selling_price'])));
    setState(() {
      totalPrice = totalPrice + double.parse(holder1['selling_price']);
    });
  }

  Future scanBarcodeNormal() async {
    String barcodeRes = '';
    barcodeRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
    print(barcodeRes);
    Map data = {
      "product_info": barcodeRes
    };
    var body = json.encode(data);
    var url_product = 'https://busng.com/getproduct';
    http.Response response = await http.post(url_product,
                  headers: {"Content-Type": "application/json"},
                  body: body
    );
    print(response.body);
    var holder1 = json.decode(response.body);
    print(holder1);
    print(holder1['product_name']);
    print(holder1['selling_price']);
    products.add(Product(id: holder1['id'], name: holder1['product_name'], price: double.parse(holder1['selling_price']), quantity: 1, sale_price: double.parse(holder1['selling_price'])));

    setState(() {
      totalPrice = totalPrice + double.parse(holder1['selling_price']);


    });
  }

  Ticket testTicket() {
    final Ticket ticket = Ticket(PaperSize.mm80);
    
    ticket.text('ITEMS SOLD  Quantity  Price');
    ticket.text('Special1: A B C D', styles: PosStyles(codeTable: PosCodeTable.westEur));

    ticket.feed(2);
    ticket.cut();
    return ticket;
  }

  void printTicket() async {
    /*final PrinterBluetoothManager printerBluetoothManager = PrinterBluetoothManager();
    printerBluetoothManager.scanResults.listen((printers) {

    });
    printerBluetoothManager.startScan(Duration(seconds: 15));
*/
   /* printerBluetoothManager.selectPrinter(printer);*/
    final PrinterNetworkManager printerManager = PrinterNetworkManager();
    printerManager.selectPrinter('192.168.123.100', port: 9100);
    final PosPrintResult res = await printerManager.printTicket(testTicket());

    print('Print results: ${res.msg}');
  }

  void saveOrder() async {
    Map data = {
      "all_products": products,
      "user_id": data_main['user_id'],
      "company_id": data_main['company_id'],
      "total_price": totalPrice
    };
    var body = json.encode(data);

    var url_order = 'https://busng.com/savesales';
    http.Response response = await http.post(url_order,
                  headers: {"Content-Type": "application/json"},
                  body: body);
    print(response.body);
    products.clear();
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
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 34.1, top: MediaQuery.of(context).size.height / 34.15, right: MediaQuery.of(context).size.width / 41.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                onTap: printTicket,
                                child: Center(
                                  child: Text("Print",
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 27.4,
                        ),
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
    setState(() {
      totalPrice = 0.0;
    });
  }

  Map data_main = {};

  Widget ItemCard(int id, String name, double price, int quantity, double sale_price) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add_shopping_cart,
                    color: Color(0xFF568EDA),
                    size: 30.0,
                  ),
                  SizedBox(width: 13.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        price.toString(),
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                              child:Icon(
                                Icons.remove,
                                color: Color(0xFF568EDA),
                            ),
                            onTap: () {
                                print(quantity);
                                print(quantity - 1);
                              setState(() {
                              if(quantity > 1) {
                              quantity--;
                              price = sale_price * quantity;
                              totalPrice = totalPrice - sale_price;
                              }
                            });
                            }
                          ),
                          Text(
                              quantity.toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0
                              ),
                          ),
                          InkWell(
                            child:Icon(
                              Icons.add,
                              color: Color(0xFF568EDA),
                            ),
                            onTap: () {
                              setState(() {
                                quantity++;
                                price = sale_price * quantity;
                                totalPrice = totalPrice + sale_price;
                              });
                            },
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Color(0xFF568EDA),
              ),
              onPressed: () {
                products.remove(Product(id: id, name: name, price: price, quantity: quantity, sale_price: sale_price));
                print(products);
                print(Product(id: id, name: name, price: price, quantity: quantity, sale_price: sale_price).toJson());
                print(id);
                setState(() {

                });
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data_main = ModalRoute.of(context).settings.arguments;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var screen_height = mediaQuery.size.height;
    var screen_width = mediaQuery.size.width;
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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 10.2, top: screen_height/21, right: 10.2,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
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
                      ),
                    ],
                  ),
                  SizedBox(height: screen_height/18,),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text("New Sale",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Raleway",
                        fontSize: screen_width/13
                      ),
                    ),
                  ),
                  SizedBox(height: screen_height/19,),
                  InkWell(
                    child: Container(
                      height: screen_height/18,
                      width: screen_width/3.5,
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
                            child: Text("Scan Product",
                              style: TextStyle(
                                color: Color(0xFF568EDA),
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w700,
                                fontSize: screen_width/28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screen_height/35),
                  Container(
                    height: screen_height/1.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0)),
                    ),
                    child: ListView(
                      primary: false,
                      padding: EdgeInsets.only(left: screen_width/20.5, right: screen_width/20.5),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: screen_height/24),
                          child: Container(
                            height: screen_height/1.8,
                            child: ListView(
                              children: products.map((product) => Padding(
                                padding: EdgeInsets.only(left: screen_width/41, right: screen_width/41, bottom: screen_height/23),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.add_shopping_cart,
                                              color: Color(0xFF568EDA),
                                              size: screen_width/14,
                                            ),
                                            SizedBox(width: screen_width/32,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  product.name,
                                                  style: TextStyle(
                                                    fontFamily: "Raleway",
                                                    fontSize: screen_width/28,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  product.price.toString(),
                                                  style: TextStyle(
                                                    fontFamily: "Raleway",
                                                    fontSize: screen_width/28,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    InkWell(
                                                        child:Icon(
                                                          Icons.remove,
                                                          color: Color(0xFF568EDA),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            if(product.quantity > 1) {
                                                              product.quantity--;
                                                              product.price = product.sale_price * product.quantity;
                                                              totalPrice = totalPrice - product.sale_price;
                                                            }
                                                          });
                                                        }
                                                    ),
                                                    Text(
                                                      product.quantity.toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: screen_width/28
                                                      ),
                                                    ),
                                                    InkWell(
                                                      child:Icon(
                                                        Icons.add,
                                                        color: Color(0xFF568EDA),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          product.quantity++;
                                                          product.price = product.sale_price * product.quantity;
                                                          totalPrice = totalPrice + product.sale_price;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Color(0xFF568EDA),
                                        ),
                                        onPressed: () {
                                          products.remove(product);
                                          setState(() {

                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screen_height/23,),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: screen_height/20,
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
                              onTap: saveOrder,
                              child: Center(
                                child: Text("Save",
                                  style: TextStyle(
                                    color: Color(0xFF568EDA),
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w700,
                                    fontSize: screen_width/27.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screen_width / 3.2,),
                      Text(
                        "Total: ",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: screen_width / 27.4,
                          fontFamily: "Raleway",
                        ),
                      ),
                      Text(
                        totalPrice.toString(),
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontFamily: "Raleway",
                            fontSize: screen_width/13.7
                        ),
                      )
                    ],
                  )
                ]
              ),
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
            SizedBox(
              width: 100,
              height: 40,
              child: FlatButton(
                color: Colors.white24,
                padding: EdgeInsets.all(10),
                onPressed: testAddProduct,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.white)
                ),
                child: Center(
                  child: Text("Scan Product", style: TextStyle(color:Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 13,),
            tableBody(),
            SizedBox(height: 10,),
            Text('Total Price: '+totalPrice.toString(),
            style: TextStyle(
              fontSize: 25,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            )
            ,SizedBox(height: 30,),
            Center(
              child: SizedBox(
                width: 120,
                height: 40,
                child: FlatButton(
                  color: Colors.white24,
                  padding: EdgeInsets.all(10),
                  onPressed: saveOrder,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.white)
                  ),
                  child: Center(
                    child:Text('Submit',
                    style: TextStyle(color: Colors.white70,),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );*/
  }
}
