import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'objets.dart';

class Calendar {
  final int ressource;
  final int projectId;
  final int nbWeeks;

  String url;
  String rawCal;
  List<Cours> cours;

  Calendar({this.ressource = 1205, this.projectId = 4, this.nbWeeks = 1}) {
    this.url =
        "http://ade.unicaen.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=$ressource&projectId=$projectId&calType=ical&nbWeeks=$nbWeeks";
    cours = new List<Cours>();
  }

  aff() {
    //this.rawCal = await getHtmlCal();
  }

  traitement() {
    List<String> coursStr = this.rawCal.split("BEGIN:VEVENT");

    for (String cr in coursStr) {
      for (String prop in cr.split("\n")) {}
    }
  }

  Future<String> getHtmlCal() async {
    this.rawCal = await http.read(url);
    traitement();
  }
}
