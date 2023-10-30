import 'package:equatable/equatable.dart';
import 'package:synapsis_survey/data/models/question_model.dart';
import 'package:synapsis_survey/domain/entities/survey.dart';

class SurveyModel extends Equatable {
  const SurveyModel({
    required this.id,
    required this.surveyName,
    required this.status,
    required this.totalRespondent,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  final String id;
  final String surveyName;
  final int status;
  final int totalRespondent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionModel> questions;

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json["id"],
      surveyName: json["survey_name"],
      status: json["status"],
      totalRespondent: json["total_respondent"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      questions: List<QuestionModel>.from(
          json["questions"].map((x) => QuestionModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "survey_name": surveyName,
    "status": status,
    "total_respondent": totalRespondent,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };

  Survey toEntity() {
    return Survey(
      id: id,
      surveyName: surveyName,
      status: status,
      totalRespondent: totalRespondent,
      createdAt: createdAt,
      updatedAt: updatedAt,
      questions: questions.map((question) => question.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    surveyName,
    status,
    totalRespondent,
    createdAt,
    updatedAt,
    questions,
  ];
}
