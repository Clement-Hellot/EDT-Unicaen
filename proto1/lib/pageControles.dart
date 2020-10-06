import 'package:flutter/material.dart';

class PageControles extends StatefulWidget {
  @override
  _PageControlesState createState() => _PageControlesState();
}

class _PageControlesState extends State<PageControles> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        child: Text(
          'Contrôles',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
