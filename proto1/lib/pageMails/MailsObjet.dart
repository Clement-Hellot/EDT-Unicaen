import 'dart:convert';
import 'package:imap_client/imap_client.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

class JourneeMail {
  DateTime date;
  List<Mail> mails;

  JourneeMail(DateTime date) {
    this.date = date;
    mails = new List();
  }

  void addMail(Mail mail) {
    this.mails.add(mail);
  }

  List<Mail> getDailyMail() {
    return this.mails;
  }

  String getDate() {
    DateTime today = new DateTime.now();
    int difference = today.day - date.day;
    switch (difference) {
      case 0:
        return "Aujourd'hui";
        break;
      case 1:
        return "Hier";
      default:
        return date.day.toString() +
            "/" +
            date.month.toString() +
            "/" +
            date.year.toString();
    }
  }
}

class Mail {
  int id;
  String nomFrom;
  String emailFrom;
  String objet;
  DateTime date;
  bool pj;
  List flags;
  String html;

  Mail(this.id, String from, String objet, this.date, this.pj, this.flags,
      this.html) {
    setNom(from);
    setEmailFrom(from);
    if (objet.length == 0) objet = "<Sans Objet>";
    this.objet = objet;
  }

  String getText() {
    return this.html;
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
    } else {
      nomFrom = from;
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
    print(nomFrom);
    print(objet);
    print(date.toString());
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
    String mode = "";
    if (txt.contains("=?UTF-8?Q?")) {
      txt = txt.replaceAll("=?UTF-8?Q?", "");
      mode = "Q";
    } else if (txt.contains("=?ISO-8859-1?Q?")) {
      txt = txt.replaceAll("=?ISO-8859-1?Q?", "");
      mode = "Q";
    } else if (txt.contains("=?UTF-8?B?")) {
      txt = txt.replaceAll("=?UTF-8?B?", "");
      mode = "B";
    } else if (txt.contains("=?utf-8?B?")) {
      txt = txt.replaceAll("=?utf-8?B?", "");
      mode = "B";
    } else {
      txt = txt.replaceAll("=?utf-8?Q?", "");
      mode = "Q";
    }

    txt = txt.replaceAll("?=", "");
    if (txt.contains("_")) {
      txt = txt.replaceAll("_", " ");
    }

    if (mode == "B") {
      List liste = txt.split(" ");
      List b64;
      txt = "";
      liste.forEach((element) {
        if (element.contains("<")) {
          element = element.split("<")[0];
        }
        element = element.trim();
        b64 = base64.decode(element);

        for (int i = 0; i < b64.length; i++) {
          if (b64[i] == 195) {
            txt += utf8.decode([b64[i], b64[i + 1]]);
            i++;
          } else
            txt += String.fromCharCode(b64[i]);
        }
      });
    } else {
      while (txt.contains("=")) {
        int i = txt.indexOf("=");
        int hexa = 0x00;
        String search = txt[i + 1] + txt[i + 2];
        if (txt[i + 1].codeUnits.first != 13) {
          hexa = hex.decode(search).first;
        } else
          txt = txt.replaceRange(i, i, "");

        if (i + 5 < txt.length && search == "C3") {
          String search2 = txt[i + 4] + txt[i + 5];
          int hexa2 = hex.decode(search2).first;

          txt = txt.replaceAll(
              "=" + search + "=" + search2, utf8.decode([hexa, hexa2]));
        } else {
          txt = txt.replaceAll("=" + search, String.fromCharCode(hexa));
        }
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

  String formateString(String res) {
    if (res.contains("'")) {
      res = res.replaceAll("'", "");
    }
    if (res.contains('"')) {
      res = res.replaceAll('"', '');
    }
    res = res.trim();

    if (res.contains("=?utf-8?Q?") ||
        res.contains("=?UTF-8?Q?") ||
        res.contains("=?ISO-8859-1?Q?") ||
        res.contains("=?UTF-8?B?") ||
        res.contains("=?utf-8?B?")) {
      res = quoPriToUtf(res);
    }

    return res;
  }

  Future<String> getFrom(ImapFolder folder, int number) async {
    String res;
    Map<int, Map<String, dynamic>> from = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (FROM)]"], messageIds: [number]);
    res = from.values.last.values.last;
    if (res.split(":")[0] == null) {
      print(res);
    }
    res = res.split(":")[1];
    res = formateString(res);

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
    res = formateString(res);

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
    return (flags.values.last.values.last);
  }

  Future<String> getText(ImapFolder folder, int number) async {
    String out;
    Map<int, Map<String, dynamic>> txt =
        await folder.fetch(["BODY[2]"], messageIds: [number]);

    var res = txt.values.last.values.last;

    if (res == null) {
      out = "";
    } else if (res is! String) {
      print(res);
      print(res.runtimeType);
      out = res[0];
    } else {
      out = res;
    }
    ;

    return out;
  }

  Future<List<JourneeMail>> getMail(String folderName) async {
    ImapFolder folder = await imapClient.getFolder(folderName);
    int size = folder.mailCount;
    List<JourneeMail> liste = new List();
    DateTime lastDate;

    for (int i = size; i > size - 10; i--) {
      int mailNumber = i;
      String from, objet, html;
      DateTime date;
      bool pj;
      Mail mail;
      List flags = new List();
      JourneeMail journee;

      flags = await getFlags(folder, i);
      pj = await hasPJ(folder, i);
      from = await getFrom(folder, i);
      objet = await getObjet(folder, i);
      date = await getDate(folder, i);
      html = await getText(folder, i);

      mail = new Mail(mailNumber, from, objet, date, pj, flags, html);

      if (lastDate == null) {
        lastDate = date;
        journee = new JourneeMail(lastDate);
        journee.addMail(mail);
        liste.add(journee);
      } else if (lastDate.year != date.year ||
          lastDate.month != date.month ||
          lastDate.day != date.day) {
        journee = new JourneeMail(date);
        journee.addMail(mail);
        liste.add(journee);
      } else {
        journee = liste.last;
        journee.addMail(mail);
      }
      lastDate = date;
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
