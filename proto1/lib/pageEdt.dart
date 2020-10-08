import 'package:edt_mobile/Calendar.dart';
import 'package:flutter/material.dart';

import 'objets.dart';

class PageEDT extends StatefulWidget {
  @override
  _PageEDTState createState() => _PageEDTState();

  static const tailleHeure = 70;
  static const opaciteCours = 0.45;
}

class _PageEDTState extends State<PageEDT> {
  _PageEDTState() {
    Calendar().aff();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 50, bottom: 15),
        child: JourneeUI(
          journee: Journee(cours: [
            Cours(
              matiere: Matiere('CM Système'),
              prof: 'François BOURDON',
              debut: Horaire(8, 0),
              fin: Horaire(9, 0),
              salle: 'Amphi',
            ),
            Cours(
              matiere: Matiere('TD Proba/Stats'),
              prof: 'Stéphane SECOUARD',
              debut: Horaire(9, 0),
              fin: Horaire(11, 0),
              salle: '2124',
            ),
            Cours(
              matiere: Matiere('TDP Conception Objet'),
              prof: 'Paul DORBEC',
              debut: Horaire(11, 0),
              fin: Horaire(13, 0),
              salle: '2235',
            ),
            Pause(
              Horaire(13, 0),
              Horaire(14, 0),
            ),
            Cours(
              matiere: Matiere('TD PHP'),
              prof: 'Eric PORCQ',
              debut: Horaire(14, 0),
              fin: Horaire(16, 0),
              salle: '2236',
            ),
            Cours(
              matiere: Matiere('TP Anglais'),
              prof: 'Sylvian DELHOUMI',
              debut: Horaire(16, 0),
              fin: Horaire(17, 0),
              salle: 'Labo langue',
            ),
          ]),
        ),
      ),
    );
  }
}

class JourneeUI extends StatefulWidget {
  final Journee journee;

  const JourneeUI({Key key, this.journee}) : super(key: key);

  @override
  _JourneeUIState createState() => _JourneeUIState();
}

class _JourneeUIState extends State<JourneeUI> {
  List<Widget> _coursUi;

  _JourneeUIState() {
    _coursUi = List<Widget>();
  }

  @override
  void initState() {
    super.initState();

    for (HeureCours cours in widget.journee.cours) {
      if (cours is Cours) {
        _coursUi.add(CoursUI(
          cours: cours,
        ));
      } else if (cours is Pause) {
        _coursUi.add(PauseUI(cours));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text(
          'Mercredi 7 octobre', // TODO date
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      Column(
        children: _coursUi,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    ]);
  }
}

class CoursUI extends StatefulWidget {
  @override
  _CoursUIState createState() => _CoursUIState();

  CoursUI({
    Key key,
    this.cours,
  }) : super(key: key);

  final Cours cours;
}

class _CoursUIState extends State<CoursUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        top: 5,
        right: 15,
        bottom: 5,
      ),
      padding: EdgeInsets.only(left: 14, top: 10, right: 14, bottom: 10),
      height: widget.cours.duree * PageEDT.tailleHeure,
      decoration: BoxDecoration(
        color: widget.cours.matiere.couleur().withOpacity(PageEDT.opaciteCours),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.cours.matiere.nom,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3),
                  width: double.infinity,
                  child: Text(
                    widget.cours.salle,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xff606060),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4),
                  width: double.infinity,
                  child: Text(
                    widget.cours.prof,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  width: double.infinity,
                  child: Text(
                    widget.cours.horaireString,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xff505050),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PauseUI extends StatefulWidget {
  @override
  _PauseUIState createState() => _PauseUIState();

  final Pause pause;

  PauseUI(this.pause);

  final TextStyle styleHeure = TextStyle(
    color: Color(0xff606060),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

class _PauseUIState extends State<PauseUI> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.pause.debut.heureStr, style: widget.styleHeure),
        Container(
          margin: EdgeInsets.all(10),
          height: (0.5 + widget.pause.duree) * PageEDT.tailleHeure * 0.5,
          child: PauseLigne(
            width: 3,
            dashLength: 9.0,
            color: widget.styleHeure.color,
          ),
        ),
        Text(widget.pause.fin.heureStr, style: widget.styleHeure),
      ],
    );
  }
}

class PauseLigne extends StatelessWidget {
  final double width;
  final double dashLength;
  final Color color;

  const PauseLigne(
      {this.width = 1, this.dashLength = 10.0, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxHeight = constraints.constrainHeight();
        final dashHeight = dashLength;
        final dashWidth = width;
        final dashCount = (boxHeight / (1.75 * dashHeight)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
        );
      },
    );
  }
}

// --TODO--
// - Génération edt
