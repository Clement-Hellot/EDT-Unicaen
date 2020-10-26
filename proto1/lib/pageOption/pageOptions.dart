import 'package:flutter/material.dart';
import 'aPropos.dart';
import 'theme.dart';

//Squelette de la page option :
class PageOptions extends StatefulWidget {
  @override
  _PageOptionsState createState() => _PageOptionsState();
}

class _PageOptionsState extends State<PageOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme().backgroundColor,
      body: Column(
        children: [
          Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 50,
            right: 15,
            bottom: 30,
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Text(
              "Parametres",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: AppTheme().textColor,
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
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
              child: Text(
                "Theme :",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme().textColor
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 35, 35), child: BoutonTheme()
            )
          ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: const Text('A propos'),
                color: AppTheme().backgroundColor,
                elevation: 4.0,
                textColor: AppTheme().textColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => popupAPropos(),
                  );
              // Perform some action
            },
          )
        ])
      ],
    ),
    );
  }
}
