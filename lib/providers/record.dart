import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Record with ChangeNotifier {

  late List<dynamic> _list;
  late int _todayKcal;
  late double _todayCarbohydrate;
  late double _todayProtein;
  late double _todayFat;

  List get list => _list;
  int get todayKcal => _todayKcal;
  double get todayCarbohydrate => _todayCarbohydrate;
  double get todayProtein => _todayProtein;
  double get todayFat => _todayFat;

  DateTime now = DateTime.now();

  setRecords(List<dynamic> list) {
    _list = list;
    if (_list.isEmpty) {
      _todayKcal = 0;
      _todayCarbohydrate = 0;
      _todayProtein = 0;
      _todayFat = 0;
    } else if(DateFormat('yyyy-MM-dd').format(now) == list[0]['date']) {
      _todayKcal = int.parse(list[0]['kcal']);
      _todayCarbohydrate = double.parse(list[0]['carbohydrate'].toStringAsFixed(2));
      _todayProtein = double.parse(list[0]['protein'].toStringAsFixed(2));
      _todayFat = double.parse(list[0]['fat'].toStringAsFixed(2));
      _list.removeAt(0);
    } else {
      _todayKcal = 0;
      _todayCarbohydrate = 0;
      _todayProtein = 0;
      _todayFat = 0;
    }

    notifyListeners();
  }

  void clear() {
    _list.clear();
    _todayKcal = 0;
    _todayCarbohydrate = 0;
    _todayProtein = 0;
    _todayFat = 0;
  }
}