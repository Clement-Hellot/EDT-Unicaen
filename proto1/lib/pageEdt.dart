import 'package:flutter/material.dart';

class PageEDT extends StatefulWidget {
  @override
  _PageEDTState createState() => _PageEDTState();
}

class _PageEDTState extends State<PageEDT> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Lundi 5 octobre',
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
                  duree: 1,
                ),
                Cours(
                  matiere: Matieres.TD_PROBA,
                  prof: 'Stéphane SECOUARD',
                  duree: 2,
                ),
                Cours(
                  matiere: Matieres.TDP_CONCEPTION_OBJET,
                  prof: 'Paul DORBEC',
                  duree: 2,
                ),
                Cours(
                  matiere: Matieres.PAUSE,
                  prof: '',
                  duree: 1,
                ),
                Cours(
                  matiere: Matieres.TD_PHP,
                  prof: 'Eric Porcq',
                  duree: 2,
                ),
                Cours(
                  matiere: Matieres.TD_PHP,
                  prof: 'Eric Porcq',
                  duree: 5,
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

  Cours({Key key, this.matiere, this.prof, this.salle, this.duree})
      : super(key: key);

  final Matieres matiere;
  final String prof;
  final String salle;
  final double duree;
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
      padding: EdgeInsets.only(left: 14, top: 10),
      height: widget.duree * 65,
      decoration: BoxDecoration(
        color: widget.matiere.couleur.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.matiere.nom,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.prof,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xff606060),
            ),
          )
        ],
      ),
    );
  }
}

// enum temporaire, après ça sera géré automatiquement
enum Matieres {
  PAUSE, // Super temporaire
  TD_PHP,
  CM_SYSTEM,
  TD_PROBA,
  TDP_CONCEPTION_OBJET,
}

extension Matiere on Matieres {
  static const noms = {
    Matieres.PAUSE: '-----------',
    Matieres.TD_PHP: 'TD PHP',
    Matieres.CM_SYSTEM: 'CM Système',
    Matieres.TD_PROBA: 'TD Proba/Stats',
    Matieres.TDP_CONCEPTION_OBJET: 'TDP Conception Objet',
  };

  static final couleurs = {
    Matieres.PAUSE: Colors.grey[400],
    Matieres.TD_PHP: Colors.purple[400],
    Matieres.CM_SYSTEM: Colors.green[400],
    Matieres.TD_PROBA: Colors.blue[400],
    Matieres.TDP_CONCEPTION_OBJET: Colors.red[400],
  };

  String get nom => noms[this];
  Color get couleur => couleurs[this];
}

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
