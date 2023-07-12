import 'package:flutter/material.dart';
// import 'package:group_chat/Constants/colors.dart';
import 'package:group_chat/Pages/user_chat.dart';
// import 'package:group_chat/Widgets/cards_user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/profile.png'),
                ),
                title: const Text('Contact Name'),
                subtitle: const Text('Status'),
                trailing: IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: () {
                    // Handle message button press
                    // ...
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserChatScreen()),
                  );
                  },
                ),
                onTap: () {
                },
              );
            }));
  }
}
