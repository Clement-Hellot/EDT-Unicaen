import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:imap_client/imap_client.dart';

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
                color: Colors.white,
                onPressed: exec,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh',
                color: Colors.white,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Refresh',
                color: Colors.white,
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
        margin: EdgeInsets.only(
          left: 25,
          top: 5,
          right: 25,
          bottom: 5,
        ),
        padding: EdgeInsets.only(left: 14, top: 10, right: 14, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Objet',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Heure',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'From Clement',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ));
  }
}

void exec() async {
  MailClient client = new MailClient();
  bool connected = await client.connect();

  if (connected) {
    List folder = await client.getFolderList();
    List mails = await client.getMail('inbox');
    print(mails);
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

  aff() {
    print(from + objet + date);
    print("-----------------------------------");
  }
}

class MailClient {
  String username = '';
  String password = '';
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

    return res;
  }

  Future<String> getDate(ImapFolder folder, int number) async {
    String res;
    Map<int, Map<String, dynamic>> date = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (DATE)]"], messageIds: [number]);
    res = date.values.last.values.last;
    res = res.split(":")[1];
    return res;
  }

  Future<List> getMail(String folderName) async {
    ImapFolder folder = await imapClient.getFolder(folderName);
    int size = folder.mailCount;
    List<Mail> liste = new List();

    for (int i = size - 2; i < size; i++) {
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
