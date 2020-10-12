import 'package:flutter/material.dart';

void main() {
  // Niveau au-dessus : on définit la MaterialApp ailleurs pour mieux
  // la personnaliser et segmenter le code
  runApp(MonApp());
}

// Du coup on va créer un widget
// Celui-ci est "stateless", en gros ça veut dire que son contenu va pas changer
// Mais par exemple il peut contenir un "stateful" qui lui va changer
class MonApp extends StatelessWidget {
  // La méthode build est obligatoire pour les widgets, c'est elle qui dit
  // quel widget cette classe va retourner
  @override
  Widget build(BuildContext context) {
    // On retourne donc notre MaterialApp, avec son titre, son thème,
    // et son widget "home"
    return MaterialApp(
      title: 'un joli titre',
      // On peut créer ses propres thèmes
      theme: ThemeData(
        // Ce thème est composé d'abord d'un colorSwatch, qui est en fait une
        // palette de couleur qui sera assignée aux différents éléments
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Text("bonjour"),
    );
  }
}
