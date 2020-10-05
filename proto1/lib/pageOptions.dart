import 'package:flutter/material.dart';

class PageOptions extends StatefulWidget {
  @override
  _PageOptionsState createState() => _PageOptionsState();
}

class _PageOptionsState extends State<PageOptions> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Options',
      style: TextStyle(fontSize: 30),
    );
  }
}
