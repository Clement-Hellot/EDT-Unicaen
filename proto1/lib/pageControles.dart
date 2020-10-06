import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'objets.dart';

class PageControles extends StatefulWidget {
  @override
  _PageControlesState createState() => _PageControlesState();
}

class _PageControlesState extends State<PageControles> {
  List<Cc> _listeCc = [];
  String _strListeCc = 'Chargement...';

  _PageControlesState() {
    fetchCc(_listeCc, _dispListeCc);
  }

  _dispListeCc() {
    setState(() {
      _strListeCc = toString(_listeCc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 40),
            width: double.infinity,
            child: Text(
              'Contrôles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: 20,
            ),
            width: double.infinity,
            child: Text(
              _strListeCc,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Attend le html, puis le mets dans la liste et appelle la fonction
fetchCc(List<Cc> list, Function nextF) async {
  list.addAll(sortData(await getHtmlCC('2a')));

  nextF();
}

// Recupere le code HTML de la page des CC @param
//@param 1A | 2A
Future<http.Response> getHtmlCC(String annee) async {
  return http.get(
      'https://www.iutcaen.unicaen.fr/dokuc3/departement_info/planning_cc/' +
          annee);
}

List<Cc> sortData(var code) {
  List<Cc> cc = [];

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
      date = col[0].innerHtml;

      var content = col[1].innerHtml.split(" - ");
      matiere = content[0];
      enseignant = content[1];
      epreuve = content[2];

      lieu = col[2].innerHtml;

      duree = col[3].innerHtml;

      cc.add(new Cc(date, matiere, enseignant, epreuve, lieu, duree));
    }
  }
  return cc;
}

String toString(List<Cc> list) {
  String str = '';

  for (Cc cc in list) {
    str += cc.toString() + '\n\n';
  }

  return str;
}
