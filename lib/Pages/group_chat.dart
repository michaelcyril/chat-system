import 'package:flutter/material.dart';
import 'package:group_chat/Widgets/message_card.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController messageController = TextEditingController();

  final List<String> items = ['s', 's', 'r', 'r', 's', 'r', 'r', 's'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/teamwork.png'),
                radius: 20,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Database Group',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () {
                // Handle call button press
                // ...
              },
            ),
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: () {
                // Handle video call button press
                // ...
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Handle more options button press
                // ...
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return items[index] == 's'
                        ? const Row(
                            children: [
                              Expanded(flex: 1, child: Text('')),
                              Expanded(
                                flex: 3,
                                child: MessageCard(
                                  sender: 'John Doe',
                                  message: 'Hello, how are you?',
                                  timestamp: '10:30 AM',
                                  bgColors: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: MessageCard(
                                  sender: 'John Doe',
                                  message: 'Hello, how are you?',
                                  timestamp: '10:30 AM',
                                  bgColors: Colors.white,
                                ),
                              ),
                              Expanded(flex: 1, child: Text('')),
                            ],
                          );
                  }),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {
                      // Handle attachment button press
                      // ...
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      // Handle camera button press
                      // ...
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // Handle send button press
                      // ...
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
