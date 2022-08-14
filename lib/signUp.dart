import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_application/homePage.dart';
import 'package:first_flutter_application/signIn.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Register Here',
                      style: TextStyle(
                          color: Color.fromARGB(255, 86, 86, 87),
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: confpasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                Container(
                    height: 90,
                    width: 150,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: ElevatedButton(
                      child: const Text('Register'),
                      onPressed: () {
                        // print(emailController.text);
                        // print(passwordController.text);
                        // _displayDialog(
                        //     context, "Success", "Suceessflully regited");
                        signUp(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            confpasswordController.text.trim(),
                            context);
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an account?'),
                    TextButton(
                      child: const Text(
                        'Login here',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signin screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInWidget()),
                        );
                      },
                    )
                  ],
                ),
              ],
            )));
  }
}

Future signUp(email, password, confirmPassword, context) async {
  if (password != confirmPassword) {
    _displayDialog(
        context, "Error", "Password and Conform Password Do not Match");
    return;
  } else if (email == '' || password == '' || confirmPassword == '') {
    _displayDialog(context, "Error", "Inputs Cannot be empty");
    return;
  } else {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                _displayDialog(context, "Success", "UserCreated Successfully"),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                )
              })
          .catchError((error, stackTrace) {
        _displayDialog(context, "Error", "Error Creating the User");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _displayDialog(context, "Error", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _displayDialog(
            context, "Error", "The account already exists for that email.");
      } else {
        _displayDialog(context, "Error", e.message.toString());
      }
    }
  }
}

_displayDialog(BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Expanded(
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Dismiss',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      );
    },
  );
}
