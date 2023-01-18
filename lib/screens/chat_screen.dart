import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/services/database_service.dart';
import '../models/message.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  Project project;

  ChatPage(
    this.project, {
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Project project;
  List<Message> wholeMessages = [];

  DatabaseService service = DatabaseService();
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool reverse = true;
  bool enableButton = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    textEditingController.dispose();
  }

  @override
  void initState() {
    project = widget.project;
    textEditingController.addListener(() {
      setState(() {});
    });
    _initRetrieval();
    super.initState();
  }

  Future<void> _initRetrieval() async {
    wholeMessages = await service.retrieveMessage(project);
  }

  Future<void> SendMessage() async {
    String text = textEditingController.value.text;
    String name =
        await getNameOfContributor(FirebaseAuth.instance.currentUser!.uid);
    var time = DateTime.now().millisecondsSinceEpoch;
    Message message =
        Message(text, name, FirebaseAuth.instance.currentUser!.uid, time);
    await service.addMessage(project, message);
    await service.updateProject(project);
    await _initRetrieval();
  }

  Future<String> getNameOfContributor(String id) async {
    String firstName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) => value.docs[0].data()["firstName"]);
    return firstName;
  }

  @override
  Widget build(BuildContext context) {
    var textInput = Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  enableButton = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                hintText: "Type message",
              ),
              controller: textEditingController,
            ),
          ),
        ),
        enableButton
            ? IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: Colors.grey,
                onPressed: (){
                  SendMessage();
                  textEditingController.text="";
                },
              )
            : IconButton(
                color: Colors.blue,
                icon: Icon(
                  Icons.send,
                ),
                disabledColor: Colors.grey,
                onPressed: null,
              )
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "                Chat Section",
          style: TextStyle(color: Colors.white60),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black54, Colors.redAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("projects")
                      .doc(project.id)
                      .collection("messages")
                      .orderBy("time")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var ds = snapshot.data!.docs[i];
                          if (ds["senderID"] !=
                              FirebaseAuth.instance.currentUser!.uid) {
                            return Row(
                              children: <Widget>[
                                CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    child: Text(ds["senderName"][0])),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 40,
                                  child: BubbleNormal(
                                    isSender: false,
                                    text: ds["content"],
                                    color: Colors.blueGrey,
                                    tail: true,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 40,
                                  child: BubbleNormal(
                                    sent: true,
                                    isSender: true,
                                    text: ds["content"],
                                    color: Colors.orange,
                                    tail: true,
                                  ),
                                ),
                                CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    child: Text(ds["senderName"][0])),
                              ],
                            );
                          }
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Divider(height: 2.0),
            textInput
          ],
        ),
      ),
    );
  }
}
