import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Calendar {
  int ressource = 1205;
  int projectId = 4;
  int nbWeeks = 1;

  String url;

  Calendar() {
    this.url =
        "http://ade.unicaen.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=$ressource&projectId=$projectId&calType=ical&nbWeeks=$nbWeeks";
    this.display();
  }

  void display() {
    getHtmlCC().then((value) => traitement(value.body));
  }

  void traitement(String content) {
    content.split("DTSTART");
    print(content[0]);
  }

  Future<http.Response> getHtmlCC() async {
    return http.get(url);
  }
}
