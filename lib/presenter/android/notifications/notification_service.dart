
// class CustomNotificationService {
//   int currentId = 0;
//   Random rand = Random();
//   final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     // #1
//     const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const initSettings = InitializationSettings(android: androidSetting);

//     // #3
//     await _localNotificationsPlugin.initialize(initSettings).then((_) {
//       debugPrint('setupPlugin: setup success');
//     }).catchError((Object error) {
//       debugPrint('Error: $error');
//     });
//   }

//   Future<void> registerNotification(
//     title,
//     body,
//     endTime,
//     channel,
//   ) async {
//     // #1

//     tz_data.initializeTimeZones();
//     final scheduleTime =
//         tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

// // #2
//     final androidDetail = AndroidNotificationDetails(
//         channel, // channel Id
//         channel // channel Name
//         );

//     final noticeDetail = NotificationDetails(
//       android: androidDetail,
//     );

// // #3
//     final id = 0;

// // #4
//     await _localNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduleTime,
//       noticeDetail,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }

//   bool dateExpiredOrStackEmpty(Bell innerBell) {
//     if (innerBell.notificationStack.isNotEmpty) {
//       return DateTime.now().isAfter(innerBell.notificationStack.first);
//     }
//     return true;
//   }

//   //id to identify new notification
//   Future<void> scheduleNotifications(String title, String body) async {
//     try {
//       await registerNotification(
//           title, body, DateTime.now().millisecondsSinceEpoch + 1000, 'testing');
//     } catch (e) {
//       // ignore: avoid_print
//       print(e);
//     }
//   }

//   /// listen changes in [InitServices.bell] and
//   /// if it exist, yield bell
 

//   /// [circleNotification] react to [bellListener] check
//   /// that [innerBell] is running, if true
//   /// check if notificationStack expired or empty
//   /// add new notification in stack, save to file, register periodic task
//   /// [callbackDispatcher] in main.dart
//   /// if bell paused, clear all
//   void circleNotification() async {
//     // ASSERT THAT BELL ALWAYS CREATED
//     // ignore: unnecessary_null_comparison
//     assert(InitServices.bell != null);
//     // NOTIFICATION STACK ALWAYS CONTAIN ONE OR NOT CONTAINS NOTIFICATIONS;

//     // NOTIFICATION SCHEDULING LOGIC HERE
//     if (InitServices.bell.running) {
//       print('try add notification');

//       // add new task
//       if (dateExpiredOrStackEmpty(InitServices.bell)) {
//         // assert that not expired
//         if (InitServices.bell.notificationStack.isNotEmpty) {
//           assert(DateTime.now()
//               .isAfter(InitServices.bell.notificationStack.first));
//         }

//         // assert that must be empty
//         assert(InitServices.bell.notificationStack.isEmpty);

//         await InitServices.bell.clearNotifications();

//         // check that really cleared
//         assert(InitServices.bell.notificationStack.isEmpty);

//         InitServices.bell.notificationStack = [
//           DateTime.now().add(InitServices.bell.getInterval)
//         ];

//         // added delayed datetime
//         assert(
//             DateTime.now().isBefore(InitServices.bell.notificationStack.first));

//         await LocalPathProvider.saveBell(InitServices.bell);

//         await Workmanager().registerPeriodicTask(
//             Config.intervalTask, Config.intervalTask,
//             frequency: InitServices.bell.getInterval);
//       } else {
//         // can be just changed
//         await LocalPathProvider.saveBell(InitServices.bell);
//       }
//     } else {
//       await InitServices.bell.clearNotifications();
//     }
//   }
// }

mixin AndroidBellNotificationService {
  Future<bool> scheduleNotification() async{
    throw UnimplementedError();
  }


  bool dateExpired(DateTime otherDate) {
    throw UnimplementedError();
  }

  Future<void> registerNotification() async {
    throw UnimplementedError();
  }
}