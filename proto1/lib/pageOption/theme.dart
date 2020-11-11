import 'pageOptions.dart';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../pageEdt.dart';

/// Le bouton déroulant pour choisir entre clair et sombre
class BoutonTheme extends StatefulWidget {
  BoutonTheme({Key key}) : super(key: key);

  @override
  _BoutonThemeState createState() => _BoutonThemeState();
}

class _BoutonThemeState extends State<StatefulWidget> {
  String dropdownValue = AppTheme().etat;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          if (newValue != dropdownValue) {
            AppTheme().changerTheme(context);
            dropdownValue = newValue;
            //TODO refresh la page courante
          }
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
  //Singleton
  static AppTheme _instance = AppTheme._internal(); //Instancié au lancement

  /*Constance de thème
  Color _backgroundSombre = Color(0xFF050E25), _backgroundClair = Color(0xFFFCFCFC);
  Color _textSombre = Color(0xFFFFFFFF), _textClair = Color(0xFF3D3D3D);
  Color _iconSombre = Color(0xFF20AFFF), _iconClair = Color(0xFFC4C4C4);
  Color _topBarColorSombre = Color(0xFF050E25), _topBarColorClair = Color(0xFF42AFEC);*/

  //Thème courant et valeurs courantes
  ThemeData theme;
  bool isClair;
  String etat;

  factory AppTheme() {
    //Constructeur : retourne l'instance du singleton
    return _instance;
  }

  AppTheme._internal() {
    //"Vrai" constructeur (initialise l'appli sur le thème de l'utilisateur
    isClair = true;
    etat = "Clair";
  }

  void changerTheme(BuildContext context) {
    //Applique le thème actuellement choisi
    isClair = !isClair;
    if (isClair) {
      etat = "Sombre";
      DynamicTheme.of(context).setBrightness(Brightness.dark);
    } else {
      etat = "Clair";
      DynamicTheme.of(context).setBrightness(Brightness.light);
    }
  }
}
