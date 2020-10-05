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

  // Liste pages
  // Dans l'ordre, de gauche à droite
  static List<Widget> _widgetOptions = <Widget>[
    PageEDT(),
    PageMails(),
    PageSalles(),
    PageControles(),
  ];

  // Changement de page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _widgetOptions.elementAt(_selectedIndex),
          ],
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
              // Ce qui est assez bizarre parce que title est sensé être déprécié
              // pour utiliser label
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
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: _onItemTapped,
          // backgroundColor: Colors.lightBlue[500],
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          iconSize: 28,
        ),
      ),
    );
  }
}
