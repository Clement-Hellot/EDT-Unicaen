import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'objets.dart';

class PageControles extends StatefulWidget {
  @override
  _PageControlesState createState() => _PageControlesState();
}

class _PageControlesState extends State<PageControles> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        child: Text(
          'Contrôles',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

// Recupere le code HTML de la page des CC @param
//@param 1A | 2A
Future<http.Response> getHtmlCC(String annee) async {
  return http.get(
      'https://www.iutcaen.unicaen.fr/dokuc3/departement_info/planning_cc/' +
          annee);
}

List sortData(var code) {
  List cc = [];

  var doc = parse(code.body);
  var table = doc.getElementsByTagName('table');
  table = table[0].children;
  var tbody = table[1].children;

  for (var item in tbody) {
    String date;
    String matiere;
    String enseignant;
    String epreuve;
    String lieu;
    String duree;

    var col = item.children;
    if (col.length > 1 &&
        col[1].innerHtml.length > 3 &&
        col[1].innerHtml.contains("-")) {
      for (var i = 0; i < col.length; i++) {
        String value = col[i].innerHtml;
        switch (i) {
          case 0:
            date = value;
            break;
          case 1:
            var content = value.split(" - ");
            matiere = content[0];
            enseignant = content[1];
            epreuve = content[2];
            break;
          case 2:
            lieu = value;
            break;
          case 3:
            duree = value;
            break;
        }
      }
      cc.add(new Cc(date, matiere, enseignant, epreuve, lieu, duree));
    }
  }
  return cc;
}

void display(List list) {
  for (var item in list) {
    item.display();
  }
}
