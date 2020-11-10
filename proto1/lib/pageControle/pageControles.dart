import 'dart:math';
import 'package:edt_mobile/pageOption/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import '../objets.dart';
import 'controleObjets.dart';
import '../PageEDT.dart';
import '../CalendrierJours.dart';

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
  Widget _semaineCcWrapper;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _PageControlesState() {
    _semaineCcWrapper = CircularProgressIndicator();

    fetchCc(_listeSemaineCc, _dispListeSemaineCc);
  }
  @override
  void initState() {
    super.initState();
  }

  _dispListeSemaineCc(List<SemaineCc> listeSemainesCC) {
    _listeSemaineCc = listeSemainesCC;
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
    print("la liste est mise a jour");
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
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

  Future<void> _handleRefresh() {
    return fetchCc(List<SemaineCc>(), _dispListeSemaineCc)
        .then((value) => _listeSemaineCc = value);
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
  Widget _controleWrapper;

  _SemaineCcUIState();

  @override
  void initState() {
    super.initState();

    _controleWrapper = CircularProgressIndicator();
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {//display the popup window with more information about the cc
          showDialog(
            context: context,
            builder: (BuildContext context) => PopupControleUI(widget.cc),
          );
        },
        child: Container(
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
        ),
    );
  }
}



class PopupControleUI extends StatefulWidget {
  final Controle cc;
  PopupControleUI(this.cc);

  @override
  _PopupControleUIState createState() =>  _PopupControleUIState();
}

//un controle
class _PopupControleUIState extends State<PopupControleUI> {

  void initState() {
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
        padding: EdgeInsets.all(00),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: new BoxDecoration(
                color: widget.cc.matiere.couleur().withOpacity(PageControles.opaciteCours),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                )
              ),
              child:Text(
                widget.cc.matiere.toString(),
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: 10,
                right:20,
                left: 20,
                bottom: 2,
              ),
              width: double.infinity,
              decoration: new BoxDecoration(

              ),
              child: Text(
                widget.cc.dateComplete(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 2,horizontal: 20),
              width: double.infinity,
              decoration: new BoxDecoration(

              ),
              child: Text(
                widget.cc.lieu.toString(),
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 2,horizontal: 20),
              width: double.infinity,
              decoration: new BoxDecoration(

              ),
              child: Text(
                widget.cc.debut.toString() + " - " + widget.cc.fin.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: 80,
                right:20,
                left:20,
                bottom:20,
              ),
              width: double.infinity,
              decoration: new BoxDecoration(

              ),
              child: Text(
                widget.cc.enseignant.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),

            /*
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: 60,
                  height: 60,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 50.0,
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Icon(Icons.clear,color:  Colors.black),
                ),
              ),
            ),*/
          ],
        ),
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
  //print(listeSemainesCC);
  return listeSemainesCC;
}

/// Attend le html, puis le mets dans la liste et appelle la fonction
Future<List<SemaineCc>> fetchCc(List<SemaineCc> list, Function nextF) async {
  //list = sortData(await getHtmlCC('2a'));
  list = ajouterControleEDT(list);
  nextF(list);
  return list;
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
  RegExp regExp = new RegExp(
    r"<|>",
    caseSensitive: false,
    multiLine: false,
  );

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
      print(semaine);
      semaine = removeColorDecoration(semaine);

      DateTime debutSemaine = DateTime(
          2000 + int.parse(semaine.substring(9, 11)),
          int.parse(semaine.substring(6, 8)),
          int.parse(semaine.substring(3, 5)));
      DateTime finSemaine = DateTime(
          2000 + int.parse(semaine.substring(21, 23)),
          int.parse(semaine.substring(18, 20)),
          int.parse(semaine.substring(15, 17)));
      var tabInfo = col[1].innerHtml.split("<br>");
      var tabLieu = col[2].innerHtml.split("<br>");
      var tabDuree = col[3].innerHtml.split("<br>");
      for (int i = 0; i < tabInfo.length; i++) {
        var info = tabInfo[i].split("-");
        lieu =
            removeColorDecoration(tabLieu[i].toString().trimLeft().trimRight());
        duree = removeColorDecoration(
            tabDuree[i].toString().trimLeft().trimRight());

        matiere = removeColorDecoration(info[1]);
        enseignant = removeColorDecoration(info[2]);
        epreuve = removeColorDecoration(info[3]);
        //print(semaine+" - "+matiere+" - "+enseignant+" - "+epreuve+" - "+lieu+" - "+duree+" - ");

        if (duree.contains("-")) {
          DateTime dureeDateTime = null;
        } else {
          //traitement de la duree
          //TODO traiter la duree
          DateTime dureeDateTime = DateTime(2020, 10, 12);
        }

        if (lieu.contains("-")) {
          lieu = "NC";
        }
        //en an 2000 pour dire qu'il n'y a pas d'année
        //TODO mieux faire que ça
        cc.add(new Controle(Matiere(matiere), enseignant, lieu,
            Horaire(0, 0, date: DateTime(2000)), Horaire(0, 0)));
        //print(cc);

      }
      //TODO pareil
      if (finSemaine.isAfter(DateTime.now()))
        semaineCc.add(
            SemaineCc(cc, DateTimeRange(start: debutSemaine, end: finSemaine)));
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
  print(semaineCc);
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

String removeColorDecoration(String chaine) {
  RegExp regExp1 = new RegExp(
    r"^<",
    caseSensitive: false,
    multiLine: false,
  );
  RegExp regExp2 = new RegExp(
    r">$",
    caseSensitive: false,
    multiLine: false,
  );
  if (regExp1.hasMatch(chaine)) {
    //print("ce n'est pas bon");
    print("avant :" + chaine);
    chaine = chaine.substring(chaine.indexOf(">") + 1, chaine.length);
    print("apres :" + chaine);
    //print(semaine);
  }
  if (regExp2.hasMatch(chaine)) {
    //print("ce n'est pas bon");
    print("avant :" + chaine);
    chaine = chaine.substring(0, chaine.indexOf("<"));
    print("apres :" + chaine);
    //print(semaine);
  }
  return chaine;
}
