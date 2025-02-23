import 'dart:async';

import 'package:estimation_list_generator/models/event_prize.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/models/winning_ticket.dart';
import 'package:estimation_list_generator/utils/show_loading.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbController extends GetxController {
  static DbController get to => Get.find();

  final SupabaseClient supabase = Supabase.instance.client;
  final searchController = TextEditingController();

  StreamSubscription? _winnerSubscription;

  RxString subscribeStatus = 'none'.obs;
  RxBool isSubscribed = false.obs;
  RxList<String> dbLogs = <String>[].obs;
  RxList<LotteryEvent> lotteryEvents = <LotteryEvent>[].obs;
  RxList<LotteryWinner> lotteryWinners = <LotteryWinner>[].obs;
  Rx<LotteryEvent> selectedLotteryEvent = LotteryEvent(
    id: 0,
    eventDate: DateTime.now(),
    eventTitle: '',
    createdAt: DateTime.now(),
    eventPrizes: [],
  ).obs;
  RxString masterKey = ''.obs;
  Rx<LotteryWinner> selectedWinner = LotteryWinner(
    eventId: 0,
    ticketNumber: '',
    lotteryPrize: '',
  ).obs;

  @override
  void onInit() {
    readMasterKey();
    listenToMasterKeyChanges();
    readLotteryEvents();
    getAllLotteryWinners();
    super.onInit();
  }

  void clearLogs() {
    dbLogs.clear();
  }

  // Read lottery_masterkey table and returns the field "access_code" type string
  Future<void> readMasterKey() async {
    try {
      final response = await supabase.from(lotteryMasterkey).select();
      if (response.isNotEmpty) {
        masterKey.value = response.first['access_code'];
      }
    } catch (e) {
      rethrow;
    }
  }

  // listen to masterkey changes
  void listenToMasterKeyChanges() {
    void startListening() {
      supabase.from(lotteryMasterkey).stream(primaryKey: ['id']).listen(
        (response) {
          if (response.isNotEmpty) {
            masterKey.value = response.first['access_code'];
          }
        },
        onError: (error) {
          dbLogs.add(error.toString());
          Future.delayed(
            Duration(seconds: 5),
            startListening,
          ); // Auto-reconnect after 5 seconds
        },
        onDone: () {
          dbLogs.add('Realtime connection closed, restarting in 5 seconds...');
          Future.delayed(
            Duration(seconds: 5),
            startListening,
          ); // Auto-reconnect
        },
      );
    }

    startListening();
  }

  void listenToWinnerChanges({required int eventId}) {
    _winnerSubscription?.cancel(); // Cancel any previous listener

    void startListening() {
      isSubscribed.value = true;
      dbLogs.add('Subscribing to event_id: $eventId');
      _winnerSubscription = supabase
          .from(lotteryWinnersTable)
          .stream(primaryKey: ['id'])
          .eq('event_id', eventId)
          .listen(
            (response) {
              dbLogs.add('Received new data for event_id: $eventId');
              subscribeStatus.value = 'active';
              // insert new lottery winner to local list when a new winner is added, without having to replace all data
              for (var i = 0; i < response.length; i++) {
                if (lotteryWinners
                    .where((element) => element.id == response[i]['id'])
                    .isEmpty) {
                  lotteryWinners.add(LotteryWinner.fromMap(response[i]));
                }
              }
            },
            onError: (error) {
              dbLogs.add(error.toString());
              isSubscribed.value = false;
              subscribeStatus.value = 'disconnected';
              Future.delayed(const Duration(seconds: 5), startListening);
            },
            onDone: () {
              dbLogs.add(
                  'Realtime connection closed, restarting in 5 seconds...');
              isSubscribed.value = false;
              subscribeStatus.value = 'disconnected';
              Future.delayed(const Duration(seconds: 5), startListening);
            },
          );
    }

    startListening();
  }

  void stopListeningToWinnerChanges() {
    if (_winnerSubscription == null) return;
    _winnerSubscription?.cancel();
    _winnerSubscription = null;
    isSubscribed.value = false;
    subscribeStatus.value = 'none';
    dbLogs.add('Realtime connection closed.');
  }

  // CRUD for LotteryEvent
  Future<Map<String, dynamic>> createLotteryEvent(
      LotteryEvent lotteryEvent) async {
    try {
      showLoading();
      final response = await supabase
          .from(lotteryEventsTable)
          .insert(lotteryEvent.toMap())
          .select();

      readLotteryEvents();

      stopLoading();

      return {
        'success': true,
        'message': 'Lottery event created successfully!',
        'data': response.first, // Return the newly created event data
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error creating lottery event: $e',
      };
    }
  }

  void readLotteryEvents({
    bool loading = false,
  }) async {
    try {
      if (loading) showLoading();
      final response = await supabase.from(lotteryEventsTable).select();

      lotteryEvents.value = (response as List<dynamic>)
          .map((data) => LotteryEvent.fromMap(data))
          .toList();
      if (loading) stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLotteryEvent(
      int eventId, LotteryEvent updatedEvent) async {
    try {
      showLoading();
      await supabase
          .from(lotteryEventsTable)
          .update(updatedEvent.toMap())
          .eq('id', eventId);

      readLotteryEvents();

      // Update the local list and refresh UI
      selectedLotteryEvent.value = updatedEvent;
      lotteryEvents.refresh();

      stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addLotteryPrize(
      int eventId, EventPrize prize) async {
    try {
      showLoading();
      // Step 1: Fetch existing event_prizes
      final response = await supabase
          .from(lotteryEventsTable)
          .select('event_prizes')
          .eq('id', eventId)
          .single();

      // Step 2: Extract current event_prizes and append the new prize
      List<dynamic> currentPrizes =
          response['event_prizes'] ?? []; // Ensure it's a list
      currentPrizes.add(prize.toMap()); // Append new prize

      // Step 3: Update Supabase with the new list
      final updateResponse = await supabase
          .from(lotteryEventsTable)
          .update({'event_prizes': currentPrizes}).eq('id', eventId);

      // Step 4: Update the local list and refresh UI
      selectedLotteryEvent.value.eventPrizes.add(prize);
      selectedLotteryEvent.refresh();

      stopLoading();

      return {
        'success': true,
        'message': 'Lottery event updated successfully!',
        'data': updateResponse.first,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateLotteryPrize(
      int eventId, EventPrize updatedPrize) async {
    try {
      // Fetch current event_prizes
      final response = await supabase
          .from(lotteryEventsTable)
          .select('event_prizes')
          .eq('id', eventId)
          .single();

      List<dynamic> currentPrizes = response['event_prizes'] ?? [];

      // Find and update the prize
      for (var i = 0; i < currentPrizes.length; i++) {
        if (currentPrizes[i]['id'] == updatedPrize.id) {
          currentPrizes[i] = updatedPrize.toMap();
          break;
        }
      }

      // Update Supabase
      final updateResponse = await supabase
          .from(lotteryEventsTable)
          .update({'event_prizes': currentPrizes}).eq('id', eventId);

      // Update local list and refresh UI
      int index = selectedLotteryEvent.value.eventPrizes
          .indexWhere((prize) => prize.id == updatedPrize.id);
      if (index != -1) {
        selectedLotteryEvent.value.eventPrizes[index] = updatedPrize;
      }
      selectedLotteryEvent.refresh();

      return {
        'success': true,
        'message': 'Lottery prize updated successfully!',
        'data': updateResponse.first,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> deleteLotteryPrize(
      int eventId, int prizeId) async {
    try {
      showLoading();
      // Fetch current event_prizes
      final response = await supabase
          .from(lotteryEventsTable)
          .select('event_prizes')
          .eq('id', eventId)
          .single();

      List<dynamic> currentPrizes = response['event_prizes'] ?? [];

      // Remove the prize with the given ID
      currentPrizes.removeWhere((prize) => prize['id'] == prizeId);

      // Update Supabase
      final updateResponse = await supabase
          .from(lotteryEventsTable)
          .update({'event_prizes': currentPrizes}).eq('id', eventId);

      // Update local list and refresh UI
      selectedLotteryEvent.value.eventPrizes
          .removeWhere((prize) => prize.id == prizeId);
      selectedLotteryEvent.refresh();

      stopLoading();

      return {
        'success': true,
        'message': 'Lottery prize deleted successfully!',
        'data': updateResponse.first,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  Future<void> deleteLotteryEvent(int eventId) async {
    try {
      showLoading();
      await supabase.from(lotteryEventsTable).delete().eq('id', eventId);

      // handle deleting the event from the local list and UI
      readLotteryEvents();
      selectedLotteryEvent.value = LotteryEvent(
        id: 0,
        eventTitle: 'No event selected',
        eventDate: DateTime(2000),
        createdAt: DateTime(2000),
        eventPrizes: [],
      );

      stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  // CRUD for LotteryWinner
  Future<void> createLotteryWinner(LotteryWinner winnerData) async {
    try {
      await supabase.from(lotteryWinnersTable).insert(winnerData.toMap());
    } catch (e) {
      rethrow;
    }
  }

  void getAllLotteryWinners({
    bool loading = false,
  }) async {
    try {
      if (loading) showLoading();
      final response = await supabase.from(lotteryWinnersTable).select();

      lotteryWinners.assignAll((response as List<dynamic>)
          .map((e) => LotteryWinner.fromMap(e))
          .toList());

      if (loading) stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LotteryWinner>> getLotteryPrizeWinners({
    required int eventId,
    required String prizeName,
  }) async {
    try {
      final response = await supabase
          .from(lotteryWinnersTable)
          .select()
          .eq('event_id', eventId)
          .eq('lottery_prize', prizeName);
      return response.map((e) => LotteryWinner.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLotteryWinner(
      int winnerId, Map<String, dynamic> updatedData) async {
    try {
      final response = await supabase
          .from(lotteryWinnersTable)
          .update(updatedData)
          .eq('id', winnerId);
      if (response.error != null) {
        throw Exception(
            'Error updating lottery winner: ${response.error!.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteLotteryWinner(int winnerId) async {
    try {
      final response =
          await supabase.from(lotteryWinnersTable).delete().eq('id', winnerId);
      if (response.error != null) {
        throw Exception(
            'Error deleting lottery winner: ${response.error!.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> switchTicketClaimStatus(int ticketId, bool isClaimed) async {
    try {
      await supabase
          .from(lotteryWinnersTable)
          .update({'is_claimed': isClaimed})
          .eq('id', ticketId)
          .eq('event_id', selectedWinner.value.eventId);

      selectedWinner.value.isClaimed = isClaimed;
      selectedWinner.refresh();
    } catch (e) {
      rethrow;
    }
  }

  Future<LotteryWinner> findWinnerByTicketNumber(String ticketNumber) async {
    try {
      final response = await supabase
          .from(lotteryWinnersTable)
          .select()
          .eq('ticket_number', ticketNumber)
          .single();

      return LotteryWinner.fromMap(response);
    } catch (e) {
      return LotteryWinner(
        id: -1,
        eventId: -1,
        lotteryPrize: 'NOT FOUND',
        ticketNumber: 'NOT FOUND',
        isClaimed: false,
      );
    }
  }
}
