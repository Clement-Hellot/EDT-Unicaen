import 'dart:ui';

import 'package:flutter/material.dart';
import './MailsObjet.dart';
import '../pageOption/theme.dart';

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
          Expanded(child: DailyMail()),
        ],
      ),
    );
  }
}

class DailyMail extends StatefulWidget {
  @override
  _DailyMailState createState() => _DailyMailState();
}

class _DailyMailState extends State<DailyMail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: FutureBuilder(
        future: exec(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
    return Container(
      child: Dismissible(
        key: ValueKey("value"),
        child: Container(
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
                    color: AppTheme().mailBackgroundColor,
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
                                color: AppTheme().textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              widget.mail.getTime(),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.mail.getNomFrom(),
                              style: TextStyle(
                                color: AppTheme().textColor,
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
      ),
    );
  }
}

void abc() async {
  MailClient client = new MailClient();
  bool connected = await client.connect();

  if (connected) {
    List<JourneeMail> mails = await client.getMail('inbox');
  }
}

Future<List> exec() async {
  MailClient client = new MailClient();
  bool connected = await client.connect();

  if (connected) {
    List<JourneeMail> mails = await client.getMail('inbox');
    return mails;
  } else {
    return List<JourneeMail>();
  }
}
