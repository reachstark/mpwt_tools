import 'dart:async';

import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/utils/show_loading.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbController extends GetxController {
  static DbController get to => Get.find();

  final SupabaseClient supabase = Supabase.instance.client;

  RxList<LotteryEvent> lotteryEvents = <LotteryEvent>[].obs;
  Rx<LotteryEvent> selectedLotteryEvent = LotteryEvent(
    id: 0,
    eventDate: DateTime.now(),
    eventTitle: '',
    createdAt: DateTime.now(),
    eventPrizes: [],
  ).obs;
  RxString masterKey = ''.obs;

  @override
  void onInit() {
    readMasterKey();
    listenToMasterKeyChanges();
    readLotteryEvents();
    super.onInit();
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
    supabase
        .from(lotteryMasterkey)
        .stream(primaryKey: ['id']).listen((response) {
      if (response.isNotEmpty) {
        masterKey.value = response.first['access_code'];
      }
    });
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
      selectedLotteryEvent.value = lotteryEvents.first;

      stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  // CRUD for LotteryWinner
  Future<void> createLotteryWinner(Map<String, dynamic> winnerData) async {
    try {
      final response =
          await supabase.from(lotteryWinnersTable).insert(winnerData);
      if (response.error != null) {
        throw Exception(
            'Error creating lottery winner: ${response.error!.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> readLotteryWinners(String eventId) async {
    try {
      final response = await supabase
          .from(lotteryWinnersTable)
          .select()
          .eq('event_id', eventId);

      return response;
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
}
