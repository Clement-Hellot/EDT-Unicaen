import 'dart:ui';

import 'package:edt_mobile/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'objets.dart';

class PageSalles extends StatefulWidget {
  @override
  _PageSallesState createState() => _PageSallesState();
}

class _PageSallesState extends State<PageSalles> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 50, bottom: 15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Lundi 27 Septembre',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Column(
              children: [
                PlageHoraire(debut: Horaire(8, 0), fin: Horaire(9, 0)),
                Salle(
                  salle: Salles.SALLE_1110,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.SALLE_2127,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.SALLE_2129,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.SALLE_2236,
                  possedeOrdis: true,
                ),
                PlageHoraire(debut: Horaire(9, 0), fin: Horaire(10, 0)),
                Salle(
                  salle: Salles.SALLE_1110,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.SALLE_2236,
                  possedeOrdis: true,
                ),
                PlageHoraire(debut: Horaire(10, 0), fin: Horaire(11, 0)),
                Salle(
                  salle: Salles.SALLE_2236,
                  possedeOrdis: true,
                ),
                Salle(
                  salle: Salles.SALLE_2127,
                  possedeOrdis: false,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ],
        ),
      ),
    );
  }
}

class PlageHoraire extends StatefulWidget {
  @override
  _PlageHoraireState createState() => _PlageHoraireState();

  final Horaire debut;
  final Horaire fin;

  PlageHoraire({Key key, this.debut, this.fin}) : super(key: key);

  String get horaireString {
    return debut.heureSoloStr + " - " + fin.heureSoloStr;
  }
}

class _PlageHoraireState extends State<PlageHoraire> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 125,
        top: 5,
        right: 125,
        bottom: 5,
      ),
      padding: EdgeInsets.only(left: 14, top: 10, right: 14, bottom: 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.horaireString,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
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

class Salle extends StatefulWidget {
  @override
  _SalleState createState() => _SalleState();

  Salle({Key key, this.possedeOrdis, this.salle}) : super(key: key);

  final Salles salle;
  final bool possedeOrdis;

  IconData get salleOrdi {
    if (this.possedeOrdis == true) {
      return Icons.computer;
    } else {
      return Icons.phonelink_off;
    }
  }
}

class _SalleState extends State<Salle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        top: 5,
        right: 15,
        bottom: 5,
      ),
      padding: EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
      height: 50,
      decoration: BoxDecoration(
        color: widget.salle.couleur.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.salle.nom,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            //fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: Icon(
                  widget.salleOrdi,
                  color: Colors.grey[800],
                  size: 30,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum Salles {
  SALLE_2129,
  SALLE_2127,
  SALLE_1110,
  SALLE_2236,
}

extension DetailsSalles on Salles {
  static const noms = {
    Salles.SALLE_1110: 'Salle 1110',
    Salles.SALLE_2127: 'Salle 2127',
    Salles.SALLE_2129: 'Salle 2129',
    Salles.SALLE_2236: 'Salle 2236'
  };

  static final couleurs = {
    Salles.SALLE_1110: Colors.purple[300],
    Salles.SALLE_2127: Colors.yellow[300],
    Salles.SALLE_2129: Colors.blue[300],
    Salles.SALLE_2236: Colors.red[300],
  };

  String get nom => noms[this];
  Color get couleur => couleurs[this];
}
