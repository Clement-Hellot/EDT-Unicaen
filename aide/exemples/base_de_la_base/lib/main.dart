import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    // La base de la base, c'est cette fonction runApp qui affiche
    // le widget principal.
    //
    // Toutes les applis qu'on fait sont, à la base, des MaterialApp.
    // On lui précise dans l'attribut home le widget à afficher
    // et on peut définir un thème qui attribuera automatiquement toutes
    // les couleurs aux objets (boutons, background, etc...)
    //
    home: Text("Hello World"),
    theme: ThemeData.light(),
  ));
}
