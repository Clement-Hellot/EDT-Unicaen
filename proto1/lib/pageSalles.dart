import 'package:flutter/material.dart';

class PageSalles extends StatefulWidget {
  @override
  _PageSallesState createState() => _PageSallesState();
}

class _PageSallesState extends State<PageSalles> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        child: Text(
          'Salles',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
