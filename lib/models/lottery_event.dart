import 'package:estimation_list_generator/models/event_prize.dart';

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
