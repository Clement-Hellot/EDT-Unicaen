import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imap_client/imap_client.dart';
import 'package:convert/convert.dart';
import 'pageOption/theme.dart';

class PageMails extends StatefulWidget {
  @override
  _PageMailsState createState() => _PageMailsState();
}

class _PageMailsState extends State<PageMails> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.lightBlue,
            height: 104.5,
            alignment: Alignment.center,
            child: Text(
              'Mail',
              style: TextStyle(
                color: Colors.black,
                fontSize: 45,
                fontWeight: FontWeight.w400,
                height: 2.1,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search',
                color: AppTheme().iconColor,
                onPressed: abc,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh',
                color: AppTheme().iconColor,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Refresh',
                color: AppTheme().iconColor,
                onPressed: () {},
              ),
            ],
          ),
          MailContent(),
        ],
      ),
    );
  }
}

class MailContent extends StatefulWidget {
  @override
  _Mail createState() => _Mail();
}

class _Mail extends State<MailContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: FutureBuilder(
          future: exec(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Mail> mail = snapshot.data;
              return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(
                          left: 25,
                          top: 5,
                          right: 25,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    mail[index].getObjet(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    mail[index].getDate(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    mail[index].getFrom(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ));
                  },
                  itemCount: snapshot.data.length);
            } else {
              return Center(
                child: Icon(Icons.hourglass_bottom_rounded),
              );
            }
          },
        ));
  }
}

void abc() async {
  MailClient client = new MailClient();
  bool connected = await client.connect();

  if (connected) {
    List<Mail> mails = await client.getMail('inbox');
  }
}

Future<List> exec() async {
  MailClient client = new MailClient();
  bool connected = await client.connect();

  if (connected) {
    List<Mail> mails = await client.getMail('inbox');
    print(mails);

    String from = mails[1].getFrom();
    String objet = mails[1].getObjet();
    String date = mails[1].getDate();

    print(from);
    print(objet);
    print(date);

    return mails;

    /*mails.forEach((element){    
    String from = element(1).getFrom;
    print(from);
  });*/
  } else {
    return List<Mail>();
  }
}

class Mail {
  String from;
  String objet;
  String date;

  Mail(String from, String objet, String date) {
    this.from = from;
    this.objet = objet;
    this.date = date;
  }

  String getFrom() {
    return from;
  }

  String getObjet() {
    return objet;
  }

  String getDate() {
    return date;
  }

  void aff() {
    print(from + objet + date);
    print("-----------------------------------");
  }
}

class MailClient {
  String username = '21906426';
  String password = '_CD2001_';
  ImapClient imapClient;
  String imapHost = "imap.unicaen.fr";
  int port = 993;

  MailClient() {
    imapClient = new ImapClient();
  }

  Future<bool> connect() async {
    await imapClient.connect(imapHost, port, true);
    ImapTaggedResponse response = await imapClient.login(username, password);
    if (!getError(response))
      throw new ErrorDescription("Echec Connexion");
    else
      return true;
  }

  Future<List> getFolderList() async {
    List<ImapListResponse> folder = await imapClient.list('*');
    List liste = [];
    folder.forEach((element) {
      liste.add(element.name);
    });
    return liste;
  }

  ImapClient getClient() {
    return this.imapClient;
  }

  String quoPriToUtf(String txt) {
    print("Quoted printed");
    txt = txt.replaceAll("=?UTF-8?Q?", "");
    txt = txt.replaceAll("?=", "");
    if (txt.contains("_")) {
      txt = txt.replaceAll("_", " ");
    }

    while (txt.contains("=")) {
      int i = txt.indexOf("=");
      String search = txt[i + 1] + txt[i + 2];
      int hexa = hex.decode(search).first;
      txt = txt.replaceAll("=" + search, String.fromCharCode(hexa));
    }

    return txt;
  }

  Future<String> getFrom(ImapFolder folder, int number) async {
    String res;
    Map<int, Map<String, dynamic>> from = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (FROM)]"], messageIds: [number]);
    res = from.values.last.values.last;
    res = res.split(":")[1];
    return res;
  }

  Future<String> getObjet(ImapFolder folder, int number) async {
    String res;
    Map<int, Map<String, dynamic>> objet = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (SUBJECT)]"], messageIds: [number]);
    res = objet.values.last.values.last;
    res = res.split(":")[1];

    if (res.contains("=?UTF-8?Q?")) {
      res = quoPriToUtf(res);
    }
    // if (res.contains("?=")) {
    //   res = res.replaceAll("?=", "");
    // }
    // if (res.contains('=?UTF-8?Q')) {
    //   res = res.replaceAll("=?UTF-8?Q", "");
    // }

    return res;
  }

  Future<String> getDate(ImapFolder folder, int number) async {
    String res;
    List liste = new List();
    Map<int, Map<String, dynamic>> date = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (DATE)]"], messageIds: [number]);
    res = date.values.last.values.last;
    liste = res.split(":");
    liste.removeAt(0);
    res = liste.join(":");
    return res;
  }

  Future<List> getMail(String folderName) async {
    ImapFolder folder = await imapClient.getFolder(folderName);
    int size = folder.mailCount;
    List<Mail> liste = new List();

    for (int i = size - 3; i < size; i++) {
      int mailNumber;
      String from, objet, date;
      Mail mail;

      from = await getFrom(folder, i);
      objet = await getObjet(folder, i);
      date = await getDate(folder, i);

      mail = new Mail(from, objet, date);
      liste.add(mail);
    }
    return liste;
  }

  bool getError(ImapTaggedResponse response) {
    switch (response) {
      case ImapTaggedResponse.ok:
        print('ok');
        return true;
        break;
      case ImapTaggedResponse.no:
        print('echec');
        return false;
        break;
      case ImapTaggedResponse.bad:
        print('command not accepted');
        return false;
        break;
      default:
        return false;
    }
  }
}
