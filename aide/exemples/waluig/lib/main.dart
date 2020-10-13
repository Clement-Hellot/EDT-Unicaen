import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(AppYeet());

class AppYeet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeYeet(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomeYeet extends StatefulWidget {
  @override
  _HomeYeetState createState() => _HomeYeetState();
}

class _HomeYeetState extends State<HomeYeet> {
  static final Image waluig1 = Image.asset('assets/waluig.png');
  static final Image waluig2 = Image.asset('assets/waluig2.png');

  bool eef = true;
  String eefText = "eef";
  Image currWaluig;

  _HomeYeetState() {
    currWaluig = waluig1;
  }

  updateEef() {
    eef = !eef;
    changeText();
    changeImage();
  }

  changeText() {
    setState(() {
      if (eef)
        eefText = "eef";
      else
        eefText = "o o f";
    });
  }

  changeImage() {
    setState(() {
      if (eef)
        currWaluig = waluig1;
      else
        currWaluig = waluig2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "yeet",
          style: TextStyle(
              fontFamily: "Rubik",
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 8.0),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            currWaluig,
            MovingWah(
              min: 0.95,
              max: 5.0,
              step: 0.12,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateEef,
        child: Text(eefText),
      ),
    );
  }
}

class MovingWah extends StatefulWidget {
  MovingWah({Key key, this.min, this.max, this.step}) : super(key: key);

  final double min;
  final double max;
  final double step;

  @override
  _MovingWahState createState() => _MovingWahState(min, max, step);
}

class _MovingWahState extends State<MovingWah> {
  Timer timer;
  double wahTime;
  double wahStep;
  double wahMinSpace;
  double wahMaxSpace;
  double wahSpace;

  _MovingWahState(double min, double max, double step) {
    wahMinSpace = min;
    wahMaxSpace = max;
    wahStep = step;
    wahSpace = min;
    wahTime = 0.0;

    timer = Timer.periodic(Duration(milliseconds: 35), (Timer t) {
      changeWahSpace();
    });
  }

  changeWahSpace() {
    // Honnetement c'est la pire idée du monde de recalculer l'espacement des
    // lettres à chaque fois, je suis sûr qu'il y des widgets d'animation
    // bien plus opti
    wahTime += wahStep;
    setState(() {
      wahSpace = wahMinSpace + cos(wahTime) * (wahMaxSpace - wahMinSpace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "wah",
      style: TextStyle(
        fontFamily: 'Righteous',
        fontSize: 40.0,
        color: Colors.purple,
        letterSpacing: wahSpace,
      ),
    );
  }
}

class WaluigPage extends StatefulWidget {
  @override
  _WaluigPageState createState() => _WaluigPageState();
}

class _WaluigPageState extends State<WaluigPage> {
  static final Image waluig1 = Image.asset('assets/waluig.png');
  static final Image waluig2 = Image.asset('assets/waluig2.png');

  bool eef = true;
  String eefText = "eef";
  Image currWaluig;

  _WaluigPage() {
    currWaluig = waluig1;
  }

  updateEef() {
    eef = !eef;
    changeText();
    changeImage();
  }

  changeText() {
    setState(() {
      if (eef)
        eefText = "eef";
      else
        eefText = "o o f";
    });
  }

  changeImage() {
    setState(() {
      if (eef)
        currWaluig = waluig1;
      else
        currWaluig = waluig2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "yeet",
          style: TextStyle(
              fontFamily: "Rubik",
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 8.0),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            currWaluig,
            MovingWah(
              min: 0.95,
              max: 5.0,
              step: 0.12,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateEef,
        child: Text(eefText),
      ),
    );
  }
}
