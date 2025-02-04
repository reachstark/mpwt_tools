import 'package:estimation_list_generator/models/event_prize.dart';

String getPrizesCount(List<EventPrize> prizes) {
  var count = 0;
  for (var i = 0; i < prizes.length; i++) {
    count += prizes[i].quantity;
  }
  return count.toString();
}

String getBigPrizesCount(List<EventPrize> prizes) {
  var count = 0;
  for (var i = 0; i < prizes.length; i++) {
    if (prizes[i].isTopPrize) count += prizes[i].quantity;
  }
  return count.toString();
}
