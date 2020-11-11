import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class BoutonAPropos extends StatelessWidget {
  BoutonAPropos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {}
}

class popupAPropos extends StatefulWidget {
  popupAPropos({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _popupAProposState();
  }
}

class _popupAProposState extends State<popupAPropos> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      print('packageInfo content :' +
          _packageInfo.version +
          " " +
          _packageInfo.appName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('A propos'),
      content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text("Nom : "),
              Text(_packageInfo.appName),
              Expanded(
                  child: Divider(
                thickness: 2,
                color: Colors.black,
                indent: 30,
                endIndent: 30,
              )),
              Text("Version : "),
              Text(_packageInfo.version)
            ])
          ]),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
