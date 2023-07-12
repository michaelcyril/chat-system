import 'package:flutter/material.dart';
import 'package:group_chat/Pages/login.dart';
// import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  void _navigateToMainScreen() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Customize your splash screen layout here
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 100,
          backgroundImage: AssetImage('assets/images/socialmedia.png'),
        ),
      ),
    );
  }
}