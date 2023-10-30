import 'package:dartz/dartz.dart';
import 'package:synapsis_survey/common/failure.dart';
import 'package:synapsis_survey/domain/entities/login.dart';
import 'package:synapsis_survey/domain/entities/survey.dart';

abstract class SurveyRepository {
  Future<Either<Failure, Login>> postLogin(String email, String password);
  Future<Either<Failure, List<Survey>>> getSurveyList();
}