// import 'package:flutter_lucid_bell/presenter/presenter.dart';

// /// USE VIEW TO CREATE LAST IN ANDROID PLATFORM IN THIS CASE
// class View {
//   static Duration oldDuration = Duration(days: 1);
//   static Stream<Duration> bellDurationListener(Duration duration) async* {
//     await Future.delayed(const Duration(seconds: 1));

//     print('listen');
//     if (BellPresenter.bell!.getRunning()) {
//       if (oldDuration != BellPresenter.bell!.getInterval()) {
//         yield duration;
//       }
//     }
//   }
// }
