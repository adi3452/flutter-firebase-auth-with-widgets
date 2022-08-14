import 'package:flutter/material.dart';
import 'models/opentdb.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TriviaWidget extends StatefulWidget {
  const TriviaWidget({super.key});

  @override
  _TriviaWidgetState createState() => _TriviaWidgetState();
}

class _TriviaWidgetState extends State<TriviaWidget> {
  late Opentdb _opentbd;
  bool _visible = false;
  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot != null) {
          _opentbd = snapshot.data as Opentdb;
          if (_opentbd == null) {
            return Text("Error getting weather");
          } else {
            return triviaBox(_opentbd, _visible, _toggle);
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
      future: getTrivia(),
    );
  }
}

Widget triviaBox(Opentdb _opentbd, bool visible, VoidCallback toggle) {
  const textCol = Color.fromARGB(255, 17, 17, 17);
  const textHeadCol = Color.fromARGB(255, 20, 20, 20);
  const borderCol = Color.fromARGB(255, 29, 29, 29);

  return Container(
      decoration: BoxDecoration(border: Border.all(color: borderCol)),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
            margin: const EdgeInsets.all(10.0),
            child: const Text(
              "Opentbd Quick Quiz Questions",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: textHeadCol,
                  decoration: TextDecoration.underline),
            )),
        Container(
            margin: const EdgeInsets.all(5.0),
            child: Text(
              _opentbd.category,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: textCol),
            )),
        Center(
          child: Container(
              margin: const EdgeInsets.all(5.0),
              child: Text(
                String.fromCharCodes(Runes(_opentbd.question)),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontStyle: FontStyle.italic, color: textCol),
              )),
        ),
        Container(
            margin: const EdgeInsets.all(5.0),
            child: Text(
              "Answer: ${_opentbd.correctAnswer}",
              style: const TextStyle(color: textCol),
            )),
        ElevatedButton.icon(
          icon: const Icon(Icons.question_answer),
          label: const Text('Refresh'),
          onPressed: () {
            toggle();
          },
        ),
      ]));
}

Future getTrivia() async {
  late Opentdb weather; // change

  var url_alt =
      'https://opentdb.com/api.php?amount=10&difficulty=easy&type=multiple';
  final response = await http.get(url_alt);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    weather = Opentdb.fromJson(data["results"][0]);
  }

  return weather;
}
