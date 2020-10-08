import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class Controle {
  JourSemaine jourSemaine;
  String matiere;
  String enseignant;
  String epreuve;
  String lieu;
  Heure duree;
  Heure debut;

  Controle(this.jourSemaine, this.matiere, this.enseignant, this.epreuve, this.lieu,
      this.duree, this.debut);

  @override
  String toString() {
    return 'Cc(jour: $jourSemaine , matiere: $matiere, enseignant: $enseignant, epreuve: $epreuve, lieu: $lieu, duree: $duree)';
  }

  void display() {
    print(this.toString());
  }
}


class SemaineCc {
  String semaine;//TODO mieux faire que ca, genre passer par une classe spe
  List<Controle> controles;

  SemaineCc(List<Controle> cc,semaine){
    if (cc != null) {
      ajouterCc(cc);
    }
    this.semaine = semaine;
  }

  ajouterCc(List<Controle> cc) {
    this.controles = new List<Controle>();
    this.controles.addAll(cc);
    /*
    Cours last;

    for (Controle c in cc) {
      if (c is Controle) {
        if (last != null) {
          Duration dif = c.debut.date.difference(last.fin.date);
          if (dif.inMinutes > 15) {
            this.cours.add(Pause(last.fin, c.debut));
          }
        }

        last = c;
      } else {
        last = null;
      }

      this.cours.add(c);
    }
    */
  }

  @override
  String toString() {
    String retour ="semaine :\n";
    for(Controle cc in this.controles){
      retour += cc.toString() + "\n";
    }
    return retour;
  }

  void display() {
    print(this.toString());
  }
}



class Heure{

  int heures;
  int minutes;

  Heure({this.heures, this.minutes});

  //permet d'avoir la fin d'un cours en lui donnant la duree du cours sous forme d'heure
  Heure getHeureFinEvenement(Heure heure) {
    int h = this.heures + heure.heures;
    int m = this.minutes + heure.minutes;

    //transformer les minutes en trop en heures
    while(m >= 60) {
      h++;
      m-=60;
    }

    while(h>= 24) {
      h-=24;
    }

    return Heure(heures: h,minutes: m);
  }

  String format(){
    return "$heures:$minutes";
  }
}

enum JourSemaine {
  LUNDI,
  MARDI,
  MECREDI,
  JEUDI,
  VENDREDI,
  SAMEDI,
  DIMANCHE
}

extension JourSemaineExtension on JourSemaine {

  String get name {
    switch (this) {
      case JourSemaine.LUNDI:
        return 'lundi';
      case JourSemaine.MARDI:
        return 'mardi';
      case JourSemaine.MECREDI:
        return 'mercredi';
      case JourSemaine.JEUDI:
        return 'jeudi';
      case JourSemaine.VENDREDI:
        return 'vendredi';
      case JourSemaine.SAMEDI:
        return 'samedi';
      case JourSemaine.DIMANCHE:
        return 'dimanche';

    }
  }
}
