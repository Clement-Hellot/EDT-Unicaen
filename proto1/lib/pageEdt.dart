import 'package:flutter/material.dart';

import 'objets.dart';

class PageEDT extends StatefulWidget {
  @override
  _PageEDTState createState() => _PageEDTState();

  static const tailleHeure = 70;
}

class _PageEDTState extends State<PageEDT> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 50, bottom: 15),
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Mercredi 7 octobre',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Column(
              children: [
                Cours(
                  matiere: Matieres.CM_SYSTEM,
                  prof: 'François BOURDON',
                  debut: Horaire(8, 0),
                  fin: Horaire(9, 0),
                  salle: 'Amphi',
                ),
                Cours(
                  matiere: Matieres.TD_PROBA,
                  prof: 'Stéphane SECOUARD',
                  debut: Horaire(9, 0),
                  fin: Horaire(11, 0),
                  salle: '2124',
                ),
                Cours(
                  matiere: Matieres.TDP_CONCEPTION_OBJET,
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
                  matiere: Matieres.TD_PHP,
                  prof: 'Eric PORCQ',
                  debut: Horaire(14, 0),
                  fin: Horaire(16, 0),
                  salle: '2236',
                ),
                Cours(
                  matiere: Matieres.TD_PHP,
                  prof: 'Eric PORCQ',
                  debut: Horaire(16, 0),
                  fin: Horaire(19, 0),
                  salle: '2236',
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ])),
    );
  }
}

class Cours extends StatefulWidget {
  @override
  _CoursState createState() => _CoursState();

  Cours({Key key, this.matiere, this.prof, this.salle, this.debut, this.fin})
      : super(key: key);

  final Matieres matiere;
  final String prof;
  final String salle;
  final Horaire debut;
  final Horaire fin;

  double get duree => fin.totalHeures - debut.totalHeures;

  String get horaireString {
    return debut.heureStr + ' - ' + fin.heureStr;
  }
}

class _CoursState extends State<Cours> {
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
      height: widget.duree * PageEDT.tailleHeure,
      decoration: BoxDecoration(
        color: widget.matiere.couleur.withOpacity(0.5),
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
                    widget.matiere.nom,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3),
                  width: double.infinity,
                  child: Text(
                    widget.salle,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xff707070),
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
                    widget.prof,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  width: double.infinity,
                  child: Text(
                    widget.horaireString,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xff404040),
                      fontSize: 17,
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

class Pause extends StatefulWidget {
  @override
  _PauseState createState() => _PauseState();

  final Horaire debut;
  final Horaire fin;

  Pause(this.debut, this.fin);

  double get duree => fin.totalHeures - debut.totalHeures;

  final TextStyle styleHeure = TextStyle(
    color: Color(0xff606060),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

class _PauseState extends State<Pause> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.debut.heureStr, style: widget.styleHeure),
        Container(
          margin: EdgeInsets.all(10),
          height: (0.5 + widget.duree) * PageEDT.tailleHeure * 0.5,
          child: PauseLigne(
            width: 3,
            dashLength: 9.0,
            color: widget.styleHeure.color,
          ),
        ),
        Text(widget.fin.heureStr, style: widget.styleHeure),
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

// Couleur matière
//
// Il faudrait une couleur aléatoire assignée à chaque matière
//
// Problème :
// Il faudrait à chaque fois la même couleur pour la même matière
// - Pas réinitialisée à chaque lancement
//   -> on pourrait la stocker
//     -- place pour pas grand chose
//     -- personne aurait les mêmes, sauf si stockage sur serveur (lol non)
// - Ca serait bien que tout le monde ait la même chose
//
// Idée : Générer directement la couleur à partir du nom de la matière
// Utiliser une conversion du nom en nombre, soit directement comme couleur,
// soit comme seed pour générer une couleur
