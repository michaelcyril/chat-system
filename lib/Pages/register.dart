import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_chat/Constants/colors.dart';
import 'package:group_chat/Pages/login.dart';
import 'package:group_chat/api/api.dart';
import 'package:group_chat/helper/firebase_helper.dart';
import 'package:group_chat/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:group_chat/Pages/menu.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? validateMyEmail(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Email Field must not be empty';
    } else {
      if (validateEmail(value)) {
        return null;
      } else {
        return 'Email Field must be valid';
      }
    }
  }

  String? validateMyUsername(String? value) {
// Indian Mobile number are of 10 digit only
    print('here');
    if (value!.isEmpty) {
      return 'Username Field must not be empty';
    }
  }

  bool validateUsername(String username) {
    // Minimum and maximum length requirements
    if (username.length < 4 || username.length > 16) {
      return false;
    }

    // Regular expression pattern for allowed characters (letters, numbers, underscore)
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      return false;
    }

    // Additional custom criteria, if any
    // ...

    return true;
  }

  bool validateEmail(String email) {
    String pattern =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  String? validatePassword(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Password Field must not be empty';
    } else if (value.length < 8)
      return 'Password must be of 8 or more digit';
    else
      return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO SAVE DATA
      _register();
    }
  }

  // void login() {
  //   var data = {
  //     'email': userEmailController.text,
  //     'password': userPasswordController.text,
  //     'username': userNameController.text
  //   };

  //   print(data);
  //   var authentication = new AuthenticationHelper();
  //   authentication.signUp(
  //       email: data['email']!,
  //       name: data['username']!,
  //       password: data['password']!);
  //   Navigator.pop(context);
  // }

  void _register() async {
    var data = {
      'username': userNameController.text,
      'email': userEmailController.text,
      'password': userPasswordController.text,
    };
    print(data);
    print('object');

    var res = await CallApi().authenticatedPostRequest(data, 'auth/register');
    if (res == null) {
      // ignore: use_build_context_synchronously
      showSnack(context, 'Network Error!');
    } else {
      var body = json.decode(res!.body);
      if (res.statusCode == 200) {
        if (body['sms'] == 'success') {
          // Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          showSnack(context, 'Successful registration!');
        }
        Navigator.pop(context);
        showSnack(context, 'Successful registration!');
      } else if (res.statusCode == 400) {
        // ignore: use_build_context_synchronously
        showSnack(context, 'Network Error!');
      } else {}
    }
  }

  contactAdminDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Request.'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Here you need to contact admin in order to be registered.'),
              SizedBox(height: 8),
              Text('Phone: +255774350001'),
              SizedBox(height: 8),
              // Text('Contents: ${order.contents.join(', ')}'),
              // SizedBox(height: 8),
              Text('Email: info@mmcl.co.tz'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     backgroundColor: Colors.blue,
                //     content: Text('The payment will be done in cash.'),
                //     duration: Duration(seconds: 3), // Optional duration
                //   ),
                // );
                Navigator.pop(context);
                // redirectToEmailApp();
              },
              child: Text('Contact Admin'),
            ),
          ],
        );
      },
    );
  }

  // void redirectToEmailApp() async {
  //   String email = Uri.encodeComponent("info@mmcl.co.tz");
  //   String subject = Uri.encodeComponent("Request for registration");
  //   String body = Uri.encodeComponent(
  //       "Hi! I'm the client who request for the registration. \n Contact me when you get this email.");
  //   print(subject); //output: Hello%20Flutter
  //   Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
  //   if (await launchUrl(mail)) {
  //     //email app opened
  //   } else {
  //     //email app is not opened
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/socialmedia.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'REGISTER CHAT APP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userEmailController,
                        validator: validateMyEmail,
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
                          hintText: 'Email',
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
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: userNameController,
                        validator: validateMyUsername,
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
                          hintText: 'Username',
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
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: userPasswordController,
                        obscureText: true,
                        validator: validatePassword,
                        // keyboardType: TextInputType.phone,
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
                          hintText: 'Password',
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // CustomCheckbox(),
                    SizedBox(
                      width: 12,
                    ),
                    // Text('Remember me', style: regular16pt),
                  ],
                ),
                // SizedBox(
                //   height: 32,
                // ),
                Material(
                  borderRadius: BorderRadius.circular(14.0),
                  elevation: 0,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.appColor,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => MainMenuScreen()),
                          // );
                          print('object');
                          _submit();
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        child: Center(
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
