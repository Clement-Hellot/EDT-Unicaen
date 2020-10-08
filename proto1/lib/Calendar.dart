import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'objets.dart';

class Calendar {
  final int ressource;
  final int projectId;
  final int nbWeeks;

  final Function readyFunc;

  String url;
  String rawCal;
  List<Cours> cours;

  Calendar({
    this.ressource = 1205,
    this.projectId = 4,
    this.nbWeeks = 2,
    this.readyFunc,
  }) {
    this.url =
        "http://ade.unicaen.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=$ressource&projectId=$projectId&calType=ical&nbWeeks=$nbWeeks";
    cours = new List<Cours>();

    getHtmlCal();
  }

  aff() {
    //this.rawCal = await getHtmlCal();
  }

  traitement() {
    List<String> coursStr = this.rawCal.split("BEGIN:VEVENT");

    for (String cr in coursStr) {
      if (!cr.contains("DTSTART")) continue;

      creerCours(cr);
    }

    rangerCours();

    readyFunc();
  }

  creerCours(String calEvent) {
    String matiere;
    String prof;
    String salle;
    String debut;
    String fin;

    bool takeNext = false;

    for (String prop in LineSplitter.split(calEvent)) {
      if (prop.contains("DTSTART")) {
        debut = prop.split(":")[1];
      } else if (prop.contains("DTEND")) {
        fin = prop.split(":")[1];
      } else if (prop.contains("SUMMARY")) {
        matiere = prop.split(":")[1];
      } else if (prop.contains("LOCATION")) {
        salle = prop.split(":")[1];
      } else if (prop.contains("DESCRIPTION")) {
        prof = prop.split("\\n")[4];
        takeNext = true;
      } else if (takeNext && !prop.contains("UID")) {
        takeNext = false;
        prof += prop.split("\\n")[0].substring(1);
      }
    }

    matiere = trimMatiere(matiere);
    prof = trimProf(prof);
    // debut = convertDate(debut);
    // fin = convertDate(fin);

    // print(" -----------------");
    // print("Matière : $matiere");
    // print("Prof : $prof");
    // print("Salle : $salle");
    // print("Début : $debut");
    // print("Fin : $debut");

    cours.add(Cours(
      matiere: Matiere(matiere),
      prof: prof,
      salle: salle,
      debut: Horaire.fromCalendar(debut),
      fin: Horaire.fromCalendar(fin),
    ));
  }

  String convertDate(String date) {
    StringBuffer newDate = StringBuffer();
    newDate.write(date.substring(0, 4));
    newDate.write("-");
    newDate.write(date.substring(4, 6));
    newDate.write("-");
    newDate.write(date.substring(6, 8));
    newDate.write(" ");
    newDate.write(date.substring(9, 11));
    newDate.write(":");
    newDate.write(date.substring(11, 13));
    newDate.write(":");
    newDate.write(date.substring(13));

    return newDate.toString();
  }

  String trimMatiere(String mat) {
    return mat.substring(0, mat.length - 4);
  }

  String trimProf(String prof) {
    if (prof.contains("Exported"))
      return prof.split("(")[0];
    else
      return prof;
  }

  getHtmlCal() async {
    this.rawCal = await http.read(url);
    traitement();
  }

  rangerCours() {
    cours.sort((a, b) => a.debut.date.compareTo(b.debut.date));
  }

  printCours() {
    for (Cours c in cours) {
      print(c);
    }
  }

  static jourSemaine(DateTime date) {
    var jours = {
      1: "Lundi",
      2: "Mardi",
      3: "Mercredi",
      4: "Jeudi",
      5: "Vendredi",
      6: "Samedi",
      7: "Dimanche",
    };

    return jours[date.weekday];
  }

  static mois(DateTime date) {
    var jours = {
      1: "Janvier",
      2: "Février",
      3: "Mars",
      4: "Avril",
      5: "Mai",
      6: "Juin",
      7: "Juillet",
      8: "Août",
      9: "Septembre",
      10: "Octobre",
      11: "Novembre",
      12: "Décembre",
    };

    return jours[date.month];
  }
}
