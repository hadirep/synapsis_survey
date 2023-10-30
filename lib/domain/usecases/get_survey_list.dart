import 'package:dartz/dartz.dart';
import 'package:synapsis_survey/common/failure.dart';
import 'package:synapsis_survey/domain/entities/survey.dart';
import 'package:synapsis_survey/domain/repositories/survey_repository.dart';

class GetSurveyList {
  final SurveyRepository repository;

  GetSurveyList(this.repository);

  Future<Either<Failure, List<Survey>>> execute() {
    return repository.getSurveyList();
  }
}