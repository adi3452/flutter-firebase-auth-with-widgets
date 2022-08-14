class Opentdb {
  final String correctAnswer;
  final String category;
  //final String difficulty;
  final String question;

  Opentdb(
      {required this.question,
      //required this.difficulty,
      required this.category,
      required this.correctAnswer});

  factory Opentdb.fromJson(Map<String, dynamic> json) {
    return Opentdb(
      category: json["category"].toString(),
      question: json["question"].toString(),
      //difficulty: json["difficulty"].toString(),
      correctAnswer: json["correct_answer"].toString(),
    );
  }
}
