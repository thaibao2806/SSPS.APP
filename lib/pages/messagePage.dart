import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/components/note/bottom_sheet_dialog_add_note.dart';
import 'package:ssps_app/components/todolist/Dialog_add_card.dart';
import 'package:ssps_app/components/todolist/Dialog_add_card_chat.dart';
import 'package:ssps_app/components/todolist/Dialog_add_todonote.dart';
import 'package:ssps_app/models/chatbox/chatbot_request_model.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ssps_app/components/moneyPlan/dialog_create_moneyPlan.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:convert';

import 'package:ssps_app/service/shared_service.dart';

class MessengerPage extends StatefulWidget {
  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  final List<Map<String, String>> _messages = [
    {'sender': 'me', 'text': 'Hello there!'},
    {
      'sender': 'other',
      'text':
          'Hi! Can I help you?\n You can also create quick: \n - Money plan: @moneyplan\n - Note: @note \n - Todolist: @todolist \n - Add task in todolist: @task'
    },
  ]; // Danh sách các tin nhắn

  TextEditingController _textController = TextEditingController();

  FocusNode myFocusNode = FocusNode();
  final player = AudioPlayer();

  SharedPreferences? _prefs;
  late DateTime _lastChatTime;
  static const String _lastChatTimeKey = 'last_chat_time';
  static const String _messagesKey = 'messages';
  Timer? _timer;
  bool isSoundOn = true;
  String? firstName;
  String? lastName;
  String? userID;
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();

  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    // _deletePrefs();
    _initPrefs();
    _timer = Timer(Duration(days: 1), () {
      _deletePrefs();
    });
    _decodeToken();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        print("aaa");
        Future.delayed(const Duration(milliseconds: 300), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () => scrollDown());
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final lastChatTimeMillis = _prefs!.getInt(_lastChatTimeKey) ?? 0;
    _lastChatTime = DateTime.fromMillisecondsSinceEpoch(lastChatTimeMillis);
    _loadMessages();
    _loadSoundSettings();
    // _checkAndClearMessages();
    scrollDown();
  }

  _decodeToken() async {
    var token = await SharedService.loginDetails();
    String? accessToken = token?.data?.accessToken;
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      firstName = decodedToken['firstName'];
      lastName = decodedToken['lastName'];
      userID = decodedToken['id'];
      print(decodedToken['id']);
    } else {
      print("Access token is null");
    }
  }

  void _checkAndClearMessages() {
    final now = DateTime.now();
    if (now.difference(_lastChatTime).inHours >= 24) {
      _messages.clear();
      _prefs!.remove(_messagesKey);
      _lastChatTime = now;
      _prefs!.setInt(_lastChatTimeKey, now.millisecondsSinceEpoch);
    }
  }

  Future<void> _deletePrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _messages.clear();
    setState(() {}); // Clear all SharedPreferences data
  }

  Future<void> _loadMessages() async {
    final messagesJson = _prefs!.getStringList(_messagesKey);
    if (messagesJson != null) {
      setState(() {
        _messages.clear();
        _messages.addAll(messagesJson
            .map((json) => Map<String, String>.from(jsonDecode(json))));
        scrollDown();
      });
    }
  }

  Future<void> _saveSoundSettings() async {
    await _prefs!.setBool('isSoundOn', isSoundOn);
  }

  void _loadSoundSettings() {
    setState(() {
      isSoundOn = _prefs!.getBool('isSoundOn') ?? true;
    });
  }

  Future<void> _saveMessages() async {
    final messagesJson =
        _messages.map((message) => jsonEncode(message)).toList();
    await _prefs!.setStringList(_messagesKey, messagesJson);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _textController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 1000,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  void _playSound() async {
    String audioPath = "audio/tingting.mp3";
    await player.play(AssetSource(audioPath));
  }

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
                  backgroundImage: AssetImage('assets/images/ai.jpg'),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
              onSelected: (value) async {
                if (value == 'Delete') {
                  final isConfirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text(
                            'Are you sure you wish to delete this message?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('DELETE'),
                          ),
                        ],
                      );
                    },
                  );

                  if (isConfirmDelete == true) {
                    _deletePrefs();
                  }
                } else if (value == 'Sound') {
                  setState(() {
                    isSoundOn = !isSoundOn;
                    _saveSoundSettings();
                  });
                  print('Sound button pressed, Sound is $isSoundOn');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Clear conversation',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Sound',
                  child: Row(
                    children: [
                      Icon(
                          isSoundOn ? Icons.volume_off : Icons.volume_down_alt),
                      SizedBox(
                        width: 10,
                      ),
                      Text(isSoundOn ? 'Turn Off Sound' : 'Turn On Sound',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByMe = message['sender'] == 'me';
                final isImage = message.containsKey('imageUrl');
                final isJson = message.containsKey('json');
                return Align(
                  alignment:
                      isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isSentByMe
                          ? Colors.blue
                          : Color.fromARGB(199, 154, 154, 154),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: isImage
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                    imageUrl: message['imageUrl']!,
                                  ),
                                ),
                              );
                            },
                            child: Image.network(message['imageUrl']!),
                          )
                        : isJson
                            ? JsonTable(jsonString: message['json']!)
                            : Text(
                                message['text'] ?? '',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: myFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                        maxLines:
                            null, // Allows the text field to expand infinitely
                        minLines:
                            1, // Optional: sets the initial number of lines
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        onTap: () {
                          scrollDown();
                        },
                      ),
                    ),
                    SizedBox(width: 15.0),
                    GestureDetector(
                      onTap: () async {
                        if (_textController.text.isEmpty) {
                          return;
                        }
                        await _sendMessage();
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

  Future<void> _sendMessage() async {
    setState(() {
      final text = _textController.text;
      if (text.trim().toLowerCase() == "@moneyplan") {
        _messages.add({'sender': 'me', 'text': text});
        _saveMessages();
        scrollDown();
        _messages.add({'sender': 'other', 'text': "Create moneyplan"});
        _saveMessages();
        scrollDown();
        setState(() {});
        showModalBottomSheet(
          // isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return CreateMoneyPlan(getNote: () async {
              print("check");
            });
          },
        );
        _textController.clear();
        return;
      }
      if (text.trim().toLowerCase() == "@note") {
        _messages.add({'sender': 'me', 'text': text});
        _saveMessages();
        scrollDown();
        _messages.add({'sender': 'other', 'text': "Create note"});
        _saveMessages();
        scrollDown();
        setState(() {});
        showModalBottomSheet(
          // isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            final startTime = DateTime.now();
            final endTime = DateTime.now();
            return DraggableSheet(
                getNote: () {
                  print("check note");
                },
                startTime: startTime,
                endTime: endTime);
          },
        );
        _textController.clear();
        return;
      }
      if (text.trim().toLowerCase() == "@todolist") {
        _messages.add({'sender': 'me', 'text': text});
        _saveMessages();
        scrollDown();
        _messages.add({'sender': 'other', 'text': "Create column todolist"});
        _saveMessages();
        scrollDown();
        setState(() {});
        showDialog(
            context: context,
            builder: (context) {
              return CustomDialog(
                onDeleteSuccess: () {
                  // refreshTodoList();
                  print("check todolist");
                },
              );
            });
        _textController.clear();
        return;
      }
      if (text.trim().toLowerCase() == "@task") {
        _messages.add({'sender': 'me', 'text': text});
        _saveMessages();
        scrollDown();
        _messages.add({'sender': 'other', 'text': "Create task in todolist"});
        _saveMessages();
        scrollDown();
        setState(() {});
        showDialog(
            context: context,
            builder: (context) {
              return AddCardChatDialog(
                // toDoNoteId: todo.id,
                onDeleteSuccess: () {
                  print("check card");
                },
              );
            });
        _textController.clear();
        return;
      }
      if (text.isNotEmpty) {
        _messages.add({'sender': 'me', 'text': text});
        _saveMessages();
        scrollDown();
        setState(() {});
        _textController.clear();
      }
      _messages.add({'sender': 'other', 'text': 'Typing...'});
      scrollDown();
      try {
        if (userID == null) {
          throw Exception("User ID is null");
        }
        ChatbotRequestModel model =
            ChatbotRequestModel(message: text, userId: userID!, isAdmin: false);
        ApiService.chatBot(model).then((value) {
          _messages.removeLast();
          print(value.data!.type);
          if (value.result) {
            if (value.data!.response!.contains(
                    "Unfortunately, I was not able to answer your question") &&
                value.data!.response!.contains("Column not found")) {
              isSoundOn ? _playSound() : null;
              _messages.add({'sender': 'other', 'text': "No data"});
              _saveMessages();
              scrollDown();
            } else if (value.data!.response!.contains(
                "Unfortunately, I was not able to answer your question")) {
              isSoundOn ? _playSound() : null;
              _messages.add({
                'sender': 'other',
                'text': "Sorry, I can't answer this question right now"
              });
              _saveMessages();
              scrollDown();
            }
            if (value.data?.type == "image") {
              isSoundOn ? _playSound() : null;
              _messages
                  .add({'sender': 'other', 'imageUrl': value.data!.response!});
              _saveMessages();
              scrollDown();
            } else if (value.data?.type == "json") {
              isSoundOn ? _playSound() : null;
              _messages.add({'sender': 'other', 'json': value.data!.response!});
              _saveMessages();
              scrollDown();
            } else {
              isSoundOn ? _playSound() : null;
              _messages.add({'sender': 'other', 'text': value.data!.response!});
              _saveMessages();
              scrollDown();
            }
            setState(() {});
          } else {
            isSoundOn ? _playSound() : null;
            _messages.add({'sender': 'other', 'text': value.data!.response!});
            _saveMessages();
            scrollDown();
            setState(() {});
          }
        });
      } catch (e) {
        print('Error in _sendMessage: $e');
        _messages
            .add({'sender': 'other', 'text': "Sorry, something went wrong!"});
        if (e.toString().contains('Internal Server Error')) {
          print('Error 500: Internal Server Error');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sorry, something went wrong!')),
        );
      }
    });
  }
}

class JsonTable extends StatelessWidget {
  final String jsonString;

  JsonTable({required this.jsonString});

  @override
  Widget build(BuildContext context) {
    dynamic jsonData = jsonDecode(jsonString);

    if (jsonData is Map<String, dynamic>) {
      // Handle JSON object
      return _buildTableFromMap(jsonData);
    } else if (jsonData is List) {
      // Handle JSON array
      return _buildTableFromList(jsonData);
    } else {
      return Center(child: Text('Invalid JSON data'));
    }
  }

  Widget _buildTableFromMap(Map<String, dynamic> jsonData) {
    List<TableRow> rows = [];
    jsonData.forEach((key, value) {
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Text(key,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Text(value.toString(),
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(150.0), // Chiều rộng cột thứ nhất
          1: FixedColumnWidth(200.0), // Chiều rộng cột thứ hai
        },
        children: rows,
      ),
    );
  }

  Widget _buildTableFromList(List<dynamic> jsonData) {
    if (jsonData.isEmpty) {
      return Center(child: Text('No data available'));
    }

    List<TableRow> rows = [];
    // Adding headers
    rows.add(
      TableRow(
        children: jsonData[0].keys.map<Widget>((key) {
          return TableCell(
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Text(key,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          );
        }).toList(),
      ),
    );

    // Adding rows
    for (var item in jsonData) {
      rows.add(
        TableRow(
          children: item.values.map<Widget>((value) {
            return TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Text(value.toString(),
                    style: TextStyle(color: Colors.white)),
              ),
            );
          }).toList(),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: {
          for (int i = 0; i < jsonData[0].keys.length; i++)
            i: FixedColumnWidth(150.0), // Set chiều rộng cho tất cả các cột
        },
        children: rows,
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  final String imageUrl;

  const ImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
