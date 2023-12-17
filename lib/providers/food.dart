import 'package:flutter/material.dart';

class Food with ChangeNotifier {
  late String _id;
  late String _code;
  double _gram = 0; //1인분 기준 그람
  double _amount = 0; //섭취량 ex 1인분, 2인분
  DateTime _date = DateTime.now();

  String get id => _id;
  String get code => _code;
  double get gram => _gram;
  double get amount => _amount;
  double get total => _amount*_gram;
  DateTime get date => _date;
  
  set setId(String value) {
    _id = value;
    notifyListeners();
  }
  set setCode(String value) {
    _code = value; 
    notifyListeners();
  }
  set setDate(DateTime value) {
    _date = value;
    notifyListeners();
  } 

  set setGram(double value) {
    _gram = value;
    notifyListeners();
  }

  set setAmount(double value) {
    _amount = value;
    notifyListeners();
  }

  void clear() {
    _id = '';
    _code = '';
    _gram = 0;
    _amount = 0;
  }
} 