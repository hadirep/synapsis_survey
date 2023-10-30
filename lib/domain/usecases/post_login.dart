import 'package:dartz/dartz.dart';
import 'package:synapsis_survey/common/failure.dart';
import 'package:synapsis_survey/domain/entities/login.dart';
import 'package:synapsis_survey/domain/repositories/survey_repository.dart';

class PostLogin {
  final SurveyRepository repository;

  PostLogin(this.repository);

  Future<Either<Failure, Login>> execute(String email, String password) {
    return repository.postLogin(email, password);
  }
}