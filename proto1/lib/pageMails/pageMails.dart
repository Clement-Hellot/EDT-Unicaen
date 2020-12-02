import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import './MailsObjet.dart';

String currentMailbox = "inbox";

class PageMails extends StatefulWidget {
  @override
  _PageMailsState createState() => _PageMailsState();
}

class _PageMailsState extends State<PageMails> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RefreshIndicator(
        child: FutureBuilder(
            future: getMailbox(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  key: _scaffoldKey,
                  drawer: Drawer(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[600],
                        ),
                        padding: EdgeInsets.only(
                            top: 40, left: 5, right: 5, bottom: 20),
                        margin: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_circle,
                                ),
                                Text(
                                  ' 21905584',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                            Icon(Icons.logout),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: (() {
                                    if (getMailboxName(snapshot.data[index]) ==
                                        currentMailbox) {
                                      return BoxDecoration(boxShadow: [
                                        const BoxShadow(
                                          color: Colors.black,
                                        ),
                                        const BoxShadow(
                                          color: Colors.white,
                                          spreadRadius: 0.0,
                                          blurRadius: 0.1,
                                        ),
                                      ]);
                                    }
                                    ;
                                  })(),
                                  child: ListTile(
                                    leading: Icon(Icons.mail),
                                    title: Text(snapshot.data[index]),
                                    onTap: () {
                                      setState(() {
                                        currentMailbox = getMailboxName(
                                            snapshot.data[index]);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ]),
                        ),
                      )
                    ],
                  )),
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.black),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        tooltip: 'Search',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        tooltip: 'Settings',
                        onPressed: () {
                          setState(() {
                            currentMailbox = 'inbox';
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.more_horiz), 
                        color: Colors.black,   
                        tooltip: 'Plus',


                      ),
                    ],
                  ),
                  body: Column(
                    children: <Widget>[
                      Expanded(child: DailyMail(currentMailbox)),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WriteMail("", "", "")),
                      );
                    },
                    child: Icon(Icons.create),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        onRefresh: () {
          setState(() {
            currentMailbox = currentMailbox;
          });
          return Future.delayed(Duration(seconds: 2));
        },
      ),
    );
  }
}

class DailyMail extends StatefulWidget {
  @override
  _DailyMailState createState() => _DailyMailState();
  DailyMail(this.mailbox);
  String mailbox;
}

class _DailyMailState extends State<DailyMail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: FutureBuilder(
        future: exec(widget.mailbox),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length != 0) {
            List<JourneeMail> mail = snapshot.data;
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "  " + mail[index].getDate(),
                      style: TextStyle(
                          color: Colors.lightBlue[600],
                          fontWeight: FontWeight.bold),
                    ),
                    MailWidget(mail[index].getDailyMail())
                  ]),
            );
          } else if (snapshot.hasData && snapshot.data.length == 0) {
            return Container(
              child: Column(
                children: [
                  Icon(Icons.mail_outlined),
                  Text("Aucun mail dans ce dossier")
                ],
              ),
            );
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

class MailWidget extends StatefulWidget {
  @override
  _MailWidgetState createState() => _MailWidgetState();

  MailWidget(this.mails);

  final List<Mail> mails;
}

class _MailWidgetState extends State<MailWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> liste = new List();
    for (Mail mail in widget.mails) {
      liste.add(MailContent(mail));
    }

    return Column(
      children: liste,
    );
  }
}

class MailContent extends StatefulWidget {
  @override
  _Mail createState() => _Mail();

  MailContent(this.mail);

  final Mail mail;
}

class _Mail extends State<MailContent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReadMailWidget(widget.mail)),
        );
      },
      child: Container(
        child: Dismissible(
          key: ValueKey(this),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.grey[200],
            ),
            margin: EdgeInsets.only(
              left: 10,
              top: 5,
              right: 10,
              bottom: 5,
            ),
            child: Row(
              children: <Widget>[
                if (!widget.mail.isSeen())
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
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.mail.getObjet(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                widget.mail.getTime(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
                                widget.mail.getNomFrom(),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (widget.mail.hasPJ())
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
          background: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: 10,
            ),
            color: Colors.green,
            child: Icon(Icons.check),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
              right: 10,
            ),
            color: Colors.red,
            child: Icon(Icons.delete),
          ),
          onDismissed: (direction) {
            switch (direction) {
              case DismissDirection.startToEnd:
                print('read');
                break;
              case DismissDirection.endToStart:
                print('delete');
                break;
            }
          },
        ),
      ),
    );
  }
}

class ReadMailWidget extends StatefulWidget {
  @override
  _ReadMailWidgetState createState() => _ReadMailWidgetState();

