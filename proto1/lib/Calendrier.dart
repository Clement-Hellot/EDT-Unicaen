import 'package:http/http.dart' as http;

import 'objets.dart';

abstract class Calendrier {
  final int ressource;
  final int nbWeeks;

  int projectId = 4; // 3

  String url;
  String rawCal;
  List<Cours> cours;

  Calendrier({
    this.ressource = 1205,
    this.projectId = 4,
    this.nbWeeks = 2,
  }) {
    this.url =
        "http://ade.unicaen.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=$ressource&projectId=$projectId&calType=ical&nbWeeks=$nbWeeks";
    cours = new List<Cours>();
  }

  traitement();

  creerCours(String calEvent);

  getHtmlCal() async {
    this.rawCal = await http.read(url);
    traitement();
  }

  rangerCours() {
    cours.sort((a, b) => a.debut.date.compareTo(b.debut.date));
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

  static DateTime dateJour(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
