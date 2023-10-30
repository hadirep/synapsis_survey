import 'package:flutter/material.dart';

class SurveyAnswerNotifier with ChangeNotifier {
  String _currentAnswer = "";

  String get answer => _currentAnswer;

  void setAnswer(String answer) {
    _currentAnswer = answer;
    notifyListeners();
  }
}