class EventPrize {
  final int id;
  String prizeTitle;
  bool isTopPrize;
  int quantity;

  EventPrize({
    required this.id,
    required this.prizeTitle,
    required this.isTopPrize,
    this.quantity = 0,
  });

  // Factory constructor for creating an EventPrize object from a JSON object
  factory EventPrize.fromMap(Map<String, dynamic> map) {
    return EventPrize(
      id: map['id'],
      prizeTitle: map['prizeTitle'],
      isTopPrize: map['isTopPrize'],
      quantity: map['quantity'],
    );
  }

  // Convert an EventPrize object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prizeTitle': prizeTitle,
      'isTopPrize': isTopPrize,
      'quantity': quantity,
    };
  }
}
