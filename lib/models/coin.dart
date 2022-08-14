class Coinclass {
  final String name;
  final num price;
  final num changePercentage;

  Coinclass({
    required this.name,
    required this.price,
    required this.changePercentage,
  });

  factory Coinclass.fromJson(Map<String, dynamic> json) {
    return Coinclass(
      name: json['name'],
      price: json['current_price'],
      changePercentage: json['price_change_percentage_24h'],
    );
  }
}

List<Coinclass> coinList = [];
