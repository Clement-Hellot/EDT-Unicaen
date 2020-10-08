import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'objets.dart';
import 'controleObjets.dart';

// TODO
// - affichage
// - stocker la liste au démarrage de l'appli
//  -> déplacer le traitement ?
//  -> ou variable static ?

class PageControles extends StatefulWidget {
  @override
  _PageControlesState createState() => _PageControlesState();
}

class _PageControlesState extends State<PageControles> {
  List<SemaineCc> _listeSemaineCc = [];

  Container _widgetSemaineCc;
  Widget _loadingText = Text('Chargement...');
  Widget _semaineCcWrapper;

  _PageControlesState() {
    _semaineCcWrapper = _loadingText;// en attendant que les cc soient chargés
    fetchCc(_listeSemaineCc, _dispListeSemaineCc);
  }

  _dispListeSemaineCc() {
    setState(() {
      List<Widget> semaines = [];
      for (SemaineCc semaineCc in _listeSemaineCc) {
        semaines.add(SemaineCcUI(semaineCc));
      }

      _widgetSemaineCc = Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[600],
          ),
          child : Column(//la semaine
            children: [
              Text("cette semaine"),//le nom de la semaine (cette semaine, semaine prochaine etc
              Column(//les cc de la semaine
                children: semaines,
              ),
            ],
          ),
      );


      _semaineCcWrapper = _widgetSemaineCc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 30),
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
              margin: EdgeInsets.all(20),
              width: double.infinity,
              child: _semaineCcWrapper,
            ),
          ],
        ),
      ),
    );
  }
}

class ControleUI extends StatefulWidget {
  final Controle cc;

  ControleUI(this.cc);

  @override
  _ControleUIState createState() => _ControleUIState();

}

//un controle
class _ControleUIState extends State<ControleUI> {
  TextStyle _style = TextStyle(
    color: Colors.white,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.grey[600],
      ),
      child: Column(
        children: [
          Text(cleanUp(widget.cc.jourSemaine.name), style: _style),
          Text(cleanUp(widget.cc.matiere), style: _style),
          Text(cleanUp(widget.cc.enseignant), style: _style),
          Text(cleanUp(widget.cc.epreuve), style: _style),
          Text(cleanUp(widget.cc.lieu), style: _style),
          Text(cleanUp(widget.cc.debut.format()), style: _style),
          Text(cleanUp(widget.cc.debut.getHeureFinEvenement(widget.cc.duree).format()), style: _style),
        ],
      ),
    );
  }
}

class SemaineCcUI extends StatefulWidget {

  final SemaineCc semaineCc;

  SemaineCcUI(this.semaineCc);

  @override
  _SemaineCcUIState createState() => _SemaineCcUIState();

}

//une semaine avec ses controles
class _SemaineCcUIState  extends State<SemaineCcUI> {

  Column _widgetControle;
  Widget _loadingText = Text('Chargement...');
  Widget _controleWrapper;

  _SemaineCcUIState() {
    _controleWrapper = _loadingText;
      List<Widget> controles = [];
      for (Controle cc in widget.semaineCc.controles) {
        controles.add(ControleUI(cc));
      }

      _widgetControle =  Column(//la semaine
          children: [
            Text("cette semaine"),//le nom de la semaine (cette semaine, semaine prochaine etc
            Column(//les cc de la semaine
              children: controles,
            ),
          ],
        );


      _controleWrapper = _widgetControle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.amber,
      ),
      child : Column(//la semaine
        children: [
          Text("cette semaine"),//le nom de la semaine (cette semaine, semaine prochaine etc
          Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            child: _controleWrapper,
          ),
        ],
      ),
    );
  }

}













































/// Attend le html, puis le mets dans la liste et appelle la fonction
fetchCc(List<SemaineCc> list, Function nextF) async {
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

List<SemaineCc> sortData(var code) {
  List<Controle> cc = [];
  List<SemaineCc> semaineCc = [];

  var doc = parse(code.body);
  var table = doc.getElementsByTagName('table');
  table = table[0].children;
  var tbody = table[1].children;

  for (var item in tbody) {
    String semaine;
    JourSemaine jourSemaine;
    String matiere;
    String enseignant;
    String epreuve;
    String lieu;
    String duree;

    var col = item.children;
    if (col.length > 1 &&
        col[1].innerHtml.length > 3 &&
        col[1].innerHtml.contains("-")) {
      semaine = col[0].innerHtml;

      var content = col[1].innerHtml.split(" - ");
      matiere = content[0];
      enseignant = content[1];
      epreuve = content[2];

      lieu = col[2].innerHtml;

      duree = col[3].innerHtml;
      jourSemaine = JourSemaine.LUNDI;
      cc.add(new Controle(jourSemaine, matiere, enseignant, epreuve, lieu, Heure(heures:1,minutes: 30), Heure(heures: 8,minutes: 30)));
    }
  }
  semaineCc.add( SemaineCc(cc,"semaine de test"));
  return semaineCc;
}

String toString(List<Controle> list) {
  String str = '';

  for (Controle cc in list) {
    str += cc.toString() + '\n\n';
  }

  return str;
}

String cleanUp(String str) {
  return str.replaceAll('<br>', '').trim();
}
