import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snitchbotui/requests.dart' as requests;
import 'package:snitchbotui/variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SnitchBot());
}

class SnitchBot extends StatelessWidget {
  const SnitchBot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Snitch Bot',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final screens = [
    const Tweets(sent: false),
    const Tweets(sent: true),
  ];

  final tweetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1d1d1f),
      appBar: AppBar(
        backgroundColor: const Color(0xff151518),
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: SingleChildScrollView(
                        child: AlertDialog(
                          backgroundColor: const Color(0xff151518),
                          title: Row(
                            children: [
                              Icon(
                                Icons.schedule_send,
                                color: const Color(0xFFEFEFEF),
                                size: iconSize,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Add Tweet',
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: dialogBoxTitleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFEFEFEF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          content: TextField(
                            maxLines: 5,
                            controller: tweetController,
                            cursorColor: const Color(0xFFEFEFEF),
                            textInputAction: TextInputAction.done,
                            autofocus: true,
                            decoration: InputDecoration(
                              fillColor: const Color(0xff1d1d1f),
                              filled: true,
                              hintText: "What's happening?",
                              hintStyle: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontSize: dialogBoxTextFieldFontSize,
                                  color: const Color(0xFFEFEFEF)
                                      .withOpacity(0.5)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFEFEFEF),
                                  )),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFEFEFEF),
                                  )),
                            ),
                            style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: dialogBoxTextFieldFontSize,
                              color: const Color(0xFFEFEFEF),
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 0.0, 20.0, 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Color(0xff151518),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFFEFEFEF),
                                    ),
                                    onPressed: () {
                                      if (tweetController.text
                                          .trim()
                                          .isNotEmpty) {
                                        requests.addTweet(
                                            tweetController.text, context);
                                        tweetController.text = '';
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Icon(
                                      Icons.schedule_send,
                                      color: Color(0xff151518),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            icon: Icon(
              Icons.add,
              color: const Color(0xFFEFEFEF),
              size: iconSize,
            )),
        title: Text(
          '🤖 Snitch Bot',
          style: TextStyle(
            fontFamily: "OpenSans",
            fontSize: appBarTitleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFEFEFEF),
          ),
        ),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff151518),
        selectedItemColor: const Color(0xFFEFEFEF),
        unselectedItemColor: const Color(0xFFEFEFEF).withOpacity(0.5),
        selectedFontSize: bottomNavigationBarSelectedFontSize,
        unselectedFontSize: bottomNavigationBarUnselectedFontSize,
        iconSize: iconSize,
        elevation: 1,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? const Icon(Icons.schedule_send)
                  : const Icon(Icons.schedule_send_outlined),
              label: 'To be Send'),
          BottomNavigationBarItem(
              icon: currentIndex == 1
                  ? const Icon(Icons.send)
                  : const Icon(Icons.send_outlined),
              label: 'Sent'),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: const CircleAvatar(
        radius: 60.0,
        backgroundColor: Color(0xff151518),
        backgroundImage: AssetImage('images/snitchbot.jpeg'),
      ),
    );
  }
}

class Tab extends StatelessWidget {
  final String title;
  const Tab({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "OpenSans",
          fontSize: tabTitleFontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFEFEFEF),
        ),
      ),
    );
  }
}

class Tweets extends StatefulWidget {
  final bool sent;
  const Tweets({Key? key, required this.sent}) : super(key: key);

  @override
  State<Tweets> createState() => _TweetsState();
}

