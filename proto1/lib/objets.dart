import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class Horaire {
  int heures;
  int minutes;

  Horaire(this.heures, this.minutes) {
    if (minutes < 0 || minutes >= 60) {
      heures = heures + (minutes / 60).floor();
      minutes = minutes % 60;
    }
  }

  int get totalMinutes => heures * 60 + minutes;
  double get totalHeures => heures + (minutes / 60.0);

  String get heureStr {
    return toStr2Dig(heures) + ':' + toStr2Dig(minutes);
  }

  String get heureSoloStr {
    return toStr2Dig(heures) + 'H';
  }

  static String toStr2Dig(int n) {
    if (n < 10)
      return '0' + n.toString();
    else
      return n.toString();
  }
}

class Journee {
  // TODO
  // - Attribut date (format date unix)
  // - getter jour de la semaine
  // - getter format Mercredi 7 Octobre
  // - getter format 07/10/2020 ou 2020-10-07

  List<HeureCours> cours;

  Journee({this.cours});
}

class Matiere {
  static int randomMult = 2;

  final String nom;

  Matiere(this.nom);

  /// Retourne une couleur propre à cette matière, générée à partir
  /// de son nom
  Color couleur() {
    String nomOnlyAscii = nom.replaceAll(RegExp(r"[^\s\w]"), '');
    int nomInt = 0;

    for (int n in AsciiCodec().encode(nomOnlyAscii)) {
      nomInt += n;
    }

    double randHue = Random(nomInt * randomMult).nextDouble() * 360;

    return HSVColor.fromAHSV(1, randHue, 0.65, 1.0).toColor();
  }
}

abstract class HeureCours {
  final Horaire debut;
  final Horaire fin;

  HeureCours(this.debut, this.fin);

  double get duree => fin.totalHeures - debut.totalHeures;

  String get horaireString {
    return debut.heureStr + ' - ' + fin.heureStr;
  }
}

class Cours extends HeureCours {
  final Matiere matiere;
  final String prof;
  final String salle;

  Cours({this.matiere, this.prof, this.salle, Horaire debut, Horaire fin})
      : super(debut, fin);
}

class Pause extends HeureCours {
  Pause(Horaire debut, Horaire fin) : super(debut, fin);
}

class Cc {
  String date;
  String matiere;
  String enseignant;
  String epreuve;
  String lieu;
  String duree;

  Cc(this.date, this.matiere, this.enseignant, this.epreuve, this.lieu,
      this.duree);

  @override
  String toString() {
    return 'Cc(date: $date, matiere: $matiere, enseignant: $enseignant, epreuve: $epreuve, lieu: $lieu, duree: $duree)';
  }

  void display() {
    print(this.toString());
  }
}
