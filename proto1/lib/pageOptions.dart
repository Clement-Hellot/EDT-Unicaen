import 'package:flutter/material.dart';

class PageOptions extends StatefulWidget {
  @override
  _PageOptionsState createState() => _PageOptionsState();
}

class _PageOptionsState extends State<PageOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 50, bottom: 30),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Text(
            "Parametres",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      Row(children: [
        Expanded(
            child: Divider(
          thickness: 2,
          color: Colors.black,
          indent: 30,
          endIndent: 30,
        ))
      ])
    ]);
  }
}
