import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/Pages/login.dart';
import 'package:group_chat/Widgets/message_card.dart';
import 'package:group_chat/api/api.dart';
import 'package:group_chat/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class GroupChatScreen extends StatefulWidget {
  final groupid;
  final groupname;
  const GroupChatScreen(
      {super.key, required this.groupid, required this.groupname});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController _messageController = TextEditingController();

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
      allowedExtensions: ['pdf', 'doc'],
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

  final List<String> items = ['s', 's', 'r', 'r', 's', 'r', 'r', 's'];

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
                backgroundImage: AssetImage('assets/images/teamwork.png'),
                radius: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.groupname,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Active',
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
                  ? Text('')
                  : ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                                      chats[index]['from_user'],
                                                      chats[index]['file']
                                                          .split('/')[1]);
                                                },
                                                // Set the background color
                                                title: Text(
                                                    chats[index]['from_user']),
                                                subtitle: Text(chats[index]
                                                        ['file']
                                                    .split('/')[1]),
                                                leading:
                                                    Icon(Icons.file_present),
                                                // trailing:
                                                //     Icon(Icons.arrow_forward),
                                              ),
                                            ),
                                          )
                                        : MessageCard(
                                            sender: chats[index]['from_user'],
                                            message: chats[index]['message'],
                                            timestamp: '10:30 AM',
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
                                                      chats[index]['from_user'],
                                                      chats[index]['file']
                                                          .split('/')[1]);
                                                },
                                                // Set the background color
                                                title: Text(
                                                    chats[index]['from_user']),
                                                subtitle: Text(chats[index]
                                                        ['file']
                                                    .split('/')[1]),
                                                leading:
                                                    Icon(Icons.file_present),
                                                // trailing:
                                                //     Icon(Icons.arrow_forward),
                                              ),
                                            ),
                                          )
                                        : MessageCard(
                                            sender: chats[index]['from_user'],
                                            message: chats[index]['message'],
                                            timestamp: '10:30 AM',
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
                ?
                ListTile(
                // hoverColor: Colors.brown,
                  // leading: const CircleAvatar(
                  //   backgroundImage: AssetImage('assets/images/teamwork.png'),
                  // ),
                  title: Text("File type: Pdf"),
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
                :
                Container(),
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
                  child: Row(
                    children: [
                       Expanded(
                        child: TextField(
                          controller: _messageController,
                          // validator: validateMyUsername,
                          keyboardType: TextInputType.emailAddress,
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
              ],
            ),
          ],
        ));
  }

  fetchUsersChats(context) async {
    var res = await CallApi().authenticatedGetRequest(
        'chat/groupmessages/' + widget.groupid.toString());
    print(res);
    if (res != null) {
      var userChat = json.decode(res.body);
      print(userChat);
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
      'group': widget.groupid,
      'message': _messageController.text,
    };
    print(data);

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
          _messageController.clear();
          setState(() {});
        } else {
          Navigator.pop(context);
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
        'group': widget.groupid,
      });

      var res = await CallApi().authenticatedUploadRequest(formData, apiUrl,
          context: context, uploaded: null, state: this);
      if (res == null) {
        // ignore: use_build_context_synchronously
        showSnack(context, 'Network Error!');
      } else {
        var body = json.decode(res!.body);
        if (res.statusCode == 200) {
          if (body['message'] == 'message sent') {
            setState(() {});
            showSnack(context, 'Message sent!');
            _messageController.clear();
          } else {
            // Navigator.pop(context);
            showSnack(context, 'Message Failed!');
          }
        } else if (res.statusCode == 400) {
          // ignore: use_build_context_synchronously
          showSnack(context, 'Network Error!');
        } else {}
      }
    } catch (e) {
      // Handle error
      print('Image upload error: $e');
      showSnack(context, 'Network Error!');
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
              Text('Document name:', style: TextStyle(fontWeight: FontWeight.bold),),
              Text( sendername),
              Text('Sender name:', style: TextStyle(fontWeight: FontWeight.bold),),
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
}
