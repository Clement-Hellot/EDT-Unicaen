import 'dart:math';
import 'package:edt_mobile/pageOption/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'objets.dart';
import 'controleObjets.dart';
import 'PageEDT.dart';
import "CalendrierJours.dart";

// TODO
// - stocker la liste au démarrage de l'appli
//  -> déplacer le traitement ?
//  -> ou variable static ?
//  -> Proxy ?

class PageControles extends StatefulWidget {
  static const opaciteCours = 0.45;
  static const taileCc = 70.0;

  @override
  _PageControlesState createState() => _PageControlesState();
}

class _PageControlesState extends State<PageControles>
    with AutomaticKeepAliveClientMixin<PageControles> {
  List<SemaineCc> _listeSemaineCc = List<SemaineCc>();

  Container _widgetSemaineCc;
  Widget _loadingText = Text('Chargement...');
  Widget _semaineCcWrapper;

  _PageControlesState() {
    _semaineCcWrapper = _loadingText; // en attendant que les cc soient chargés

    fetchCc(_listeSemaineCc, _dispListeSemaineCc);
  }
  @override
  void initState() {
    super.initState();
  }

  _dispListeSemaineCc() {
    setState(() {
      List<Widget> semaines = List<Widget>();
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
        child: Column(
          //les cc de la semaine
          children: semaines,
        ),
      );

      _semaineCcWrapper = _widgetSemaineCc;
    });

  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: _handleRefresh, child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
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
                  color: AppTheme().textColor,
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
    ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _listeSemaineCc = List<SemaineCc>();
      fetchCc(_listeSemaineCc, _dispListeSemaineCc);
    });
  }
  @override
  bool get wantKeepAlive => true;
}

class SemaineCcUI extends StatefulWidget {
  final SemaineCc semaineCc;

  SemaineCcUI({this.semaineCc});

  @override
  _SemaineCcUIState createState() => _SemaineCcUIState();
}

//une semaine avec ses controles
class _SemaineCcUIState extends State<SemaineCcUI> {
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

