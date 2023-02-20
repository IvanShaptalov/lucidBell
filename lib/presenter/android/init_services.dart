// class InitServices {
//   static CustomNotificationService notificationService =
//       CustomNotificationService();
//   static bool isSliderChanging = false;
//   static Bell bell = mockBell();
//   static Bell mockBell() => Bell(false, [], const Duration(minutes: 15));

//   static var myApp = MyApp();

//   static StreamSubscription? bellListenerSub;

//   static Future<bool> init() async {
//     await LocalPathProvider.init();
//     print('local path initialized');
//     await notificationService.init();
//     print('notification initialized');
//     print('bell registered');
//     Bell? cashedBell = await Bell.loadLocalSettings();
//     if (cashedBell != null) {
//       InitServices.bell = cashedBell;
//     }
//     // if bell cashed, yield bell if bell listener condition;

//     registerBellListener();

//     return true;
//   }

//   static void registerBellListener() {
//     bellListenerSub = notificationService.bellListener().listen((event) {
//       notificationService.circleNotification();
//     });
//     // notification clearing here
//   }
// }