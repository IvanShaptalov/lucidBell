// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter_lucid_bell/main.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

// class SliderIntervalSelector extends StatefulWidget {
//   const SliderIntervalSelector({super.key});

//   @override
//   State<SliderIntervalSelector> createState() => _SliderIntervalSelectorState();
// }

// class _SliderIntervalSelectorState extends State<SliderIntervalSelector> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(InitServices.bell
//             .convertFromMinutesToH(InitServices.bell.getInterval)),
//         SfSlider(
//           min: InitServices.bell.intervalLowerBound,
//           max: InitServices.bell.intervalUpperBound,
//           interval: 15,
//           stepSize: 5,
//           value: InitServices.bell.getInterval.inMinutes.toDouble(),
//           onChanged: (value) async {
//             setState(() {
//               // update notifications
//             });
//             InitServices.bell.setInterval = Duration(minutes: value.round());
//             await InitServices.bell.clearNotifications();
//             assert(InitServices
//                 .bell.notificationStack.isEmpty); // need to be empty
//           },
//           onChangeStart: (value) {
//             InitServices.isSliderChanging = true;
//             assert(InitServices
//                 .bell.notificationStack.isEmpty); // need to be empty
//             // widget.callBackIsChanged(true);
//           },
//           onChangeEnd: (value) {
//             Future.delayed(const Duration(milliseconds: 300))
//                 .then((value) => InitServices.isSliderChanging = false);

//             assert(InitServices
//                 .bell.notificationStack.isEmpty); // need to be empty
//             // widget.callBackIsChanged(false);
//           },
//         ),
//       ],
//     );
//   }
// }