import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'user.dart';
import 'message.dart';
import 'chatModel.dart';

class ChatPage extends StatefulWidget {
  final User friend;
  ChatPage(this.friend);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();

  Widget buildSingleMessage(Message message) {
    return Container(
      alignment: message.senderId == widget.friend.chatId ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Text(message.text),
    );
  }

  Widget buildChatList() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        List<Message> messages = model.getMessagesForChatId(widget.friend.chatId);

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(messages[index]);
            },
          ),
        );
      },
    );
  }

  Widget buildChatArea() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        return Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: textEditingController,
                ),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () {
                  model.sendMessage(
                    textEditingController.text, widget.friend.chatId
                  );
                  textEditingController.text = '';
                },
                elevation: 0,
                child: Icon(Icons.send),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
      ),
      body: ListView(
        children: <Widget>[
          buildChatList(),
          buildChatArea()
        ],
      ),
    );
  }
}