import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synapsis_survey/common/state_enum.dart';
import 'package:synapsis_survey/common/styles.dart';
import 'package:synapsis_survey/domain/entities/survey.dart';
import 'package:synapsis_survey/presentation/pages/login_page.dart';
import 'package:synapsis_survey/presentation/pages/survey_question_page.dart';
import 'package:synapsis_survey/presentation/provider/login_notifier.dart';
import 'package:synapsis_survey/presentation/provider/survey_list_notifier.dart';
import 'package:intl/intl.dart';

class SurveyPage extends StatefulWidget {
  static const String routeName = 'survey-page';

  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SurveyListNotifier>(context, listen: false)
          .fetchSurveyList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SurveyListNotifier>(builder: (context, data, child) {
        final state = data.state;
        if (state == RequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: secondaryColor),
          );
        } else if (state == RequestState.hasData) {
          return SurveyList(data.surveyList);
        } else {
          return Center(child: Text(data.message));
        }
      },
      ),
    );
  }
}

class SurveyList extends StatelessWidget {
  final List<Survey> survey;
  const SurveyList(this.survey, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: survey.length,
      itemBuilder: (context, index) {
        final surveyList = survey[index];
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Halaman Survei",
                        style: myTextTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        final loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
                        loginNotifier.logout();

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: textColor,
                      ),
                      color: primaryColor
                  ),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                        leading: Image.asset(
                          "assets/icon.png",
                        ),
                        title: Text(
                          surveyList.surveyName,
                          style: myTextTheme.titleMedium,
                        ),
                        subtitle: Text(
                          "Created At: ${DateFormat('dd MMM yyyy').format(surveyList.createdAt)}",
                          style: myTextTheme.titleSmall?.copyWith(color: createdTextColor),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            SurveyQuestionPage.routeName,
                            arguments: surveyList.questions,
                          );
                        }
                    ),
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}
