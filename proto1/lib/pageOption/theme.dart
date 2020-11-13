import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  ThemeData tClair;
  ThemeData tSombre;

  //Thème courant
  EtatTheme etatTheme;
  ThemeData themeCourant;

  factory AppTheme() {
    //Constructeur : retourne l'instance du singleton
    return _instance;
  }

  AppTheme._internal() {
    //"Vrai" constructeur (initialise l'appli sur le thème de l'utilisateur
    etatTheme = EtatTheme.CLAIR;
    tClair = new ThemeData(
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.black,
        ),
        headline2: TextStyle(
          color: Colors.black,
        ),
      ),
      cardColor: Colors.grey[400],
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(
            color: Color.fromRGBO(19, 164, 245, 1)
        ),
        unselectedIconTheme: IconThemeData(
            color: Color.fromRGBO(196, 196, 196, 1),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(50, 50, 55, 1),
        ),
      ),
    );

    tSombre = new ThemeData(
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Color.fromRGBO(203, 214, 218, 1),
        ),
        headline2: TextStyle(
          color: Color.fromRGBO(50, 50, 55, 1),
        ),
      ),
      cardColor: Color.fromRGBO(33, 34, 38, 1),
      scaffoldBackgroundColor: Color.fromRGBO(50, 50, 55, 1),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(33, 34, 38, 1),
        selectedIconTheme: IconThemeData(
          color: Color.fromRGBO(63, 109, 231, 1)
        ),
        unselectedIconTheme: IconThemeData(
            color: Color.fromRGBO(54, 57, 64, 1)
          ),
      ),
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
      case EtatTheme.CLAIR:
        print('Clair');
        themeCourant = tSombre;
        etatTheme = EtatTheme.SOMBRE;
        DynamicTheme.of(context).setBrightness(Brightness.dark);
        return "Sombre";

      case EtatTheme.SOMBRE:
        print('Sombre');
        themeCourant = tClair;
        etatTheme = EtatTheme.CLAIR;
        DynamicTheme.of(context).setBrightness(Brightness.light);
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

  saveCurrentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', this.getNomEtat());
  }

  getCurrentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme');
  }
}

enum EtatTheme {
  CLAIR,
  SOMBRE,
}
