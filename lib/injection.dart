import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:synapsis_survey/data/datasources/survey_remote_data_source.dart';
import 'package:synapsis_survey/data/repositories/survey_repository_impl.dart';
import 'package:synapsis_survey/domain/repositories/survey_repository.dart';
import 'package:synapsis_survey/domain/usecases/get_survey_list.dart';
import 'package:synapsis_survey/domain/usecases/post_login.dart';
import 'package:synapsis_survey/presentation/provider/login_notifier.dart';
import 'package:synapsis_survey/presentation/provider/survey_answer_notifier.dart';
import 'package:synapsis_survey/presentation/provider/survey_list_notifier.dart';

final locator = GetIt.instance;

void init() {
  //provider
  locator.registerFactory(() => LoginNotifier());
  locator.registerFactory(
    () => SurveyListNotifier(
        getSurveyList: locator(),
    ),
  );
  locator.registerFactory(() => SurveyAnswerNotifier());

  //use case
  locator.registerLazySingleton(() => PostLogin(locator()));
  locator.registerLazySingleton(() => GetSurveyList(locator()));

  //repository
  locator.registerLazySingleton<SurveyRepository>(
    () => SurveyRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  //data sources
  locator.registerLazySingleton<SurveyRemoteDataSource>(
    () => SurveyRemoteDataSourceImpl(
      client: locator(),
    ),
  );

  // external
  locator.registerLazySingleton(() => http.Client());
}
