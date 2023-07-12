import 'package:flutter/material.dart';
import 'package:group_chat/Constants/colors.dart';
import 'package:group_chat/Pages/menu.dart';
import 'package:group_chat/Pages/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                        'LOGIN MMCL',
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
                        validator: validateUsername,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainMenuScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        child: Center(
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
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not Registered! ",
                      // style: regular16pt.copyWith(color: textGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        // contactAdminDialog(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                      },
                      child: Text(
                        'Click here',
                        // style: regular16pt.copyWith(color: primaryBlue),
                      ),
                    ),
                  ],
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