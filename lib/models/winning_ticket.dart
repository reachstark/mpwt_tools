class LotteryWinner {
  final int id; // This is the primary key (auto-incremented) in the table.
  final int eventId; // Foreign key referencing `lottery_events.event_id`.
  final String ticketNumber; // The winning ticket number.
  final String lotteryPrize; // The prize won by this ticket.
  bool isClaimed; // Whether the prize has been claimed.

  LotteryWinner({
    this.id = 0,
    required this.eventId,
    required this.ticketNumber,
    required this.lotteryPrize,
    this.isClaimed = false,
  });

  // Factory constructor for creating a LotteryWinner object from Supabase data
  factory LotteryWinner.fromMap(Map<String, dynamic> map) {
    return LotteryWinner(
      id: map['id'], // Supabase returns the `id` field.
      eventId: map['event_id'],
      ticketNumber: map['ticket_number'],
      lotteryPrize: map['lottery_prize'],
      isClaimed: map['is_claimed'],
    );
  }

  // Convert a LotteryWinner object to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'ticket_number': ticketNumber,
      'lottery_prize': lotteryPrize,
      'is_claimed': isClaimed,
    };
  }
}
