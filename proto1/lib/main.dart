import 'package:edt_mobile/pageOption/theme.dart';
import 'package:flutter/material.dart';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/scheduler.dart';
import 'CalendrierJours.dart';
import 'pageEdt.dart';
import 'pageMails/pageMails.dart';
import 'pageSalles.dart';
import 'pageControle/pageControles.dart';
import 'pageOption/pageOptions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Brightness bright;

  @override
  Widget build(BuildContext context) {

    switch(AppTheme().getCurrentTheme()) {
      case 'Sombre':
        AppTheme().changerTheme(context);
        bright = Brightness.dark;
        break;
      case 'Clair':
        bright = Brightness.light;
        break;
      default:
        bright = SchedulerBinding.instance.window.platformBrightness;
        break;
    }

    AppTheme().updateTheme(bright);

    print('Thème : ' + bright.toString());

    return new DynamicTheme(
        defaultBrightness: bright,
        data: (brightness) => AppTheme().themeCourant,
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'EDT Info',
            home: PagePrincipale(),
            theme: theme,
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class PagePrincipale extends StatefulWidget {
  PagePrincipale({Key key}) : super(key: key);

  static CalendrierJours calendrier;

  @override
  _PagePrincipaleState createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  // Page actuelle
  int _selectedIndex = 0;

  final controller = PageController(
    initialPage: 0,
  );

  // Liste pages
  // Dans l'ordre, de gauche à droite
  static List<Widget> _widgetOptions = <Widget>[
    PageEDT(),
    PageMails(),
    PageSalles(),
    PageControles(),
    PageOptions(),
  ];

  void _changePageIndex(int index) {
    _selectedIndex = index;
  }

  // Changement de page
  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == 0 && index == 0) {
        (_widgetOptions[0] as PageEDT).premierePage();
      }

      _changePageIndex(index);
      controller.animateToPage(
        index,
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          controller: controller,
          children: _widgetOptions,
          onPageChanged: (page) {
            setState(() {
              _changePageIndex(page);
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            /*BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 11,
            ),*/
          ],
        ),
        child: BottomNavigationBar(
          selectedFontSize: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
              ),
              activeIcon: Icon(
                Icons.calendar_today,
              ),
              // Un peu sale mais apparemment il faut un title
              // Ce qui est assez bizarre parce que title est sensé
              // être déprécié pour utiliser label à la place

              //En mettant selectedFontSize à 0 dans la BottomNavigationBar (ligne 185) on peut laisser le label vide
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.mail_outline,
              ),
              activeIcon: Icon(
                Icons.mail_outline,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.desktop_windows),
              activeIcon: Icon(
                Icons.desktop_windows,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              activeIcon: Icon(Icons.assignment),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              activeIcon: Icon(Icons.more_horiz),
              label: "",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // backgroundColor: Colors.lightBlue[500],
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          //Remplacé par le contenu de AppTheme pour avoir un mode sombre - Arthur
          iconSize: 30,
          //selectedItemColor: Theme.of(context).accentColor, //Remplacé par ActiveIcon: Icon(...); pour pouvoir définir les couleurs des icones non séléctionnées à la main - Arthur
        ),
      ),
    );
  }
}
