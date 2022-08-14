import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'models/coin.dart';
import 'util/carddesigncoin.dart';

class BitcoinWidget extends StatefulWidget {
  const BitcoinWidget({Key? key}) : super(key: key);

  @override
  State<BitcoinWidget> createState() => _BitcoinWidgetState();
}

class _BitcoinWidgetState extends State<BitcoinWidget> {
  Future<List<Coinclass>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coinclass.fromJson(map));
          }
        }
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  @override
  void initState() {
    fetchCoin();
    Timer.periodic(Duration(seconds: 10), (timer) => fetchCoin());
    super.initState();
  }

  Widget getTextWidgets() {
    List<Widget> childrenList = [];

    for (var item in coinList) {
      var card = carddesignCoin(
        name: item.name,
        price: item.price.toDouble(),
        changePercentage: item.changePercentage.toDouble(),
      );
      childrenList.add(card);
    }
    Widget coinColumn = Column(children: childrenList);
    return coinColumn;
  }

  @override
  Widget build(BuildContext context) {
    const textCol = Color.fromARGB(255, 68, 66, 67);
    const textHeadCol = Color.fromARGB(255, 73, 42, 73);
    const borderCol = Color.fromARGB(255, 52, 54, 54);
    return Container(
        decoration: BoxDecoration(border: Border.all(color: borderCol)),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              margin: const EdgeInsets.all(10.0),
              child: const Text(
                "Crypto Currency Price Today",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: textHeadCol,
                    decoration: TextDecoration.underline),
              )),
          getTextWidgets()
        ]));
  }
}
