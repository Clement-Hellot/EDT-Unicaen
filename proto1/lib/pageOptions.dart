import 'package:flutter/material.dart';

class PageOptions extends StatefulWidget {
  @override
  _PageOptionsState createState() => _PageOptionsState();
}

class _PageOptionsState extends State<PageOptions> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        child: Text(
          'Options',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
