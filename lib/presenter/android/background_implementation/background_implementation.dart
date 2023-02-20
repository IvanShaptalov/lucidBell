
// @pragma('vm:entry-point')

// /// [callbackDispatcher] is background task that started in [InitServices.notificationService.circleNotification]
// /// load bell from file, add new interval save new bell to file and schedule notification to 1 seconds;
// /// tested with asserst
// void callbackDispatcher() {
//   // WidgetsFlutterBinding.ensureInitialized();

//   Workmanager().executeTask((task, inputData) async {
//     // NESSESARY INITIALIZATION

//     if (LocalPathProvider.notInitialized) {
//       await LocalPathProvider.init();
//     }
//     assert(LocalPathProvider.initialized);
//     // LocalPathProvider must be initialized!

//     Bell? bell = await Bell.loadLocalSettings();

//     String nextBellOn = 'Reminder';
//     assert(bell != null);
//     // bell must be saved!

//     //FIND OUT TASK
//     try {
//       switch (task) {
//         case Config.intervalTask:
//           assert(bell != null);

//           // ignore: unnecessary_null_comparison
//           assert(bell!.getInterval != null);
//           // interval must exist!
//           DateTime nextBell = DateTime.now().add(bell!.getInterval);

//           nextBellOn += ', next bell on $nextBell';

//           bell.notificationStack = [nextBell];

//           // new delay must be after now date
//           assert(DateTime.now().isBefore(bell.notificationStack.first));

//           await InitServices.notificationService
//               .scheduleNotifications('bell notification', nextBellOn);

//           // WAIT FOR NOTIFICATION

//           LocalPathProvider.saveBell(bell);

//           break;
//       }

//       return Future.value(true);
//     } catch (e) {
//       print(e.toString());
//       return Future.error(e.toString());
//     }
//   });
// }



  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );