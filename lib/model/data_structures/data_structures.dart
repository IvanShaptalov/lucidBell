// import 'package:flutter_lucid_bell/model/config_model.dart';

// class ThreeCashedIntervals<Duration> {
//   final _list = <Duration>[];

//   ThreeCashedIntervals(){
//     for (var element in BellConfig.threeCashedIntervals) {
//         push(element as Duration);
//      }
//   }

//   void push(Duration value) {
//     // if three alredy exists pop last
//     if (_list.length >= 3){
//       _list.add(value);
//     pop();
//     }
//     else{
//       _list.add(value);
//     }
//     // check if it true
//     assert(_list.length == 3);

    
//     }

//   Duration pop() => _list.removeLast();

//   Duration get peek => _list.last;

//   bool get isEmpty => _list.isEmpty;
//   bool get isNotEmpty => _list.isNotEmpty;

//   @override
//   String toString() => _list.toString();
// }