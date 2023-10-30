import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:synapsis_survey/common/exception.dart';
import 'package:synapsis_survey/common/failure.dart';
import 'package:synapsis_survey/data/datasources/survey_remote_data_source.dart';
import 'package:synapsis_survey/domain/entities/login.dart';
import 'package:synapsis_survey/domain/entities/survey.dart';
import 'package:synapsis_survey/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyRemoteDataSource remoteDataSource;

  SurveyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Login>> postLogin(String email, String password) async {
    try {
      final result = await remoteDataSource.postLogin(email, password);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Survey>>> getSurveyList() async {
    try {
      final result = await remoteDataSource.getSurveyList();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}