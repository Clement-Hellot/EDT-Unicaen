import 'package:flutter/material.dart';

class PageOptions extends StatefulWidget {
  @override
  _PageOptionsState createState() => _PageOptionsState();
}

class _PageOptionsState extends State<PageOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 35, 35), child: BoutonTheme())
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          RaisedButton(
            child: const Text('à propos'),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            splashColor: Colors.amberAccent,
            textColor: const Color(0xFFFFFFFF),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _popupAPropos(context),
              );
              // Perform some action
            },
          )
        ])
      ],
    );
  }
}

/// Le bouton déroulant pour choisir entre clair et sombre
class BoutonTheme extends StatefulWidget {
  BoutonTheme({Key key}) : super(key: key);

  @override
  _BoutonTheme createState() => _BoutonTheme();
}

class _BoutonTheme extends State<StatefulWidget> {
  String dropdownValue = 'Clair';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black87,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Clair', 'Sombre']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class BoutonAPropos extends StatelessWidget {
  BoutonAPropos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {}
}

Widget _popupAPropos(BuildContext context) {
  return new AlertDialog(
    title: const Text('à propos'),
    content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("test")]),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Fermer'),
      ),
    ],
  );
}
