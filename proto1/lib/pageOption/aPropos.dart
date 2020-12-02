import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:theme_provider/theme_provider.dart';

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
      title: Text('A propos',
        style: TextStyle(
            color: ThemeProvider.themeOf(context).data.textTheme.headline1.color,
        ),
      ),
      content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                "Nom : ",
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).data.textTheme.headline1.color,
                ),
              ),
              Text(_packageInfo.appName,
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).data.textTheme.headline1.color,
                ),),
              Expanded(
                  child: Divider(
                thickness: 2,
                color: ThemeProvider.themeOf(context).data.textTheme.headline6.color,
                indent: 30,
                endIndent: 30,
              )),
              Text("Version : ",
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).data.textTheme.headline1.color,
                ),),
              Text(_packageInfo.version,
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).data.textTheme.headline1.color,
                ),)
            ])
          ]),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: ThemeProvider.themeOf(context).data.primaryColor,
          child: Text(
            'Fermer',
            style: TextStyle(
              color: ThemeProvider.themeOf(context).data.textTheme.headline1.color,
            ),
          ),
        ),
      ],
    );
  }
}
