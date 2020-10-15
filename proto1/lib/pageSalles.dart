import 'dart:ui';

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
                  salle: Salles.S1110,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.S2127,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.S2129,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.S2236,
                  possedeOrdis: true,
                ),
                PlageHoraire(debut: Horaire(9, 0), fin: Horaire(10, 0)),
                Salle(
                  salle: Salles.S1110,
                  possedeOrdis: false,
                ),
                Salle(
                  salle: Salles.S2236,
                  possedeOrdis: true,
                ),
                PlageHoraire(debut: Horaire(10, 0), fin: Horaire(11, 0)),
                Salle(
                  salle: Salles.S2236,
                  possedeOrdis: true,
                ),
                Salle(
                  salle: Salles.S2127,
                  possedeOrdis: false,
                ),
              ],
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
    return debut.heureSoloStr + "H - " + fin.heureSoloStr + "H";
  }
}

class _PlageHoraireState extends State<PlageHoraire> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 100,
        top: 40,
        right: 100,
        bottom: 20,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        widget.horaireString,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
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
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      height: 50,
      decoration: BoxDecoration(
        color: widget.salle.couleur.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //width: double.infinity,
            child: Text(
              widget.salle.nom,
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            child: Icon(
              widget.salleOrdi,
              color: Colors.grey[800],
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

enum Salles {
  S2129,
  S2127,
  S1110,
  S2236,
}

extension DetailsSalles on Salles {
  static const noms = {
    Salles.S1110: 'Salle 1110',
    Salles.S2127: 'Salle 2127',
    Salles.S2129: 'Salle 2129',
    Salles.S2236: 'Salle 2236'
  };

  String get nom => noms[this];
  Color get couleur => Matiere.couleurString(nom);
}