  ReadMailWidget(this.mail);

  final Mail mail;
}

class _ReadMailWidgetState extends State<ReadMailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        actions: [
          Icon(Icons.reply_all),
          IconButton(
              icon: Icon(Icons.reply),
              iconSize: 40.0,
              onPressed: () {
                print('re');
                String objet = "RE :" + widget.mail.getObjet();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WriteMail(
                          widget.mail.emailFrom, objet, widget.mail.getText())),
                );
              }),
          IconButton(
              icon: Icon(Icons.forward),
              iconSize: 40.0,
              onPressed: () {
                String objet = "FWD :" + widget.mail.getObjet();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WriteMail("", objet, widget.mail.getText())),
                );
              }),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        widget.mail.getObjet(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Text(
                      widget.mail.getDatetime(),
                      textAlign: TextAlign.end,
                    ),
                  ],
                )),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1)),
                child: Row(
                  children: [
                    Text(widget.mail.getNomFrom()),
                    Text(widget.mail.getEmailFrom()),
                  ],
                )),
            Flexible(
                child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1)),
                child: Html(
                  data: widget.mail.getText(),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class WriteMail extends StatefulWidget {
  @override
  _WriteMailState createState() => _WriteMailState();

  WriteMail(this.username, this.sujet, this.body);

  String username = "";
  String sujet = "";
  String body = "";
}

class _WriteMailState extends State<WriteMail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mail"),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              sendMsg(
                  '21905584@etu.unicaen.fr', new List(), '123465', 'hey you');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1)),
                child: Row(
                  children: [
                    Text("A :"),
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: widget.username),
                      ),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1)),
                child: Row(
                  children: [
                    Text("CC :"),
                    Expanded(
                      child: TextField(),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1)),
                child: Row(
                  children: [
                    Text("Sujet :"),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: widget.sujet),
                      ),
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1)),
                child: Row(
                  children: [
                    Text("Pieces jointes"),
                    Expanded(
                      child: TextField(),
                    ),
                  ],
                )),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                expands: true,
                maxLines: null,
                minLines: null,
                controller: TextEditingController(text: widget.body),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
  String searchKeyword = "";
  TextEditingController inputSearchController = new TextEditingController();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[400],
          elevation: 0,
          title: TextField(
              controller: widget.inputSearchController,
              decoration: InputDecoration(
                hintText: "Rechercher",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              onChanged: (text) {
                setState(() {
                  widget.searchKeyword = text;
                });
              }),
        ),
        body: SizedBox.expand(
          child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  if (widget.searchKeyword != "")
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                            "Rechercher \"${widget.searchKeyword}\" dans les mails"))
                ],
              )),
        ));
  }
}

Future<List> exec(String mailbox) async {
  MailClient client = await connect();

  List<JourneeMail> mails = await client.getMail(mailbox);
  return mails;
}

Future<MailClient> connect() async {
  MailClient client = MailClient.getMailClient();
  bool connected = await client.connect();

  if (connected) {
    return client;
  } else {
    throw new ErrorDescription("Login Failed");
  }
}

void sendMsg(String to, List<String> cc, String objet, String text) async {
  MailClient client = await connect();
  await client.sendMail(to, cc, objet, text);
}

Future<List> getMailbox() async {
  MailClient client = await connect();

  List folders = await client.getFolderList();
  List<String> mailbox = new List();
  folders.forEach((element) {
    String name = element.name.toLowerCase();
    name = name.replaceRange(0, 1, name.substring(0, 1).toUpperCase());

    switch (name.toLowerCase()) {
      case 'inbox':
        name = 'Boite de reception';
        break;
      case 'sent':
        name = 'Envoyé';
        break;
      case 'junk':
        name = 'Spam';
        break;
      case 'drafts':
        name = 'Brouillons';
        break;
      case 'trash':
        name = 'Corbeille';
        break;
      case 'e-campus':
        name = "PAS TOUCHER B64";
        break;
      case 'information':
        name = "PAS TOUCHER UTF8";
        break;
      case 'projet':
        name = "PAS TOUCHER B64";
        break;
    }
    mailbox.add(name);
  });
  mailbox.sort((a, b) => a.codeUnitAt(0) - b.codeUnitAt(0));
  return mailbox;
}

String getMailboxName(String name) {
  switch (name) {
    case 'Boite de reception':
      name = 'inbox';
      break;
    case 'Envoyé':
      name = 'sent';
      break;
    case 'Spam':
      name = 'junk';
      break;
    case 'Brouillons':
      name = 'drafts';
      break;
    case 'Corbeille':
      name = 'trash';
      break;
  }
  return name;
}
