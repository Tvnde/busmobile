import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String name;
  double price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
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
                    size: 15.0,
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
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
