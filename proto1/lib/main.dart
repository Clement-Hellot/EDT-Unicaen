import 'package:flutter/material.dart';

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
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PageEDT(),
    PageMails(),
  ];

  int _counter = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
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
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.map),
            title: Text(
              '',
              style: TextStyle(
                fontSize: 0,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alternate_email),
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
      ),
    );
  }
}

class PageEDT extends StatefulWidget {
  @override
  _PageEDTState createState() => _PageEDTState();
}

class _PageEDTState extends State<PageEDT> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'EDT',
      style: TextStyle(fontSize: 30),
    );
  }
}

class PageMails extends StatefulWidget {
  @override
  _PageMailsState createState() => _PageMailsState();
}

class _PageMailsState extends State<PageMails> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Zimbra !',
      style: TextStyle(fontSize: 30),
    );
  }
}
