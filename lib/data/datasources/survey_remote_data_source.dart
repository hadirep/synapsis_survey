import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:synapsis_survey/common/exception.dart';
import 'package:synapsis_survey/data/models/login_model.dart';
import 'package:synapsis_survey/data/models/survey_model.dart';
import 'package:synapsis_survey/data/models/survey_response.dart';

abstract class SurveyRemoteDataSource {
  Future<LoginModel> postLogin(String email, String password);
  Future<List<SurveyModel>> getSurveyList();
}

class SurveyRemoteDataSourceImpl implements SurveyRemoteDataSource{
  static const String _baseUrl = 'https://panel-demo.obsight.com';
  static const String _api = 'api';
  static const String _login = 'login';
  static const String _survey = 'survey';
  static const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsZXZlbCI6IjMiLCJleHAiOjE2OTg0MTQ1MDIsImlzcyI6InV5cDFmZG9iaWMifQ.-f1O1cD6-qCMZMWNuBMQ8-FpoR35iRmaoJL73Ot9exA';

  final http.Client client;

  SurveyRemoteDataSourceImpl({required this.client});

  @override
  Future<LoginModel> postLogin(String email, String password) async {
    final response = await client.post(Uri.parse('$_baseUrl/$_api/$_login'),
      headers: {
        'Cookie': 'token=$token',
      },
      body:{
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return LoginModel.fromJson(jsonData);
    } else if(response.statusCode == 401) {
      throw AuthenticationException("Authentication failed");
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SurveyModel>> getSurveyList() async {
    final response = await client.get(Uri.parse('$_baseUrl/$_api/$_survey'),
      headers: {
        'Cookie': 'token=$token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return SurveyResponse.fromJson(jsonData).data;
    } else {
      throw ServerException();
    }
  }
}