class _TweetsState extends State<Tweets> {
  final tweetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1d1d1f),
      body: StreamBuilder<QuerySnapshot>(
          stream: requests.getTweetsStream(widget.sent),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong 😔',
                  style: TextStyle(
                      fontSize: somethingWentWrongFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEFEFEF)),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFEFEFEF)));
            } else if (snapshot.data!.docs.isEmpty) {
              String title = !widget.sent
                  ? 'No Tweets to be Send 😔'
                  : 'No Tweets Sent 😔';
              return Center(
                  child: Column(
                children: [
                  const Avatar(),
                  Tab(title: title),
                ],
              ));
            } else {
              String title = !widget.sent
                  ? 'Tweets to be Send (${snapshot.data!.docs.length})'
                  : 'Tweets Sent (${snapshot.data!.docs.length})';
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      const Avatar(),
                      Tab(title: title),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot tweet =
                                snapshot.data!.docs[index];
                            String label = !widget.sent
                                ? 'Mark as Sent'
                                : 'Mark as to be Send';
                            return Column(
                              children: [
                                index == 0
                                    ? Divider(
                                        color: const Color(0xFFEFEFEF)
                                            .withOpacity(0.3),
                                        thickness: 1.0,
                                      )
                                    : Container(),
                                const Padding(
                                    padding: EdgeInsets.only(bottom: 5.0)),
                                ListTile(
                                    title: Text(
                                      tweet['tweet'],
                                      style: TextStyle(
                                        fontFamily: "OpenSans",
                                        fontSize: listTileTitleFontSize,
                                        color: const Color(0xFFEFEFEF),
                                      ),
                                    ),
                                    trailing: PopupMenuButton<PopMenuValues>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Color(0xFFEFEFEF),
                                        size: 25,
                                      ),
                                      color: const Color(0xff151518),
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          value: PopMenuValues.edit,
                                          child: Text(
                                            'Edit Tweet',
                                            style: TextStyle(
                                              fontFamily: "OpenSans",
                                              fontSize: popupMenuItemFontSize,
                                              color: const Color(0xFFEFEFEF),
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: PopMenuValues.status,
                                          child: Text(
                                            label,
                                            style: TextStyle(
                                              fontFamily: "OpenSans",
                                              fontSize: popupMenuItemFontSize,
                                              color: const Color(0xFFEFEFEF),
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: PopMenuValues.delete,
                                          child: Text(
                                            'Delete Tweet',
                                            style: TextStyle(
                                              fontFamily: "OpenSans",
                                              fontSize: popupMenuItemFontSize,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        switch (value) {
                                          case PopMenuValues.edit:
                                            tweetController.text =
                                                tweet['tweet'];
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: AlertDialog(
                                                        backgroundColor:
                                                            const Color(
                                                                0xff151518),
                                                        title: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.edit,
                                                              color: const Color(
                                                                  0xFFEFEFEF),
                                                              size: iconSize,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          10.0),
                                                              child: Text(
                                                                'Edit Tweet',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "OpenSans",
                                                                  fontSize:
                                                                      dialogBoxTitleFontSize,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color(
                                                                      0xFFEFEFEF),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: TextField(
                                                          maxLines: 5,
                                                          controller:
                                                              tweetController,
                                                          cursorColor:
                                                              const Color(
                                                                  0xFFEFEFEF),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          autofocus: true,
                                                          decoration:
                                                              InputDecoration(
                                                            fillColor:
                                                                const Color(
                                                                    0xff1d1d1f),
                                                            filled: true,
                                                            hintText:
                                                                "What's happening?",
                                                            hintStyle: TextStyle(
                                                                fontFamily:
                                                                    "OpenSans",
                                                                fontSize: dialogBoxTextFieldFontSize,
                                                                color: const Color(
                                                                        0xFFEFEFEF)
                                                                    .withOpacity(
                                                                        0.5)),
                                                            border:
                                                                const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                              color: Color(
                                                                  0xFFEFEFEF),
                                                            )),
                                                            focusedBorder:
                                                                const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                              color: Color(
                                                                  0xFFEFEFEF),
                                                            )),
                                                          ),
                                                          style:
                                                              TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            fontSize: dialogBoxTextFieldFontSize,
                                                            color: const Color(
                                                                0xFFEFEFEF),
                                                          ),
                                                        ),
                                                        actions: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0.0,
                                                                    0.0,
                                                                    20.0,
                                                                    20.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    color: Color(
                                                                        0xff151518),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFEFEFEF),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    if (tweetController
                                                                            .text
                                                                            .trim()
                                                                            .isNotEmpty &&
                                                                        tweetController.text !=
                                                                            tweet['tweet']) {
                                                                      requests.editTweet(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[
                                                                                  index]
                                                                              .id,
                                                                          tweetController
                                                                              .text
                                                                              .trim(),
                                                                          context);
                                                                    }
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons.edit,
                                                                    color: Color(
                                                                        0xff151518),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                            break;
                                          case PopMenuValues.status:
                                            requests.editTweetStatus(
                                                snapshot.data!.docs[index].id,
                                                !widget.sent,
                                                context);
                                            break;
                                          case PopMenuValues.delete:
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: AlertDialog(
                                                        backgroundColor:
                                                            const Color(
                                                                0xff151518),
                                                        title: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .delete_forever,
                                                              color: Colors.red,
                                                              size: iconSize,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          10.0),
                                                              child: Text(
                                                                'Delete Tweet',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "OpenSans",
                                                                  fontSize:
                                                                      dialogBoxTitleFontSize,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Text(
                                                          'Are you sure you want to delete this Tweet permanently?',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            fontSize: dialogBoxTextFieldFontSize,
                                                            color: const Color(
                                                                0xFFEFEFEF),
                                                          ),
                                                        ),
                                                        actions: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0.0,
                                                                    0.0,
                                                                    20.0,
                                                                    20.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFFEFEFEF),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    color: Color(
                                                                        0xff151518),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    requests.deleteTweet(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id,
                                                                        context);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete_forever,
                                                                    color: Color(
                                                                        0xff151518),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                            break;
                                        }
                                      },
                                    )),
                                const Padding(
                                    padding: EdgeInsets.only(bottom: 5.0)),
                                Divider(
                                  color:
                                      const Color(0xFFEFEFEF).withOpacity(0.3),
                                  thickness: 1.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
