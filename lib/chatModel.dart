import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import './user.dart';
import './message.dart';

class ChatModel extends Model {
  List<User> users = [
    User('Ruslan', '123'),
    User('Tevin', '456'),
    User('Hazel', '789'),
  ];

  User currentUser;
  List<User> friendList = List<User>();
  List<Message> messages = List<Message>();
  SocketIO socketIO;

  void init() {
    currentUser = users[0];
    friendList = users.where((user) => user.chatId != currentUser.chatId).toList();

    socketIO = SocketIOManager().createSocketIO(
      'https://rus-chat-app.herokuapp.com/', '/',
      query: 'chatId=${currentUser.chatId}'
    );
    socketIO.init();

    socketIO.subscribe('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      messages.add(Message(
        data['content'], data['senderChatId'], data['receiverChatId']
      ));
      notifyListeners();
    });
    socketIO.connect();
  }

  void sendMessage(String text, String receiverChatId) {
    messages.add(Message(text, currentUser.chatId, receiverChatId));
    socketIO.sendMessage('send_message', json.encode({
      'receiverChatId': receiverChatId,
      'senderChatId': currentUser.chatId,
      'content': text,
    }));
    notifyListeners();
  }
  List<Message> getMessagesForChatId(String chatId) {
    return messages
        .where((msg) => msg.senderId == chatId || msg.receiverId == chatId)
        .toList();
  }
}