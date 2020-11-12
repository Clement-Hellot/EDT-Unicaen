import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// Le bouton déroulant pour choisir entre clair et sombre
class BoutonTheme extends StatefulWidget {
  BoutonTheme({Key key}) : super(key: key);

  @override
  _BoutonThemeState createState() => _BoutonThemeState();
}

class _BoutonThemeState extends State<StatefulWidget> {
  String dropdownValue = AppTheme().getNomEtat();

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
            dropdownValue = AppTheme().changerTheme(context);
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

  //Thème courant
  EtatTheme etatTheme;

  factory AppTheme() { //Constructeur : retourne l'instance du singleton
    return _instance;
  }

  AppTheme._internal() {
    //"Vrai" constructeur (initialise l'appli sur le thème de l'utilisateur
    etatTheme = EtatTheme.CLAIR;
  }

  String changerTheme(BuildContext context) {
    //Applique le thème actuellement choisi
    print("je suis dans le changement du theme");
    switch(etatTheme) {
      case EtatTheme.CLAIR:
        etatTheme = EtatTheme.SOMBRE;
        print("go sur le sombre");
        DynamicTheme.of(context).setBrightness(Brightness.dark);
        return "Sombre";

      case EtatTheme.SOMBRE:
        etatTheme = EtatTheme.CLAIR;
        print("go sur le clair");
        DynamicTheme.of(context).setBrightness(Brightness.light);
        return 'Clair';

    }
  }


  String getNomEtat() {
    switch(etatTheme) {
      case EtatTheme.CLAIR:
        return "Clair";

      case EtatTheme.SOMBRE:
        return 'Sombre';

    }
  }
}


enum EtatTheme{
  CLAIR,
  SOMBRE
}