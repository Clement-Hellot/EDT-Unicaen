import 'package:edt_mobile/pageOptions.dart';
import 'package:flutter/material.dart';

import 'pageEdt.dart';
import 'pageMails.dart';
import 'pageSalles.dart';
import 'pageControles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EDT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      _changePageIndex(index);
      controller.jumpToPage(index);
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
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 11,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              // Un peu sale mais apparemment il faut un title
              // Ce qui est assez bizarre parce que title est sensé
              // être déprécié pour utiliser label à la place
              title: Text(
                '',
                style: TextStyle(
                  fontSize: 0,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              title: Text(
                '',
                style: TextStyle(
                  fontSize: 0,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.desktop_windows),
              title: Text(
                '',
                style: TextStyle(
                  fontSize: 0,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text(
                '',
                style: TextStyle(
                  fontSize: 0,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              title: Text(
                '',
                style: TextStyle(
                  fontSize: 0,
                ),
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // backgroundColor: Colors.lightBlue[500],
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          iconSize: 30,
          selectedItemColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
