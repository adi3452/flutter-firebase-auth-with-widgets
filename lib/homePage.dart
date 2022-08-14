import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_application/btcvaluation.dart';
import 'package:first_flutter_application/currentWeather.dart';
import 'package:first_flutter_application/signIn.dart';
import 'package:first_flutter_application/opentdbWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 226, 226, 233),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(5, 40, 5, 20),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Welcome to My First Flutter app \n ${user.email.toString()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color.fromARGB(255, 73, 71, 71)),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) => {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInWidget()),
                                )
                              });
                        },
                        child: const Text('Click here to Logout'))),
                const SizedBox(
                  height: 16.0,
                ),
                const Center(child: TriviaWidget()),
                const SizedBox(
                  height: 16.0,
                ),
                const Center(child: CurrentWeatherPage()),
                const SizedBox(
                  height: 16.0,
                ),
                const BitcoinWidget()
              ],
            )));
  }
}
