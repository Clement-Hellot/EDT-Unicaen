import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'objets.dart';

class Controle {
  Matiere matiere;
  String enseignant;
  String lieu;
  Horaire fin;
  Horaire debut;

  Controle(this.matiere, this.enseignant, this.lieu,
      this.debut, this.fin);

  @override
  String toString() {
    return 'Cc(matiere: $matiere, enseignant: $enseignant, lieu: $lieu, fin: $fin)';
  }

  String nomJour(){
    switch(this.debut.date.weekday) {
      case 1:
        return "lundi";
      case 2:
        return "mardi";
      case 3:
        return "mercredi";
      case 4:
        return "jeudi";
      case 5:
        return "vendredi";
      case 6:
        return "samedi";
      case 7:
        return "dimanche";
    }
  }

  void display() {
    print(this.toString());
  }
}

class SemaineCc {
  DateTimeRange semaineDate;
  List<Controle> controles;

  SemaineCc(List<Controle> cc,DateTimeRange semaineDate){
    if (cc != null) {
      ajouterCc(cc);
    }
    this.semaineDate = semaineDate;
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

  String nom() {
    return "cette semaine";
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

/*
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
*/
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
