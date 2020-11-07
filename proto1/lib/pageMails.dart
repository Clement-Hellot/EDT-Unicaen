import 'dart:convert';
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
          Expanded(child: MailContent()),
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
      padding: EdgeInsets.only(top: 10),
      child: FutureBuilder(
        future: exec(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Mail> mail = snapshot.data;
            return ListView.builder(
                itemBuilder: (_, index) => Container(
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
                                  mail[index].getNomFrom(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (mail[index].hasPJ())
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Icon(
                                    Icons.attachment,
                                  ),
                                ),
                              ],
                            ),
                          //if
                        ],
                      ),
                    ),
                itemCount: snapshot.data.length);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
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

    String from = mails[1].getEmailFrom();
    String objet = mails[1].getObjet();
    String date = mails[1].getDate();

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
  String nomFrom;
  String emailFrom;
  String objet;
  String date;
  bool pj;

  Mail(String from, String objet, String date, bool pj) {
    setNom(from);
    setEmailFrom(from);
    this.objet = objet;
    this.date = date;
    this.pj = pj;
  }

  bool hasPJ() {
    return this.pj;
  }

  void setNom(String from) {
    if (from.contains("<") && from.indexOf("<") != 1) {
      nomFrom = from.split("<")[0];
    }
  }

  void setEmailFrom(String from) {
    if (from.contains("<") && from.indexOf("<") != 1) {
      emailFrom = from.split("<")[1];
      emailFrom = emailFrom.replaceRange(
          emailFrom.length - 2, emailFrom.length - 1, "");
    } else {
      emailFrom = from;
    }
  }

  String getNomFrom() {
    return nomFrom;
  }

  String getEmailFrom() {
    return emailFrom;
  }

  String getObjet() {
    return objet;
  }

  String getDate() {
    return date;
  }

  void aff() {
    print(nomFrom + emailFrom + objet + date);
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
    if (txt.contains("=?UTF-8?Q?")) {
      txt = txt.replaceAll("=?UTF-8?Q?", "");
    } else {
      txt = txt.replaceAll("=?utf-8?Q?", "");
    }
    txt = txt.replaceAll("?=", "");
    if (txt.contains("_")) {
      txt = txt.replaceAll("_", " ");
    }

    while (txt.contains("=")) {
      int i = txt.indexOf("=");
      String search = txt[i + 1] + txt[i + 2];
      int hexa = hex.decode(search).first;
      if (i + 5 < txt.length && txt[i + 3] == "=") {
        String search2 = txt[i + 4] + txt[i + 5];
        int hexa2 = hex.decode(search2).first;
        txt = txt.replaceAll(
            "=" + search + "=" + search2, utf8.decode([hexa, hexa2]));
      } else {
        txt = txt.replaceAll("=" + search, String.fromCharCode(hexa));
      }
    }

    return txt;
  }

  Future<String> getFrom(ImapFolder folder, int number) async {
    String res;
    Map<int, Map<String, dynamic>> from = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (FROM)]"], messageIds: [number]);
    res = from.values.last.values.last;
    res = res.split(":")[1];
    if (res.contains("=?utf-8?Q?")) {
      res = quoPriToUtf(res);
    }
    return res;
  }

  Future<String> getObjet(ImapFolder folder, int number) async {
    String res;
    List liste = new List();
    Map<int, Map<String, dynamic>> objet = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (SUBJECT)]"], messageIds: [number]);
    res = objet.values.last.values.last;
    liste = res.split(":");
    liste.removeAt(0);
    res = liste.join(":");

    if (res.contains("=?UTF-8?Q?")) {
      res = quoPriToUtf(res);
    }

    return res;
  }

  Future<String> getDate(ImapFolder folder, int number) async {
    String res;
    List liste = new List();
    Map<int, Map<String, dynamic>> date =
        await folder.fetch(["INTERNALDATE"], messageIds: [number]);
    res = date.values.last.values.last;
    return res;
  }

  Future<bool> hasPJ(ImapFolder folder, int number) async {
    Map<int, Map<String, dynamic>> pj =
        await folder.fetch(["BODYSTRUCTURE"], messageIds: [number]);

    Map<String, dynamic> bodystruct = pj.values.last.values.last;
    bodystruct = bodystruct.values.first[1];

    String res;
    if (bodystruct.values.first is String)
      res = bodystruct.values.first;
    else {
      res = bodystruct.values.first[1].values.first;
    }

    if (res == "TEXT")
      return false;
    else
      return true;
  }

  Future<dynamic> getFlags(ImapFolder folder, int number) async {
    Map<int, Map<String, dynamic>> flags =
        await folder.fetch(["FLAGS"], messageIds: [number]);
    return (flags.values.last.values.last);
  }

  Future<List> getMail(String folderName) async {
    ImapFolder folder = await imapClient.getFolder(folderName);
    int size = folder.mailCount;
    List<Mail> liste = new List();

    for (int i = size - 7; i > size - 20; i--) {
      int mailNumber;
      String from, objet, date;
      bool pj;
      Mail mail;

      pj = await hasPJ(folder, i);

      from = await getFrom(folder, i);
      objet = await getObjet(folder, i);
      date = await getDate(folder, i);

      mail = new Mail(from, objet, date, pj);
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
