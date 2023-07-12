import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_chat/Constants/colors.dart';
import 'package:group_chat/Pages/files_page.dart';
import 'package:group_chat/Pages/group_page.dart';
import 'package:group_chat/Pages/login.dart';
import 'package:group_chat/Pages/users_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    userInfo();
    checkLoginStatus();
    super.initState();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  int _selectedIndex = 0;
  String appbarname = "Users";
  var userData;

  void userInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  areYouSureYoWantToLogOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Attempt'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to logout.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();
                localStorage.clear();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  final List<Widget> _widgetOptions = [
    const UsersScreen(),
    const GroupsScreen(),
    const DocumentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    getAppBarName(index);
  }

  void _onItemTappedForAppBar(String name) {
    setState(() {
      appbarname = name;
    });
  }

  void getAppBarName(int index) {
    switch (index) {
      case 0:
        _onItemTappedForAppBar("Users");
        break;
      case 1:
        _onItemTappedForAppBar("Groups");
        break;
      case 2:
        _onItemTappedForAppBar("Files");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 0),
            const SizedBox(width: 0),
            // SizedBox(width: 32),
            Text(appbarname),
            const SizedBox(width: 0),
            const SizedBox(width: 0),
            Image.asset(
              'assets/images/socialmedia.png', // Replace with your own logo image path
              height: 32,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.appColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                height: 200,
                // color: Colors.blue,
                child: const Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                      Text('CHAT APP'),
                    ],
                  ),
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Home'),
            //   onTap: () {
            //     // Handle drawer item tap for home
            //   },
            // ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(
                userData['username'],
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigator.pop(context);
                // areYouSureYoWantToLogOut(context);
                // Handle drawer item tap for settings
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              title: Text(
                userData['email'],
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigator.pop(context);
                // areYouSureYoWantToLogOut(context);
                // Handle drawer item tap for settings
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_sharp,
                color: Colors.black,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                areYouSureYoWantToLogOut(context);
                // areYouSureYoWantToLogOut(context);
                // Handle drawer item tap for settings
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
        ],
      ),
    );
  }
}
