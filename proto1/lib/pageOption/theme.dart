import 'package:flutter/material.dart';

/// Le bouton déroulant pour choisir entre clair et sombre
class BoutonTheme extends StatefulWidget {
  BoutonTheme({Key key}) : super(key: key);

  @override
  _BoutonThemeState createState() => _BoutonThemeState();
}

class _BoutonThemeState extends State<StatefulWidget> {
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
          //TODO : implémenter la modification des valeurs du singleton et recharger la page courante pour appliquer le changement de thème
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

class AppTheme {
  //TODO implémenter le thème sombre et le thème clair (singleton stockant les paramètres et duquel les pages chargent les infos ?)
}
