import 'package:flutter/cupertino.dart';

class BmiDetail {
  int _id;
  DateTime _date;
  double _weight;
  double _height;
  double? _bmi;
  String? _bmiClassification;

  BmiDetail(this._id, this._date, this._weight, this._height) {
    _bmi = calculateBmi();
    _bmiClassification = bmiClassificationTerm(_bmi!);
  }

  calculateBmi() {
    if (_height == 0 || _weight == 0) {
      throw ArgumentError();
    }
    double heightInMeters = _height / 100.0;
    return (_weight / (heightInMeters * heightInMeters));
  }

  String bmiClassificationTerm(double bmi) {
    switch (bmi) {
      case < 16:
        return 'Severe Thinness';
      case < 17:
        return 'Moderate Thinness';
      case < 18.5:
        return 'Mild Thinness';
      case < 25:
        return 'Healthy Weight';
      case < 30:
        return 'Overweight';
      case < 35:
        return 'Obesity Class I (Moderate)';
      case < 40:
        return 'Obesity Class II (Severe)';
      case >= 40:
        return 'Obesity Class III (Morbid)';
      default:
        return 'Invalid BMI';
    }
  }

  int get id => _id * 1;
  set id(int id) {
    _id = id;
  }

  double get height => _height * 1;
  set height(double value) {
    _height = value;
  }

  double get weight => _weight * 1;
  set weight(double value) {
    _weight = value;
  }

  DateTime get date => _date;
  set date(DateTime value) {
    _date = value;
  }

  double? get bmi => _bmi;

  String? get bmiClassification => _bmiClassification;
}
