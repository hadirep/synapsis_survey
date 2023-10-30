import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synapsis_survey/common/utils.dart';
import 'package:synapsis_survey/presentation/pages/login_page.dart';
import 'package:synapsis_survey/presentation/pages/survey_question_page.dart';
import 'package:synapsis_survey/presentation/pages/survey_page.dart';
import 'package:synapsis_survey/presentation/provider/login_notifier.dart';
import 'package:synapsis_survey/presentation/provider/survey_answer_notifier.dart';
import 'package:synapsis_survey/presentation/provider/survey_list_notifier.dart';
import 'package:synapsis_survey/injection.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<LoginNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SurveyListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SurveyAnswerNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Synapsis Survey',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch(settings.name) {
            case '/login_page':
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case SurveyPage.routeName:
              return CupertinoPageRoute(builder: (_) => const SurveyPage());
            case SurveyQuestionPage.routeName:
              return CupertinoPageRoute(builder: (_) => const SurveyQuestionPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
