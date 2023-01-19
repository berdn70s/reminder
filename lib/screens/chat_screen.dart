import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remainder/models/project.dart';
import 'package:remainder/services/database_service.dart';
import '../models/message.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  final Project project;

  const ChatPage(
      this.project, {
        Key? key,
      }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;

  DatabaseService service = DatabaseService();
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool reverse = true;
  bool enableButton = false;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    snapshots=getSnapshots();
    textEditingController.addListener(() {
      setState(() {});
    });
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots()  {
    return FirebaseFirestore.instance
        .collection("projects")
        .doc(widget.project.id)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }


  Future<void> sendMessage() async {
    String text = textEditingController.text;
    String name = await getNameOfContributor();
    Message message = Message(text, name, FirebaseAuth.instance.currentUser!.uid, DateTime.now());
    await service.addMessage(widget.project, message);
    await service.updateProject(widget.project);
  }

  Future<String> getNameOfContributor() async {
    String firstName = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          onPressed: () {
            if (textEditingController.text == "") {
            } else {
              sendMessage();
              setState(() {
                snapshots=getSnapshots();
              });
              textEditingController.text = "";
            }
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
                  stream: snapshots,
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
                                    backgroundColor: ds["senderName"][0] == " " ? Colors.transparent : Colors.black26 ,
                                    child: Text(ds["senderName"][0])),
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.9,
                                  height: 40,
                                  child: BubbleNormal(
                                    isSender: false,
                                    text: ds["content"],
                                    textStyle: ds["senderName"][0] == " " ?TextStyle(color: Colors.black54) :TextStyle(color: Colors.black),
                                    color:ds["senderName"][0] == " " ? Colors.grey : Colors.blueGrey,
                                    tail: ds["senderName"][0] == " " ? false : true,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.9,
                                  height: 40,
                                  child: Expanded(
                                    child: BubbleNormal(
                                      sent: true,
                                      isSender: true,
                                      text: ds["content"],
                                      color: Colors.orange,
                                      tail: true,
                                    ),
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