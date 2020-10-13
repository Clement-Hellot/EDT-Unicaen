import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageDePhotos(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PageDePhotos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("J'aime les panoramas"),
        elevation: 6.0,
      ),
      body: ListePhotos(),
    );
  }
}

class ListePhotos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        //
        // Première méthode pour utiliser les fichiers d'images
        // stockés dans la mémoire
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/saxoyosh.png")),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 35, right: 10),
              child: Text(
                "Plus d'images par ici ----->",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green[600],
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        //
        // Deuxième méthode, dans un widget qui permet de l'agrandir
        // de plusieurs façon.
        // Avec Boxfit.cover, l'image se met à la taille minimum pour
        // Couvrir tout le cadre.
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/farquad1.png"),
        ),
        //
        // Une méthode pour utiliser directement des images d'internet
        // Alignée en bas de la page
        // Et à la bonne taille pour être tout juste contenue dans le cadre
        //
        // ATTENTION pour les accès à internet il faut activer les
        // permissions dans app/src/main/AndroidManifest.xml
        // (voir le fichier pour un exemple, c'est facile)
        Align(
          alignment: Alignment.bottomCenter,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.network("https://i.redd.it/zle8iz78qw041.jpg"),
          ),
        ),
        //
        // L'autre moyen pour mettre une image avec un url, mais bon
        // honnêtement je crois que la 1ère est mieux
        FittedBox(
          fit: BoxFit.cover,
          child: Image(
            image: NetworkImage(
                "https://i.postimg.cc/kgcPnp1s/Enhanced-Hellothere.jpg"),
          ),
        ),
        //
        // On peut aussi mettre des gifs, mais attention ils sont un peu
        // plus lents
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/scou.gif"),
        ),
        //
        //
        // Voilà voilà après je m'amuse, enjoy les images
        //
        //
        FittedBox(
          fit: BoxFit.contain,
          child: Image.asset("assets/sanic.png"),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Image.asset("assets/beby.jpg"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/bebb.jpg"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/bebby.jpg"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/bebmelon.jpg"),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Image.asset("assets/soinc.jpg"),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Image.asset("assets/kink.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/shrek22a.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/shrek15b.jpg"),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Image.asset("assets/shrek7b.gif"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/smolDude1a.jpg"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/misc6a.png"),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Image.asset("assets/puss1a.png"),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Image.asset("assets/puss2.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/puss3a.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/puss4a.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/puss5a.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/puss7a.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/puss8a.png"),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: Image.asset("assets/puss9.png"),
        ),
      ],
    );
  }
}
