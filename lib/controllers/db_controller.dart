import 'dart:async';
import 'dart:io';

import 'package:estimation_list_generator/models/event_prize.dart';
import 'package:estimation_list_generator/models/fmis_code.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/models/winning_ticket.dart';
import 'package:estimation_list_generator/utils/show_error.dart';
import 'package:estimation_list_generator/utils/show_loading.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:estimation_list_generator/widgets/snackbar/snackbars.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbController extends GetxController {
  static DbController get to => Get.find();

  final SupabaseClient supabase = Supabase.instance.client;
  final searchController = TextEditingController();

  StreamSubscription? _winnerSubscription;

  RxString subscribeStatus = 'none'.obs;
  RxBool isSubscribed = false.obs;
  RxList<String> dbLogs = <String>[].obs;
  RxList<FmisCode> fmisCodes = <FmisCode>[].obs;
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
    getFmisCodes();
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

  Future<void> exportLotteryData() async {
    showLoading();
    List<Map<String, dynamic>> eventDetail = await supabase
        .from(lotteryEventsTable)
        .select()
        .eq('id', selectedLotteryEvent.value.id);

    List<Map<String, dynamic>> eventWinners = await supabase
        .from(lotteryWinnersTable)
        .select()
        .eq('event_id', selectedLotteryEvent.value.id);

    if (eventDetail.isEmpty) {
      stopLoading();
      showWarningSnackbar(message: 'No data to export');
      return;
    }

    // Create a new Excel file
    var excel = Excel.createExcel();

    // Header cell styles
    CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#1E2A5E'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
    );

    // Get and rename the default sheet instead of creating a new one
    String defaultSheetName = excel.getDefaultSheet() ?? 'Sheet1';
    excel.rename(defaultSheetName, 'Lottery Data');

    // Access the renamed sheet
    var eventSheet = excel['Lottery Data'];

    // Define Headers for Lottery Data sheet
    List<String> eventHeaders = [
      'Prize Title',
      'Quantity',
      'Is Top Prize',
      'Prize ID',
    ];

    eventSheet.appendRow(eventHeaders.map((e) => TextCellValue(e)).toList());

    // Apply header styles
    for (int i = 0; i < eventHeaders.length; i++) {
      eventSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .cellStyle = headerStyle;
    }

    eventSheet.setRowHeight(0, 24); // header row height
    eventSheet.setColumnWidth(0, 30);
    eventSheet.setColumnWidth(2, 12);
    eventSheet.setColumnWidth(3, 10);

    for (var row in eventDetail) {
      List<dynamic> eventPrizes = row['event_prizes'];

      for (var prize in eventPrizes) {
        eventSheet.appendRow([
          TextCellValue(prize['prizeTitle']),
          IntCellValue(prize['quantity']),
          BoolCellValue(prize['isTopPrize']),
          IntCellValue(prize['id']),
        ]);
      }
    }

    // Create a new sheet for Winners
    var winnersSheet = excel['Winners'];

    // Define Headers for Winners sheet
    List<String> winnersHeaders = [
      'Ticket Number',
      'Lottery Prize',
      'Is Claimed',
    ];

    winnersSheet
        .appendRow(winnersHeaders.map((e) => TextCellValue(e)).toList());

    // Apply header styles
    for (int i = 0; i < winnersHeaders.length; i++) {
      winnersSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .cellStyle = headerStyle;
    }

    winnersSheet.setRowHeight(0, 24); // header row height
    winnersSheet.setColumnWidth(0, 15);
    winnersSheet.setColumnWidth(1, 20);
    winnersSheet.setColumnWidth(2, 12);

    for (var winner in eventWinners) {
      winnersSheet.appendRow([
        TextCellValue(winner['ticket_number'].toString()),
        TextCellValue(winner['lottery_prize'].toString()),
        BoolCellValue(winner['is_claimed']),
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/${eventDetail.first['event_title']}.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
    stopLoading();
    showSuccessSnackbar(message: 'Lottery data exported to $filePath');
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
  Future<bool> createLotteryWinner(LotteryWinner winnerData) async {
    try {
      // Step 1: Check if a winner with the same ticket number already exists in supabase
      final existingWinner =
          await findWinnerByTicketNumber(winnerData.ticketNumber);

      if (existingWinner.ticketNumber == winnerData.ticketNumber) {
        Future.delayed(const Duration(milliseconds: 300), () {
          showErrorMessage(
            'អ្នកឈ្នះដែលមានលេខសំបុត្រ ${winnerData.ticketNumber} មានទិន្នន័យរួចហើយ',
          );
        });
        return false;
      } else {
        await supabase.from(lotteryWinnersTable).insert(winnerData.toMap());
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  void getAllLotteryWinners({
    bool loading = false,
  }) async {
    try {
      if (loading) showLoading();
      final response = await supabase.from(lotteryWinnersTable).select().order(
            'id',
            ascending: true,
          );

      lotteryWinners.assignAll((response as List<dynamic>)
          .map((e) => LotteryWinner.fromMap(e))
          .toList());

      if (loading) stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllLotteryPrizeWinners({
    required int eventId,
  }) async {
    try {
      final response = await supabase
          .from(lotteryWinnersTable)
          .select()
          .eq('event_id', eventId)
          .order('id', ascending: true);
      lotteryWinners.assignAll((response as List<dynamic>)
          .map((e) => LotteryWinner.fromMap(e))
          .toList());
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
          .eq('lottery_prize', prizeName)
          .order('id', ascending: true);
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

  Future<String> getClaimedPrizesCount(int eventId) async {
    try {
      final response = await supabase
          .from(lotteryWinnersTable)
          .select('id')
          .eq('event_id', eventId)
          .eq('is_claimed', true);

      return response.length.toString();
    } catch (e) {
      return '0'; // In case of error, return 0
    }
  }

  Future<void> getFmisCodes({
    bool loading = false,
  }) async {
    try {
      if (loading) showLoading();
      final response = await supabase
          .from(fmisCodesTable)
          .select()
          .order('id', ascending: true);
      fmisCodes.assignAll(
          (response as List<dynamic>).map((e) => FmisCode.fromMap(e)).toList());
      if (loading) stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFmisCode(FmisCode fmisCode) async {
    try {
      showLoading();
      await supabase.from(fmisCodesTable).insert(fmisCode.toMap());
      stopLoading();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFmisCode(int fmisCodeId) async {
    try {
      if (fmisCodeId == 0) {
        showErrorSnackbar(
          message: 'Please refresh the list first then try again.',
          action: ScaleButton(
            onTap: () => getFmisCodes(loading: true),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                  const Gap(4),
                  const Text(
                    'Refresh List',
                    style: TextStyle(color: Colors.black),
                  ),
                  const Gap(4),
                ],
              ),
            ),
          ),
        );
        return;
      }
      showLoading();
      await supabase.from(fmisCodesTable).delete().eq('id', fmisCodeId);
      // delete from local list
      fmisCodes.removeWhere((element) => element.id == fmisCodeId);
      stopLoading();
    } catch (e) {
      rethrow;
    }
  }
}
