import 'package:equatable/equatable.dart';
import 'package:synapsis_survey/data/models/survey_model.dart';

class SurveyResponse extends Equatable {
  final List<SurveyModel> data;

  const SurveyResponse({
    required this.data,
  });

  factory SurveyResponse.fromJson(Map<String, dynamic> json) => SurveyResponse(
    data: List<SurveyModel>.from(json["data"].map((x) => SurveyModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

  @override
  List<Object?> get props => [data];
}
