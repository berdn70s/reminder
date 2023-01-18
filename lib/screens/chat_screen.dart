import 'package:flutter/material.dart';
import '../models/message.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class  _ChatPageState extends State<ChatPage> {
  List<Message> _userMessages = [];
  List<Message> _receivedMessages = [];
  List<Message> wholeMessages = [];

  Message message1 = Message('Hello Im BERDAN', "Berdan", 'BERDAN ID');
  Message message2 = Message('BEN BERDOS', "Berdan", 'BERDAN ID');
  Message message3 = Message('BEN HAMZA', "HAMZA", 'HAMZA ID');
  Message message4 = Message('BEN SEMIH', "SEMIH", 'SEMIH ID');
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool reverse = true;
  bool enableButton = false;

  @override
  void initState() {
    _userMessages = <Message>[];
    _receivedMessages = <Message>[];
    _userMessages.add(message1);
    _userMessages.add(message2);
    _receivedMessages.add(message3);
    _receivedMessages.add(message4);
    wholeMessages = _userMessages + _receivedMessages;

    textEditingController = TextEditingController();
    scrollController = ScrollController();
    super.initState();
  }

  void SendMessage() {
    var text = textEditingController.value.text;
    Message message = Message(text, 'Berdan', 'BERDAN ID');
    textEditingController.clear();
    setState(() {
      wholeMessages.add(message);
    });
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
                onPressed: SendMessage,
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
              child: ListView.builder(
                itemCount: wholeMessages.length,
                itemBuilder: (context, i) {
                  if (wholeMessages[i].senderID != 'BERDAN ID') {
                    return Row(
                      children: <Widget>[
                        CircleAvatar(
                            child: Text(wholeMessages[i].senderName[0]),
                            backgroundColor: Colors.black26),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 40,
                          child: BubbleNormal(
                            isSender: false,
                            text: wholeMessages[i].content,
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
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 40,
                          child: BubbleNormal(
                            sent: true,
                            isSender: true,
                            text: wholeMessages[i].content,
                            color: Colors.orange,
                            tail: true,
                          ),
                        ),
                        CircleAvatar(
                            child: Text(wholeMessages[i].senderName[0]),
                            backgroundColor: Colors.black26),
                      ],
                    );
                  }
                },
              ),
            ),
            Divider(height: 2.0),
            textInput
          ],
        ),
      ),
    );
  }
}
