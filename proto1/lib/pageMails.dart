import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
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
                      child: Row(
                        children: <Widget>[
                          if (!mail[index].isSeen())
                            Flexible(
                              flex: null,
                              child: Icon(
                                Icons.circle,
                                color: Colors.lightBlue[500],
                                size: 10,
                              ),
                            ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10,
                              ),
                              padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme().mailBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          mail[index].getObjet(),
                                          style: TextStyle(
                                            color: AppTheme().textColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          mail[index].getTime(),
                                          style: TextStyle(
                                            color: AppTheme().textColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          mail[index].getNomFrom(),
                                          style: TextStyle(
                                            color: AppTheme().textColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      if (mail[index].hasPJ())
                                        Flexible(
                                          child: Icon(
                                            Icons.attachment,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
  DateTime date;
  bool pj;
  List flags;

  Mail(String from, String objet, DateTime date, bool pj, List flags) {
    setNom(from);
    setEmailFrom(from);
    this.objet = objet;
    this.date = date;
    this.pj = pj;
    this.flags = flags;
  }

  bool hasPJ() {
    return this.pj;
  }

  bool isSeen() {
    if (flags.contains("\\Seen")) {
      return true;
    }
    return false;
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
    return date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();
  }

  String getTime() {
    String time = date.hour.toString() + "H";

    if (date.minute.toString().length == 1) time += "0";
    time += date.minute.toString() + "m" + date.second.toString();
    return time;
  }

  void aff() {
    print(nomFrom + emailFrom + objet);
    print("-----------------------------------");
  }
}

class MailClient {
  String username = '21905584';
  String password = '!Clement76440!';
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

  String convertDate(String mois) {
    switch (mois) {
      case "Jan":
        return '01';
      case "Feb":
        return '02';
      case "Mar":
        return "03";
      case "Apr":
        return "04";
      case "May":
        return "05";
      case "Jun":
        return "06";
      case "Jul":
        return "07";
      case "Aug":
        return "08";
      case "Sep":
        return "09";
      case "Oct":
        return "10";
      case "Nov":
        return "11";
      case "Dec":
        return "12";
    }
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

  Future<DateTime> getDate(ImapFolder folder, int number) async {
    String res, tmp;
    List<String> liste = new List();
    Map<int, Map<String, dynamic>> date =
        await folder.fetch(["INTERNALDATE"], messageIds: [number]);
    res = date.values.last.values.last;

    liste = res.split('-');
    liste[1] = convertDate(liste[1]);
    tmp = liste[0];
    liste[0] = liste[2].substring(0, 4);
    liste[2] = tmp + liste[2].substring(4);

    res = liste.join("-");
    res = res.substring(0, res.length - 6);

    DateTime time = DateTime.parse(res);
    return time;
  }

  Future<bool> hasPJ(ImapFolder folder, int number) async {
    Map<int, Map<String, dynamic>> pj =
        await folder.fetch(["BODYSTRUCTURE"], messageIds: [number]);

    Map<String, dynamic> bodystruct = pj.values.last.values.last;
    while (bodystruct.values.first[1] is! String)
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

  Future<List> getFlags(ImapFolder folder, int number) async {
    Map<int, Map<String, dynamic>> flags =
        await folder.fetch(["FLAGS"], messageIds: [number]);
    print(flags.values.last.values.last);
    return (flags.values.last.values.last);
  }

  Future<List> getMail(String folderName) async {
    ImapFolder folder = await imapClient.getFolder(folderName);
    int size = folder.mailCount;
    List<Mail> liste = new List();

    for (int i = size; i > size - 5; i--) {
      int mailNumber;
      String from, objet;
      DateTime date;
      bool pj;
      Mail mail;
      List flags = new List();
      flags = await getFlags(folder, i);
      pj = await hasPJ(folder, i);

      from = await getFrom(folder, i);
      debug(from);
      objet = await getObjet(folder, i);
      debug(objet);
      date = await getDate(folder, i);
      debug(objet);

      mail = new Mail(from, objet, date, pj, flags);
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

  void debug(String txt) {
    if (txt == null) print("null");
  }
}
