import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group_chat/Pages/login.dart';
import 'package:group_chat/Pages/user_chat.dart';
import 'package:group_chat/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    userInfo();
    checkLoginStatus();
    fetchUsers(context);
    super.initState();
  }

  void userInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  var userData;
  var users;
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: users == null
            ? Text('')
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    title: userData['id'] == users[index]['id']
                        ? Text("You")
                        : Text(users[index]['username']),
                    subtitle: Text(users[index]['email']),
                    trailing: userData['id'] == users[index]['id']
                    ?
                    IconButton(
                      icon: Icon(Icons.block),
                      onPressed: () {
                        // Handle message button press
                        // ...
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => UserChatScreen(toid: users[index]['id'], toname: users[index]['username'],)),
                        // );
                      },
                    )
                    :
                    IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        // Handle message button press
                        // ...
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserChatScreen(toid: users[index]['id'], toname: users[index]['username'],)),
                        );
                      },
                    ),
                    onTap: () {},
                  );
                }));
  }

  fetchUsers(context) async {
    // print(userData);
    var res = await CallApi().authenticatedGetRequest('auth/all-user');
    if (res != null) {
      var allUser = json.decode(res.body);
      if (res.statusCode == 200) {
        print(allUser);
        setState(() {
          users = allUser;
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
