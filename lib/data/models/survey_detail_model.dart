class SurveyDetailModel {
  final int code;
  final bool status;
  final String message;
  final SurveyDetailData data;

  SurveyDetailModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory SurveyDetailModel.fromJson(Map<String, dynamic> json) => SurveyDetailModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: SurveyDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class SurveyDetailData {
  final String id;
  final String surveyName;
  final int status;
  final int totalRespondent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic questions;

  SurveyDetailData({
    required this.id,
    required this.surveyName,
    required this.status,
    required this.totalRespondent,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory SurveyDetailData.fromJson(Map<String, dynamic> json) => SurveyDetailData(
    id: json["id"],
    surveyName: json["survey_name"],
    status: json["status"],
    totalRespondent: json["total_respondent"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    questions: json["questions"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "survey_name": surveyName,
    "status": status,
    "total_respondent": totalRespondent,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "questions": questions,
  };
}
