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

  // Liste cours ici ? ou alors classe enfant
}

// enum temporaire, après ça sera géré automatiquement, dans une classe Matiere
enum Matieres {
  TD_PHP,
  CM_SYSTEM,
  TD_PROBA,
  TDP_CONCEPTION_OBJET,
}

extension Matiere on Matieres {
  static const noms = {
    Matieres.TD_PHP: 'TD PHP',
    Matieres.CM_SYSTEM: 'CM Système',
    Matieres.TD_PROBA: 'TD Proba/Stats',
    Matieres.TDP_CONCEPTION_OBJET: 'TDP Conception Objet',
  };

  static final couleurs = {
    Matieres.TD_PHP: Colors.purple[300],
    Matieres.CM_SYSTEM: Colors.green[300],
    Matieres.TD_PROBA: Colors.blue[300],
    Matieres.TDP_CONCEPTION_OBJET: Colors.red[300],
  };

  String get nom => noms[this];
  Color get couleur => couleurs[this];
}
