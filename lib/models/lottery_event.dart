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

class LotteryEvent {
  final int id;
  final DateTime eventDate;
  final String eventTitle;
  final DateTime createdAt;
  final List<EventPrize> eventPrizes;

  LotteryEvent({
    this.id = 0,
    required this.eventDate,
    required this.eventTitle,
    required this.createdAt,
    required this.eventPrizes,
  });

  // Factory constructor for creating a LotteryEvent object from Supabase data
  factory LotteryEvent.fromMap(Map<String, dynamic> map) {
    return LotteryEvent(
      id: map['id'],
      eventDate: DateTime.parse(map['event_date']),
      eventTitle: map['event_title'],
      createdAt: DateTime.parse(map['created_at']),
      eventPrizes: map['event_prizes'] is List
          ? (map['event_prizes'] as List<dynamic>)
              .map((prize) => EventPrize.fromMap(prize as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  // Convert a LotteryEvent object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'event_date': eventDate.toIso8601String(),
      'event_title': eventTitle,
      'created_at': createdAt.toIso8601String(),
      'event_prizes': eventPrizes.map((prize) => prize.toMap()).toList(),
    };
  }
}
