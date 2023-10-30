import 'package:equatable/equatable.dart';
import 'package:synapsis_survey/domain/entities/question.dart';

class Survey extends Equatable {
  const Survey({
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
  final List<Question> questions;

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