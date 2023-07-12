import 'package:flutter/material.dart';
import 'package:group_chat/Constants/colors.dart';
import 'package:group_chat/Pages/menu.dart';
import 'package:group_chat/Pages/register.dart';
import 'package:group_chat/api/api.dart';
import 'package:group_chat/helper/firebase_helper.dart';
import 'package:group_chat/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userId;
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? validateUsername(String? value) {
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
      _login();
    }
  }

  String? validateMyUsername(String? value) {
// Indian Mobile number are of 10 digit only
    // print('here');
    if (value!.isEmpty) {
      return 'Username Field must not be empty';
    }
  }

  void _login() async {
    var data = {
      'username': userEmailController.text,
      'password': userPasswordController.text,
    };
    print('object');

    var res = await CallApi().authenticatedPostRequest(data, 'auth/login');
    if (res == null) {
    } else {
      var body = json.decode(res!.body);

      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        if (body['sms'] == 'success') {
          setState(() {
            userId = body['user']['id'];
          });
          localStorage.setString("user", json.encode(body['user']));
          localStorage.setString("token", json.encode(body['token']));
          userEmailController.clear();
          userPasswordController.clear();
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainMenuScreen()));
        } else {
          // ignore: use_build_context_synchronously
          showSnack(context, 'Wrong User name or Password!');
        }
      } else if (res.statusCode == 400) {
        showSnack(context, 'Connection Error!');
      } else {}
    }

    // ignore: avoid_print
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
              child: const Text('Contact Admin'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'REGISTER CHAT APP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userEmailController,
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
                const SizedBox(
                  height: 32,
                ),
                const Row(
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
                          _submit();
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 24,
                // ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not Registered! ",
                      // style: regular16pt.copyWith(color: textGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        // contactAdminDialog(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Click here',
                        // style: regular16pt.copyWith(color: primaryBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
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
