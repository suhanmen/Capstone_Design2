import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

class User with ChangeNotifier {
  late String _id;
  late String _pw;
  late String _name;
  late String _type;
  late String _sex;
  late String _preference;
  late int _act;
  late int _age;
  late int _height;
  late int _weight;

  String get id => _id;
  String get pw => _pw;
  String get name => _name;
  String get sex => _sex;
  String get type => _type;
  String get preference => _preference;
  int get act => _act;
  int get age => _age;
  int get height => _height;
  int get weight => _weight;
  
  String get viewSex {
    if(_sex == "M") {
      return "남";
    } else {
      return "여자";
    }
  }

  String get viewPreference {
    if(_preference == 'rice') {
      return '밥';
    } if(_preference == 'noodle') {
      return '면';
    } if(_preference == 'bread') {
      return '빵';
    } if(_preference == 'meat') {
      return '고기';
    } else {
      return '상관없음';
    }
  }

  String convertHash(String password) {
    const uniqueKey = 'CapDi2';
    final bytes = utf8.encode(password+uniqueKey);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }


  writeAccount(String id, String pw) {
    _id = id;
    _pw = convertHash(pw);
    notifyListeners();
  }

  writeUser(String name, String sex, String type, int age, int height, int weight, int act) {
    _name = name;
    _type = type;
    _sex = sex;
    _age = age;
    _height = height;
    _weight = weight;
    _act = act;
    notifyListeners();
  }

  setUser(String id, String name, String sex, String type, String preference, int age, int height, int weight, int act) {
    _id = id;
    _name = name;
    _sex = sex;
    _type = type;
    _preference = preference;
    _age = age;
    _height = height;
    _weight = weight;
    _act = act;
    notifyListeners();
  }

  setPreference(String category) {
    _preference = category;

    notifyListeners();
  }

  editHeight(int height) {
    _height = height;

    notifyListeners();
  }

  editWeight(int weight) {
    _weight = weight;

    notifyListeners();
  }

  editAge(int age) {
    _age = age;

    notifyListeners();
  }

  editType(String type) {
    _type = type;

    notifyListeners();
  }

  editAct(int act) {
    _act = act;

    notifyListeners();
  }

  viewAct(int act) {
    if(act == 25) {
      return '5000보 이하';
    } else if(act == 30) {
      return '5000~10000만보';
    } else if(act == 33) {
      return '10000~15000보';
    } else if(act == 35) {
      return '150000~20000보';
    } else {
      return '15000보 이상';
    }
  }

  viewType(String type) {
    if(type == "N") {
      return "일반인";
    } else if(type == "H") {
      return "운동인";
    } else {
      return "다이어터";
    }
  }

  void clear() {
    _id ='';
    _pw = '';
    _name = '';
    _type = '';
    _sex = '';
    _preference = '';
    _act = 0;
    _age = 0;
    _height = 0;
    _weight = 0;
  }
} 