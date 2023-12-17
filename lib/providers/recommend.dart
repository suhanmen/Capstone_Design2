import 'package:flutter/material.dart';

class Recommend with ChangeNotifier {
  late List<String> _name = List.empty(growable: true);
  late List<String> _category = List.empty(growable: true);
  late List<String> _detail = List.empty(growable: true);

  List get name => _name;
  List get category => _category;
  List get detail => _detail;

  set setList(List value) {
    _name = List.filled(value.length, "");
    _category = List.filled(value.length, "");
    _detail = List.filled(value.length, "");

    for(int i=0; i<value.length; i++) {
      _name[i] = value[i]['name'];
      _category[i] = value[i]['category'];
      _detail[i] = value[i]['detail'];
    } 
    notifyListeners();
  }

  void clear() {
    _name.clear();
    _category.clear();
    _detail.clear();
  }
} 