import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class Compte {
  static Compte _compte = Compte()._internal();

  SharedPreferences prefs;

  String username;
  String password;

  String getUsername() => username;
  String getPassword() => password;

  void setUsername(String user) => this.username = user;
  void setPassword(String pass) => this.password = pass;

  _internal() async {
    prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    password = prefs.getString('password');
  }

  void enregistrerCompte() async {
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  factory Compte() {
    return _compte;
  }
}

class CompteRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CompteRowState();
}

class _CompteRowState extends State<CompteRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Text(
            "Compte : ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color:
                  ThemeProvider.themeOf(context).data.textTheme.headline1.color,
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 25, 35, 35),
            child: Text(
              "Pas encore implémenté...",
              style: ThemeProvider.themeOf(context).data.textTheme.headline1,
            ))
      ],
    );
  }
}
