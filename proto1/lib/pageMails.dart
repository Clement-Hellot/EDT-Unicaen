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
        child: Row(
          children: <Widget>[
            FlatButton(
                onPressed: mailImap,
                color: Colors.white,
                child: Text('click me')),
            FlatButton(
                onPressed: mailImap,
                color: Colors.green,
                child: Text('click me')),
            Text(
              'data',
              style: TextStyle(color: Colors.red),
            )
          ],
        ));
  }
}

class Mail extends StatefulWidget {
  @override
  _Mail createState() => _Mail();
}

class _Mail extends State<Mail> {
  Widget build(BuildContext context) {
    return Text('hey');
  }
}

Future<void> mailImap() async {
  String username = '21905584';
  String password = '123456';
  String host = "imap.unicaen.fr";
  int port = 993;
  // printImapClientDebugLog();

  ImapClient client = new ImapClient();

  await client.connect(host, port, true);

  ImapTaggedResponse logResponse =
      await Future.delayed(Duration(seconds: 0), () {
    return client.login(username, password);
  });

  if (getError(logResponse)) {
    ImapFolder inbox = await Future.delayed(Duration(seconds: 0), () {
      return client.getFolder('inbox');
    });

    getMail(inbox);
  }
}

Future<List> getFolderList(ImapClient client) async {
  List<ImapListResponse> folders =
      await Future.delayed(Duration(seconds: 0), () {
    return client.list('*');
  });

  List liste = [];
  folders.forEach((element) {
    liste.add(element.name);
  });
  return liste;
}

void getMail(ImapFolder folder) async {
  int size = folder.mailCount;

  for (int i = size - 1; i < size; i++) {
    Map<int, Map<String, dynamic>> mail = await folder
        .fetch(["BODY.PEEK[HEADER.FIELDS (FROM)]"], messageIds: [i]);
    int mailNumber = mail.keys.first;
    String from = mail.values.last.values.last;
    print(mailNumber);
    print(from);
  }
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
