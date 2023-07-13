import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/Pages/login.dart';
import 'package:group_chat/Widgets/message_card.dart';
import 'package:group_chat/api/api.dart';
import 'package:group_chat/utils/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class UserChatScreen extends StatefulWidget {
  final toid;
  final toname;
  const UserChatScreen({super.key, required this.toid, required this.toname});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final List<String> items = ['s', 's', 'r', 'r', 's', 'r', 'r', 's'];
  @override
  void initState() {
    userInfo();
    checkLoginStatus();
    super.initState();
  }

  void userInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
    fetchUsersChats(context);
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // Access the picked file's properties
      String fileName = file.name;
      String filePath = file.path!;
      int fileSize = file.size;
      String mimeType = file.extension!;
      setState(() {
        selectedFile = file;
      });

      // Perform actions with the picked file
      // e.g., upload it to a server, process it, etc.
    } else {
      // User canceled the file picking operation
    }
  }

  var selectedFile;

  var userData;
  var chats;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
                radius: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.toname,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                // Handle call button press
                // ...
              },
            ),
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                // Handle video call button press
                // ...
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
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
              child: chats == null
                  ? const Text('')
                  : ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(index);
                        print(chats[index]['message']);
                        // print(userData);
                        return chats[index]['from_user_id'] == userData['id']
                            ? Row(
                                children: [
                                  Expanded(flex: 1, child: Text('')),
                                  Expanded(
                                    flex: 3,
                                    child: chats[index].containsKey('file')
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Set the border radius
                                                color: Colors
                                                    .blue, // Set the background color
                                              ),
                                              child: ListTile(
                                                  onTap: () {
                                                    // Handle the press event here
                                                    paymentDialog(
                                                        context,
                                                        chats[index]
                                                            ['from_user'],
                                                        chats[index]['file']
                                                            .split('/')[1]);
                                                  },
                                                  // Set the background color
                                                  title: Text(chats[index]
                                                      ['from_user']),
                                                  subtitle: Image.network(
                                                      'http://46.101.244.29:8000/media/' +
                                                          chats[index]['file']),
                                                  // leading:
                                                  //     Icon(Icons.file_present),
                                                  trailing: Text(
                                                    formatTimestamp(chats[index]
                                                        ['created_at']),
                                                  )),
                                            ),
                                          )
                                        : MessageCard(
                                            sender: chats[index]['from_user'],
                                            message: chats[index]['message'],
                                            timestamp: formatTimestamp(
                                                chats[index]['created_at']),
                                            bgColors: Colors.white,
                                          ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: chats[index].containsKey('file')
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Set the border radius
                                                color: Colors
                                                    .blue, // Set the background color
                                              ),
                                              child: ListTile(
                                                  onTap: () {
                                                    // Handle the press event here
                                                    paymentDialog(
                                                        context,
                                                        chats[index]
                                                            ['from_user'],
                                                        chats[index]['file']
                                                            .split('/')[1]);
                                                  },
                                                  // Set the background color
                                                  title: Text(chats[index]
                                                      ['from_user']),
                                                  // subtitle: Text(chats[index]
                                                  //         ['file']
                                                  //     .split('/')[1]),
                                                  subtitle: Image.network(
                                                      'http://46.101.244.29:8000/media/' +
                                                          chats[index]['file']),
                                                  // leading:
                                                  //     Icon(Icons.file_present),
                                                  trailing: Text(
                                                    formatTimestamp(chats[index]
                                                        ['created_at']),
                                                  )),
                                            ),
                                          )
                                        : MessageCard(
                                            sender: chats[index]['from_user'],
                                            message: chats[index]['message'],
                                            timestamp: formatTimestamp(
                                                chats[index]['created_at']),
                                            bgColors: Colors.white,
                                          ),
                                  ),
                                  Expanded(flex: 1, child: Text('')),
                                ],
                              );
                      }),
            ),
            Column(
              children: [
                selectedFile != null
                    ? ListTile(
                        // hoverColor: Colors.brown,
                        // leading: const CircleAvatar(
                        //   backgroundImage: AssetImage('assets/images/teamwork.png'),
                        // ),
                        title: const Text("File type: pdf"),
                        subtitle: Text("File name: ${selectedFile.name}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.file_present),
                          onPressed: () {
                            // Handle message button press
                            // ...
                          },
                        ),
                        onTap: () {},
                      )
                    : Container(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 3,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Type a message',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {
                            // Handle attachment button press
                            // ...
                            pickFile();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            // Handle camera button press
                            // ...
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            // Handle send button press
                            // ...
                            sendMessage();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  fetchUsersChats(context) async {
    print('============================');

    // print(userData);
    var res = await CallApi().authenticatedGetRequest('chat/usermessages/' +
        userData['id'].toString() +
        "/${widget.toid.toString()}");
    print(res);
    if (res != null) {
      var userChat = json.decode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          chats = userChat;
        });
      } else {}
      return [];
    } else {
      return [];
    }
  }

  void normalMessage() async {
    var data = {
      'from_user': userData['id'],
      'to': widget.toid,
      'message': messageController.text,
    };

    var res =
        await CallApi().authenticatedPostRequest(data, 'chat/createmessage');
    if (res == null) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Network Error!');
    } else {
      var body = json.decode(res!.body);
      if (res.statusCode == 200) {
        if (body['message'] == 'message sent') {
          showSnack(context, 'Message sent!');
          messageController.clear();
        } else {
          // Navigator.pop(context);
          showSnack(context, 'Message Failed!');
        }
      } else if (res.statusCode == 400) {
        // ignore: use_build_context_synchronously
        showSnack(context, 'Network Error!');
      } else {}
    }
  }

  void sendMessage() async {
    if (selectedFile == null) {
      // return;
      normalMessage();
    }

    try {
      String apiUrl = 'chat/createmessage'; // Replace with your API endpoint
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(selectedFile!.path),
        'from_user': userData['id'],
        'to': widget.toid,
      });

      var res = await CallApi().authenticatedUploadRequest(formData, apiUrl,
          context: context, uploaded: null, state: this);
      if (res == null) {
        // ignore: use_build_context_synchronously
        // showSnack(context, 'Network Error!');
        setState(() {
          selectedFile = null;
        });
      } else {
        var body = json.decode(res!.body);
        if (res.statusCode == 200) {
          if (body['message'] == 'message sent') {
            setState(() {
              selectedFile = null;
            });
            // showSnack(context, 'Message sent!');
            messageController.clear();
          } else {
            // Navigator.pop(context);
            // showSnack(context, 'Message Failed!');
          }
        } else if (res.statusCode == 400) {
          // ignore: use_build_context_synchronously
          // showSnack(context, 'Network Error!');
        } else {}
      }
    } catch (e) {
      // Handle error
      print('Image upload error: $e');
      // showSnack(context, 'Network Error!');
    }
  }

  paymentDialog(BuildContext context, String filename, String sendername) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Attempt'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Document name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(sendername),
              Text(
                'Sender name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(filename),
              Text('The payment cost 25,000/= is required to be paid.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();

    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      // Date is today
      return DateFormat('h:mm a').format(dateTime); // Format time as "10:00 AM"
    } else {
      return DateFormat('EEEE, h:mm a')
          .format(dateTime); // Format as "Monday, 10:10 AM"
    }
  }
}
