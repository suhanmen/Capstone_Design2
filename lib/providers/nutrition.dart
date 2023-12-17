import 'package:flutter/material.dart';

class Nutrition with ChangeNotifier {
  int _kcal = 0;
  int _carbohydrate = 0;
  int _protein = 0;
  int _fat = 0;

  int _carboRate = 0;
  int _proteinRate = 0;
  int _fatRate = 0;

  int get kcal => _kcal;
  int get carbohydrate => _carbohydrate;
  int get protein => _protein;
  int get fat => _fat;

  int get carboRate => _carboRate;
  int get proteinRate => _proteinRate;
  int get fatRate => _fatRate;

  setData(int kcal, int carbohydrate, int protein, int fat) {
    _kcal = kcal;
    _carbohydrate = carbohydrate;
    _protein = protein;
    _fat = fat;
    
    notifyListeners();
  }

  setRate(int carboRate, int proteinRate, int fatRate) {
    _carboRate = carboRate;
    _proteinRate = proteinRate;
    _fatRate = fatRate;

    notifyListeners();
  }

  void clear() {
    _kcal = 0;
    _carboRate = 0;
    _protein = 0;
    _fat = 0;

    _carboRate = 0;
    _proteinRate = 0;
    _fatRate = 0;
  }
} 