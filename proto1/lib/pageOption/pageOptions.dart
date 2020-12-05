import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
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
      backgroundColor: ThemeProvider.controllerOf(context).theme.data.scaffoldBackgroundColor,
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
                  color: ThemeProvider.themeOf(context).data.textTheme.headline1.color,
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
                  color: ThemeProvider.controllerOf(context).theme.data.textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 35, 35),
                child: BoutonTheme())
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RaisedButton(
              child: const Text('A propos'),
              elevation: 4.0,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => PopupAPropos(),
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
