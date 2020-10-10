import 'dart:math';

import 'package:flutter/cupertino.dart';
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
  static const opaciteCours = 0.45;
  static const taileCc = 70.0;
  _PageControlesState createState() => _PageControlesState();
}

class _PageControlesState extends State<PageControles> with AutomaticKeepAliveClientMixin<PageControles>{
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
        semaines.add(SemaineCcUI(semaineCc: semaineCc));
      }

      _widgetSemaineCc = Container(
          margin: EdgeInsets.symmetric(vertical: 0),
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          width: double.infinity,
          /*
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey[300],
          ),*/
          child : Column(//les cc de la semaine
                children: semaines,
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
              margin: EdgeInsets.all(5),
              width: double.infinity,
              child: _semaineCcWrapper,
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SemaineCcUI extends StatefulWidget {

  final SemaineCc semaineCc;

  SemaineCcUI({this.semaineCc});

  @override
  _SemaineCcUIState createState() => _SemaineCcUIState();

}

//une semaine avec ses controles
class _SemaineCcUIState  extends State<SemaineCcUI> {
  bool _droppedDown = true;
  Column _widgetControle;
  Widget _loadingText = Text('Chargement...');
  Widget _controleWrapper;

  _SemaineCcUIState();

  @override
  void initState() {
    super.initState();

    _controleWrapper = _loadingText;
    List<Widget> controles = List<Widget>();
    for (Controle cc in widget.semaineCc.controles) {
      controles.add(ControleUI(cc));
    }

    _widgetControle =  Column(//la semaine
      children: [
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
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        //color: Colors.grey[300],
      ),
      child : Column(//la semaine
        children: [
         InkWell(
           child:  Container(
             margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
             padding: EdgeInsets.all(5),
             width: double.infinity,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(5)),
               color: Colors.grey[300],
             ),
             child: Row(
               children : [
                 AnimatedCrossFade(
                   duration: const Duration(milliseconds: 100),
                   firstChild : Icon(Icons.keyboard_arrow_right),
                   secondChild: Transform.rotate(
                                  angle: 90 * pi/180,
                                  child:  Icon(Icons.keyboard_arrow_right),
                                ),
                   crossFadeState: _droppedDown == true ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                 ),

                 Text(
                   widget.semaineCc.semaine,
                   textAlign: TextAlign.left,
                   style: TextStyle(
                     fontSize: 19,
                     color: Colors.black,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
               ],
             ),
           ),
           onTap: () {
             setState(() {

               _droppedDown == true ? _droppedDown = false: _droppedDown = true;
             });
           },
         ),
          Container(
            width: double.infinity,
            child : AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild : Container(),
              secondChild: _controleWrapper,
              crossFadeState: _droppedDown == true ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
          )

        ],
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
      margin: EdgeInsets.only(bottom: 5, right: 10, left: 10),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: PageControles.taileCc,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        //color: widget.cc.matiere.couleur().withOpacity(PageControles.opaciteCours),
        color: Colors.grey[400]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.cc.epreuve,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.cc.lieu,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.cc.jourSemaine.name,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.cc.debut.format(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

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
  /*
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
  */

  String semaine = "cette semaine";
  JourSemaine jourSemaine = JourSemaine.LUNDI;
  String matiere = "M2104";
  String enseignant = "PORCQ";
  String epreuve = "CC de PHP";
  String lieu = "salle examen";
  Heure duree = Heure(heures: 1,minutes: 0);
  Heure debut = Heure(heures: 10,minutes: 0);

  cc.add(Controle(jourSemaine, Matiere(matiere), enseignant, epreuve, lieu, duree, debut));
  cc.add(Controle(jourSemaine, Matiere(matiere), enseignant, epreuve, lieu, duree, debut));

  semaineCc.add( SemaineCc(cc,semaine));
  cc.add(Controle(jourSemaine, Matiere(matiere), enseignant, epreuve, lieu, duree, debut));
  semaineCc.add( SemaineCc(cc,"semaine prochaine"));
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
