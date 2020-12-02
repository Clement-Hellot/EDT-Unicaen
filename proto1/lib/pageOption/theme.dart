import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:theme_provider/theme_provider.dart';

/// Le bouton déroulant pour choisir entre clair et sombre
class BoutonTheme extends StatefulWidget {
  BoutonTheme({Key key}) : super(key: key);

  @override
  _BoutonThemeState createState() => _BoutonThemeState();
}

class _BoutonThemeState extends State<StatefulWidget> {
  String dropdownValue = ThemeApp().getNomEtat();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      dropdownColor: ThemeProvider.themeOf(context).data.cardColor,
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          if (newValue != dropdownValue) {
            dropdownValue = ThemeApp().changerTheme(context);
          }
        });
      },
      items: <String>['Clair', 'Sombre']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
              value,
            style: TextStyle(color: ThemeProvider.themeOf(context).data.textTheme.headline1.color),
          ),
        );
      }).toList(),
    );
  }
}

class ThemeApp extends ChangeNotifier{

  //Singleton
  static ThemeApp _instance = ThemeApp._internal(); //Instancié au lancement

  ThemeData tClair;
  ThemeData tSombre;

  //Thème courant
  EtatTheme etatTheme;
  ThemeData themeCourant;

  factory ThemeApp() {
    //Constructeur : retourne l'instance du singleton
    return _instance;
  }

  ThemeApp._internal() {
    //"Vrai" constructeur (initialise l'appli sur le thème de l'utilisateur)

    etatTheme = EtatTheme.CLAIR;

    tClair = new ThemeData(
      textTheme: TextTheme( //C'est bon
        headline1: TextStyle(
          color: Color(0x4A5255),
        ),
        headline2: TextStyle(
          color: Color(0x707070),
        ),
        headline3: TextStyle(
          color: Color(0x3D3D3D),
        ),
        headline4: TextStyle(
          color: Color(0x757575),
        ),
      ),
      scaffoldBackgroundColor: Color(0xFCFCFC), //Check
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFF),
        selectedIconTheme: IconThemeData(
            color: Color(0x14A4F5),
        ),
        unselectedIconTheme: IconThemeData(
            color: Color(0xC4C4C4),
        ),
      ),
      cardColor: Color(0xC4C4C4),

      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(50, 50, 55, 1),
        ),
      ),
    );

    tSombre = new ThemeData(
      textTheme: TextTheme( //C'est bon
        headline1: TextStyle(
          color: Color(0xCBD6DA),
        ),
        headline2: TextStyle(
          color: Color(0x898989),
        ),
        headline3: TextStyle(
          color: Color(0x3D3D3D),
        ),
        headline4: TextStyle(
          color: Color(0x757575),
        ),
      ),
      scaffoldBackgroundColor: Color(0x2F3136), //Check

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0x202225),
        selectedIconTheme: IconThemeData(
          color: Color(0x3E6DE7),
          //color: Color.fromRGBO(63, 109, 231, 1)
        ),
        unselectedIconTheme: IconThemeData(
            color: Color.fromRGBO(54, 57, 64, 1)
          ),
      ),
      cardColor: Color(0x36393F),

      dialogTheme: DialogTheme(
        backgroundColor: Color.fromRGBO(50, 50, 55, 1),
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(203, 214, 218, 1),
        ),
      ),
    );
  }

  String changerTheme(BuildContext context) {
    //Applique le thème actuellement choisi
    switch (etatTheme) {
      case EtatTheme.SOMBRE:
        ThemeProvider.controllerOf(context).nextTheme();
        print(ThemeProvider.controllerOf(context).theme.id);
        etatTheme = EtatTheme.CLAIR;
        return 'Sombre';

      case EtatTheme.CLAIR:
        ThemeProvider.controllerOf(context).nextTheme();
        print(ThemeProvider.controllerOf(context).theme.id);
        print(ThemeProvider.controllerOf(context).allThemes.toString());
        etatTheme = EtatTheme.SOMBRE;
        return 'Clair';
    }
  }

  String getNomEtat() {
    switch (etatTheme) {
      case EtatTheme.CLAIR:
        return "Clair";

      case EtatTheme.SOMBRE:
        return 'Sombre';
    }
  }
}

enum EtatTheme {
  CLAIR,
  SOMBRE,
}


class TheTheme {

  static TheTheme _instance = TheTheme._internal(); //Instancié au lancement

  factory TheTheme() {
    return _instance;
  }

  TheTheme._internal() {


  }
}
