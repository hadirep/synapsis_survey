import 'package:flutter/material.dart';
import 'package:synapsis_survey/common/state_enum.dart';
import 'package:synapsis_survey/domain/entities/survey.dart';
import 'package:synapsis_survey/domain/usecases/get_survey_list.dart';

class SurveyListNotifier extends ChangeNotifier {
  var _surveyList = <Survey>[];
  List<Survey> get surveyList => _surveyList;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  SurveyListNotifier({required this.getSurveyList});

  final GetSurveyList getSurveyList;

  Future<void> fetchSurveyList() async {
    _state = RequestState.loading;
    notifyListeners();
    final result = await getSurveyList.execute();
    result.fold(
      (failure) {
        _state = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (surveyData) {
        _state = RequestState.hasData;
        _surveyList = surveyData;
        notifyListeners();
      },
    );
  }
}
