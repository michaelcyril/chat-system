import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_chat/api/api.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  @override
  void initState() {
    fetchUsers(context);
    super.initState();
  }

  var files;
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // body: files == null
    //     ? Text('')
    //     : ListView.builder(
    //             itemCount: files.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               print(files);
    //               return ListTile(
    //                 leading: Icon(Icons.file_present),
    //                 title: Text('Name: ${files[index]['name'].split('/')[1]}'),
    //                 subtitle: Text('${files[index]['storage']}'),
    //                 // trailing: IconButton(
    //                 //   icon: Icon(Icons.message),
    //                 //   onPressed: () {
    //                 //     // Handle message button press
    //                 //     // ...
    //                 //   // Navigator.push(
    //                 //   //   context,
    //                 //   //   MaterialPageRoute(builder: (context) => UserChatScreen()),
    //                 //   // );
    //                 //   },
    //                 // ),
    //                 onTap: () {},
    //               );
    //             }));
    return files == null
        ? const Text('')
        : GridView.builder(
            itemCount: files.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Adjust the number of columns as needed
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                // ignore: prefer_interpolation_to_compose_strings
                child: Image.network('http://161.35.210.153:5000/media/' +
                    files[index]['name']),
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => SingleImagePage(
                //             id: _ids[index], imageUrl: _images[index])),
                //   );
                // },
              );
            },
          );
  }

  fetchUsers(context) async {
    // print(userData);
    var res = await CallApi().authenticatedGetRequest('chat/all-files');
    if (res != null) {
      var allUser = json.decode(res.body);
      if (res.statusCode == 200) {
        print(allUser);
        setState(() {
          files = allUser;
        });
      } else {
        setState(() {
          // users = [];
        });
      }
      return [];
    } else {
      return [];
    }
  }
}
