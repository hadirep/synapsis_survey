import 'package:equatable/equatable.dart';
import 'package:synapsis_survey/domain/entities/question.dart';

class QuestionModel extends Equatable {
  const QuestionModel({
    required this.questionName,
    required this.inputType,
    required this.questionId,
  });

  final String questionName;
  final String inputType;
  final String questionId;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    questionName: json["question_name"],
    inputType: json["input_type"],
    questionId: json["question_id"],
  );

  Map<String, dynamic> toJson() => {
    "question_name": questionName,
    "input_type": inputType,
    "question_id": questionId,
  };

  Question toEntity() {
    return Question(
      questionName: questionName,
      inputType: inputType,
      questionId: questionId,
    );
  }

  @override
  List<Object?> get props => [
    questionName,
    inputType,
    questionId,
  ];
}