    _widgetControle = Column(
      //la semaine
      children: [
        Column(
          //les cc de la semaine
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
      ),
      child: Column(
        //la semaine
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: InkWell(
              child: Ink(
                padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey[300],
                ),
                child: Row(
                  children: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 100),
                      firstChild: Icon(Icons.keyboard_arrow_right),
                      secondChild: Transform.rotate(
                        angle: 90 * pi / 180,
                        child: Icon(Icons.keyboard_arrow_right),
                      ),
                      crossFadeState: _droppedDown == true
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                    Text(
                      widget.semaineCc.nom(),
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
                  _droppedDown == true
                      ? _droppedDown = false
                      : _droppedDown = true;
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild: Container(),
              secondChild: _controleWrapper,
              crossFadeState: _droppedDown == true
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
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
  // TextStyle _style = TextStyle(
  //   color: Colors.white,
  //   fontSize: 15,
  // );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, right: 10, left: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: double.infinity,
      height: PageControles.taileCc,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color:
            widget.cc.matiere.couleur().withOpacity(PageControles.opaciteCours),
        //color:Colors.grey[400]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cc.matiere.shortVersion(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.cc.nomJour(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.cc.debut.toString() + " - " + widget.cc.fin.toString(),
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

List<SemaineCc> ajouterControleEDT(List<SemaineCc> listeSemainesCC) {
  CalendrierJours calendrier = PageEDT.calendrier;
  bool isEntered = false;
  if (PageEDT.calendrier == null) {
    print("error calendrier vide");
    return listeSemainesCC;
  }
  RegExp regExp = new RegExp(
    r"cc|ctp",
    caseSensitive: false,
    multiLine: false,
  );
  print("liste de :" + calendrier.jours.length.toString());
  for (Cours cours in calendrier.cours) {
    isEntered = false;
    if (regExp.hasMatch(cours.matiere.nom)) {
      for (SemaineCc semaineCc in listeSemainesCC) {
        //print("test : "+semaineCc.semaineDate.start.isBefore(cours.debut.date).toString()+"/"+semaineCc.semaineDate.end.isAfter(cours.debut.date).toString());
        if (semaineCc.semaineDate.start.isBefore(cours.debut.date) &&
            semaineCc.semaineDate.end.isAfter(cours.debut.date) &&
            isEntered == false) {
          semaineCc.controles.add(Controle(
              cours.matiere, cours.prof, cours.salle, cours.debut, cours.fin));
          isEntered = true;
        }
      }
      if (!isEntered) {
        List<Controle> listeTemp = List<Controle>();
        listeTemp.add(Controle(
            cours.matiere, cours.prof, cours.salle, cours.debut, cours.fin));
        /*DateTime debutSemaine = cours.debut.date;
        DateTime finSemaine = cours.debut.date;
        print("avant"+debutSemaine.toString());
        debutSemaine.subtract(Duration(days: 3));
        print("apres"+debutSemaine.toString());
        finSemaine.add(Duration(days: 7 - cours.debut.date.weekday));*/
        DateTime dateCours = cours.debut.date;
        listeSemainesCC.add(SemaineCc(
            listeTemp,
            DateTimeRange(
                start: DateTime(dateCours.year, dateCours.month,
                    dateCours.day - dateCours.weekday + 1),
                end: DateTime(dateCours.year, dateCours.month,
                    dateCours.day + (7 - dateCours.weekday)))));
      }
    }
  }
  return listeSemainesCC;
}

/// Attend le html, puis le mets dans la liste et appelle la fonction
fetchCc(List<SemaineCc> list, Function nextF) async {
  list.addAll(sortData(await getHtmlCC('2a')));
  ajouterControleEDT(list);
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
  List<Controle> cc = List<Controle>();
  List<SemaineCc> semaineCc = List<SemaineCc>();

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
    if (col.length > 1 && col[1].innerHtml.length > 3 && col[1].innerHtml.contains("-")) {

     
      semaine = col[0].innerHtml;
      DateTime debutSemaine = DateTime(2000+int.parse(semaine.substring(9,11)),int.parse(semaine.substring(6,8)),int.parse(semaine.substring(3,5)));
      DateTime finSemaine = DateTime(2000+int.parse(semaine.substring(21,23)),int.parse(semaine.substring(18,20)),int.parse(semaine.substring(15,17)));
      var tabInfo = col[1].innerHtml.split("<br>");
      var tabLieu = col[2].innerHtml.split("<br>");
      var tabDuree = col[3].innerHtml.split("<br>");
      for(int i=0 ; i<tabInfo.length ; i++){

        var info = tabInfo[i].split("-");
        lieu = tabLieu[i].toString().trimLeft().trimRight();
        duree = tabDuree[i].toString().trimLeft().trimRight();

        matiere = info[1];
        enseignant = info[2];
        epreuve = info[3];
        //print(semaine+" - "+matiere+" - "+enseignant+" - "+epreuve+" - "+lieu+" - "+duree+" - ");

        if(duree.contains("-")) {
          DateTime dureeDateTime = null;
        } else {
          //traitement de la duree
          //TODO traiter la duree
          DateTime dureeDateTime = DateTime(2020, 10, 12);
        }

        if(lieu.contains("-")) {
          lieu = "NC";
        }
        //en an 2000 pour dire qu'il n'y a pas d'année
        //TODO mieux faire que ça
        cc.add(new Controle(Matiere(matiere), enseignant, lieu, Horaire(0,0,date: DateTime(2000)),  Horaire(0,0)));
        //print(cc);


      }
      //TODO pareil
      if(finSemaine.isAfter(DateTime.now()))
        semaineCc.add(SemaineCc(cc, DateTimeRange(start: debutSemaine,end: finSemaine)));
      cc = List<Controle>();
    }
  }
/*
  String semaine = "cette semaine";
  JourSemaine jourSemaine = JourSemaine.LUNDI;
  String matiere = "CC de php";
  String enseignant = "PORCQ";
  String epreuve = "CC de PHP";
  String lieu = "salle examen";
  Horaire fin = Horaire(1, 0);
  Horaire debut = Horaire(10, 0);

  cc.add(Controle(Matiere(matiere), enseignant, lieu, debut, fin));
  cc.add(Controle(Matiere(matiere), enseignant, lieu, debut, fin));

  semaineCc.add(SemaineCc(
      cc,
      DateTimeRange(
          start: DateTime.utc(2020, 10, 11), end: DateTime.utc(2020, 10, 17))));
  cc.add(Controle(Matiere(matiere), enseignant, lieu, debut, fin));
  semaineCc.add(SemaineCc(
      cc,
      DateTimeRange(
          start: DateTime.utc(2020, 10, 18), end: DateTime.utc(2020, 10, 24))));
*/
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
