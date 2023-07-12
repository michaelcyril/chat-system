import 'package:flutter/material.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.file_present),
                title: Text('Name: database_notes.pdf'),
                subtitle: Text('1020kb'),
                // trailing: IconButton(
                //   icon: Icon(Icons.message),
                //   onPressed: () {
                //     // Handle message button press
                //     // ...
                //   // Navigator.push(
                //   //   context,
                //   //   MaterialPageRoute(builder: (context) => UserChatScreen()),
                //   // );
                //   },
                // ),
                onTap: () {
                },
              );
            })
    );
  }
}