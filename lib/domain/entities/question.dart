import 'package:equatable/equatable.dart';

class Question extends Equatable {
  const Question({
    required this.questionName,
    required this.inputType,
    required this.questionId,
  });

  final String questionName;
  final String inputType;
  final String questionId;

  @override
  List<Object?> get props => [
    questionName,
    inputType,
    questionId,
  ];
}
