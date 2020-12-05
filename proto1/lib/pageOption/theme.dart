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
            style: TextStyle(
                color: ThemeProvider.themeOf(context)
                    .data
                    .textTheme
                    .headline1
                    .color),
          ),
        );
      }).toList(),
    );
  }
}

class ThemeApp extends ChangeNotifier {
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
      backgroundColor: Color(0xFFFCFCFC),

      textTheme: TextTheme(
          headline1: TextStyle(
            //Titres
            color: Color(0xFF4A5255),
          ),
          headline2: TextStyle(
            //
            color: Color(0xFF707070),
          ),
          headline3: TextStyle(
            color: Color(0xFF3D3D3D),
          ),
          headline4: TextStyle(
            color: Color(0xFF404040),
          ),
          headline5: TextStyle(
            color: Color(0xFF757575),
          ),
          headline6: TextStyle(
            //StyleHeure (et je l'utilise pour les noms de matière aussi ça rends bien)
            color: Color(0xff606060),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          )),

      scaffoldBackgroundColor: Color(0xFFFCFCFC),

      cardColor: Color(0xFFC4C4C4),

      canvasColor: Color(0xFF2F3136),

      primaryColor: Color(0xFFDDDDDD),

      iconTheme: IconThemeData(
        color: Color(0xFFC4C4C4),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(
          color: Color(0xFF14A4F5),
        ),
        unselectedIconTheme: IconThemeData(
          color: Color(0xFFC4C4C4),
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
      backgroundColor: Color(0xFF2F3136),

      textTheme: TextTheme(
          headline1: TextStyle(
            color: Color(0xFFCBD6DA),
          ),
          headline2: TextStyle(
            color: Color(0xFF898989),
          ),
          headline3: TextStyle(
            color: Color(0xFF3D3D3D),
          ),
          headline4: TextStyle(
            color: Color(0xFF101010),
          ),
          headline5: TextStyle(
            color: Color(0xFF303030),
          ),
          headline6: TextStyle(
            //StyleHeure (et je l'utilise pour les noms de matière aussi ça rends bien)
            color: Color(0xff606060),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          )),

      scaffoldBackgroundColor: Color(0xFF2F3136),

      cardColor: Color(0xFF202225),

      canvasColor: Color(0xFF2F3136),

      primaryColor: Color(0xFF222222),

      iconTheme: IconThemeData(
        color: Color(0xFF747784),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF202225),
        selectedIconTheme: IconThemeData(
          color: Color(0xFF3E6DE7),
        ),
        unselectedIconTheme:
            IconThemeData(color: Color(0xFF545764)),
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
        ThemeProvider.controllerOf(context).nextTheme();
        etatTheme = EtatTheme.SOMBRE;
        return 'Sombre';

      case EtatTheme.SOMBRE:
        ThemeProvider.controllerOf(context).nextTheme();
        etatTheme = EtatTheme.CLAIR;
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

  TheTheme._internal() {}
}
