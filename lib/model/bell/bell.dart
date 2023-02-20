// import 'dart:convert';

// import 'package:flutter_lucid_bell/model/config_model.dart';
// import 'package:flutter_lucid_bell/model/data_structures.dart';


// abstract class BaseBell {
//   late bool _running;
//   /// true if [running] set, false if not
//   bool setRunning(bool running);
//   bool getRunning();

//   late Duration _interval;
//   /// false if [_interval] not set, true if set,  set[_nextNotificationOn] here
//   bool setInterval(Duration interval);
//   Duration getInterval();

//   final double _intervalLowerBound = BellConfig.bellMinutesLowerBound;
//   final  double _intervalUpperBound = BellConfig.bellMinutesUpperBound;

//   late DateTime? _nextNotificationOn;

//   BaseBell init();

//   /// true if [_nextNotification] cleared, false if not
//   bool _clearNextNotification();

//   /// present duration to human readable style
//   String humanLikeDuration(Duration duration);

//   /// create bell from json
//   BaseBell fromJson(String json);

//   /// convert bell to json
//   String toJson();

//   /// load bell from implemented storage
//   BaseBell loadFromStorage();


// }


// class Bell extends BaseBell with BellStorageManager {
//   ThreeCashedIntervals threeCashedIntervals = 

//   @override
//   BaseBell init(){
//     return Bell();
//   }

//   @override
//   BaseBell fromJson(String json) {
//     // TODO: implement fromJson
//     throw UnimplementedError();
//   }

//   @override
//   Duration getInterval() {
//     // TODO: implement getInterval
//     throw UnimplementedError();
//   }

//   @override
//   bool getRunning() {
//     // TODO: implement getRunning
//     throw UnimplementedError();
//   }

//   @override
//   String humanLikeDuration(Duration duration) {
//     // TODO: implement humanLikeDuration
//     throw UnimplementedError();
//   }

//   @override
//   BaseBell loadFromStorage() {
//     return loadBellFromStorage();
//   }

//   @override
//   bool setInterval(Duration interval) {
//     // TODO: implement setInterval
//     throw UnimplementedError();
//   }

//   @override
//   bool setRunning(bool running) {
//     // TODO: implement setRunning
//     throw UnimplementedError();
//   }

//   @override
//   String toJson() {
//     // TODO: implement toJson
//     throw UnimplementedError();
//   }
  
//   @override
//   bool _clearNextNotification() {
//     // TODO: implement _clearNextNotification
//     throw UnimplementedError();
//   }

// }


// mixin BellStorageManager {
//   Bell loadBellFromStorage(){
//     throw UnimplementedError();
//   }

//   Bell saveBellToStorage(){
//     throw UnimplementedError();
//   }
// }

// mixin BellNotificationManager {

// }

// mixin BackGroundBellWorker {

// }







// // factory Bell.fromJson(String jsonString) {
// //     Map<String, dynamic> map = jsonDecode(jsonString);
// //     return Bell(
// //       map['running'],
// //       map['notificationStack'].map((jsonDatetime) {
// //         return DateTime.parse(jsonDatetime);
// //       }).toList(),
// //       Duration(seconds: map['interval']),
// //     );
// //   }

// //   String toJson() {
// //     Map<String, dynamic> map = <String, dynamic>{
// //       'running': running,
// //       'interval': _interval.inSeconds,
// //       'notificationStack': notificationStack.isNotEmpty
// //           ? notificationStack.map((datetime) {
// //               return datetime.toString();
// //             }).toList()
// //           : [],
// //     };
// //     return jsonEncode(map);
// //   }

// //   static Future<Bell?> loadLocalSettings() async {
// //     try {
// //       Bell bell;
// //       var jsonBell = await LocalPathProvider.getBellJsonAsync();
// //       if (jsonBell is String) {
// //         bell = Bell.fromJson(jsonBell);
// //         return bell;
// //       }
// //       return null; // return null if bell not exists
// //     } catch (e) {
// //       print(e);
// //       return null; //same
// //     }
// //   }
  

