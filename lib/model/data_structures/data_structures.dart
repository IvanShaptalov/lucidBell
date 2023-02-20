import 'package:flutter_lucid_bell/model/config_model.dart';

class CashedIntervals {
  //===================================================FIELDS=================================================================
  final _list = <Duration>[];
  static const maxElements = BellConfig.maxCashedIntervals;

  //================================================CONSTRUCTORS=============================================================
  CashedIntervals() {
    _clear();
    for (var element in BellConfig.cashedIntervals) {
      push(element);
    }
  }

  CashedIntervals.setManually(List elements) {
    _clear();
    for (var element in elements) {
      push(element);
    }
  }

  CashedIntervals.fromListOfSeconds(List<dynamic> listOfSeconds) {
    _clear();
    List<Duration> listOfDuration =
        listOfSeconds.map((e) => Duration(seconds: e)).toList();

    for (var element in listOfDuration) {
      push(element);
    }
  }

  //====================================================PRIVATE METHODS===========================================================

  void _clear() {
    while (_list.isNotEmpty) {
      _pop();
    }
  }

  Duration? _pop() => _list.isNotEmpty ? _list.removeAt(0) : null;

  //=======================================================MAIN METHODS==========================================================
  void push(Duration value) {
    if (_list.contains(value)) {
      // already have it
    } else {
      _list.add(value);
      if (_list.length > 3) {
        _pop();
      }
    }
  }

  Duration getByIndex(int index) => _list[index];
  Duration get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;
  int get length => _list.length;

  //============================================================CONVERTING======================================================

  List<int> toListOfSeconds() => _list.map((e) => e.inSeconds).toList();

  //===========================================================BASE OVERRIDE===================================================
  @override
  String toString() => _list.toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(Object other) {
    return other is CashedIntervals &&
        hashCode == hashCode;
  }
}
// FULLY TESTED