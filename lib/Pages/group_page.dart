import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:group_chat/Constants/colors.dart';
import 'package:group_chat/Pages/group_chat.dart';
import 'package:group_chat/Pages/login.dart';
import 'package:group_chat/api/api.dart';
import 'package:group_chat/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:group_chat/Widgets/cards_user.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  void changeState(bool value) {
    setState(() {});
  }

  @override
  void initState() {
    userInfo();
    checkLoginStatus();
    fetchGroups(context);
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
  var groups;

  _add_Group_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: AlertDialog(
              scrollable: true,
              title: const Text('Add Group'),
              content: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    // validator: validateUsername,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Group Name',
                      hintStyle: const TextStyle(
                        color: Colors.black12,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  // _contentServices(context),

                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    // validator: validateUsername,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Group Description',
                      hintStyle: const TextStyle(
                        color: Colors.black12,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  // _contentServices(context),

                  const SizedBox(
                    height: 30,
                  ),

                  MaterialButton(
                    elevation: 0,
                    color: const Color(0xFF44B6AF),
                    height: 50,
                    minWidth: 500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      // _add_client_API();
                      // Navigator.pop(context);
                      createGroup();
                      setState(() {
                        // fetchGroups(context);
                      });
                    },
                    child: Text(
                      'Create',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: groups == null
          ? const Text('')
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/teamwork.png'),
                  ),
                  title: Text(groups[index]['group_name']),
                  subtitle: Text(groups[index]['description']),
                  trailing: IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () {
                      // Handle message button press
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupChatScreen(
                                  groupid: groups[index]['id'],
                                  groupname: groups[index]['group_name'],
                                )),
                      );
                    },
                  ),
                  onTap: () {},
                );
              }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Action to perform when the FAB is pressed
          // print('FAB Pressed');
          // _add_Group_Dialog(context);
          add();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  fetchGroups(context) async {
    var res = await CallApi().authenticatedGetRequest('chat/all-groups');
    if (res != null) {
      var allUser = json.decode(res.body);
      if (res.statusCode == 200) {
        print(allUser);
        setState(() {
          groups = allUser;
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

  void createGroup() async {
    var data = {
      'user_id': userData['id'],
      'name': nameController.text,
      'description': descriptionController.text,
    };

    var res =
        await CallApi().authenticatedPostRequest(data, 'chat/creategroup');
    if (res == null) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Network Error!');
    } else {
      var body = json.decode(res!.body);
      if (res.statusCode == 200) {
        if (body['sms'] == 'success') {
          Navigator.pop(context);
          showSnack(context, 'Successful group!');
          nameController.clear();
          descriptionController.clear();
          changeState;
        } else {
          Navigator.pop(context);
          showSnack(context, 'Fail to create!');
        }
      } else if (res.statusCode == 400) {
        // ignore: use_build_context_synchronously
        showSnack(context, 'Network Error!');
      } else {}
    }
  }

  add() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Add Group",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: nameController,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                labelText: 'Group Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter group name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: descriptionController,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                labelText: 'Description'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter group description';
                              }
                              return null;
                            },
                          ),
                        ),
                        MaterialButton(
                          elevation: 0,
                          color: Colors.black,
                          height: 50,
                          minWidth: 500,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              createGroup();
                              // Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Create',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
