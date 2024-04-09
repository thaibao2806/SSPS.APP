import 'package:flutter/material.dart';

class MessengerPage extends StatefulWidget {
  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final List<Map<String, String>> _messages = [
    {'sender': 'me', 'text': 'Hello there!'},
    {'sender': 'other', 'text': 'Hi! How are you?'},
    {'sender': 'me', 'text': 'I\'m good, thanks!'},
    {'sender': 'other', 'text': 'Great!'}
  ]; // Danh sách các tin nhắn

  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3498DB),
        title: Row(
          children: [
            Stack(
              children: [
                 CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/ai.jpg'),
                  radius: 20,
                ),
                Positioned(
                  bottom: 0,
                  right: 1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant AI',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Active now',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByMe = message['sender'] == 'me';
                return Align(
                  alignment:
                      isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isSentByMe ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(223, 241, 240, 234),
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(
                //   color: Colors.black, width: 1, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignCenter
                // )
              ),

              child: Padding(
                padding: EdgeInsets.only(
                  top: 8, bottom: 8, left: 15, right: 15
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    setState(() {
      final text = _textController.text;
      if (text.isNotEmpty) {
        _messages.add({'sender': 'me', 'text': text});
        _textController.clear();
      }
    });
  }
}
