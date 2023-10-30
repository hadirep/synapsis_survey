import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:synapsis_survey/common/state_enum.dart';
import 'package:synapsis_survey/common/styles.dart';
import 'package:synapsis_survey/domain/entities/question.dart';
import 'package:synapsis_survey/domain/entities/survey.dart';
import 'package:synapsis_survey/presentation/provider/survey_answer_notifier.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import '../provider/survey_list_notifier.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class SurveyQuestionPage extends StatefulWidget {
  static const String routeName = 'survey-test-page';

  const SurveyQuestionPage({Key? key}) : super(key: key);

  @override
  State<SurveyQuestionPage> createState() => _SurveyQuestionPageState();
}

class _SurveyQuestionPageState extends State<SurveyQuestionPage> {

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
    return  Scaffold(
      body: Consumer<SurveyListNotifier>(builder: (context, data, child) {
        final state = data.state;
        if (state == RequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(color: secondaryColor),
          );
        } else if (state == RequestState.hasData) {
          return ListView.builder(
            itemCount: data.surveyList.length,
            itemBuilder: (context, index) {
              final surveyData = data.surveyList[index];
              return SurveyQuestion(data.surveyList, surveyData);
            },
          );
        } else {
          return Center(child: Text(data.message));
        }
      },
      ),
    );
  }
}

class SurveyQuestion extends StatefulWidget {
  final List<Survey> survey;
  final Survey surveyData;
  const SurveyQuestion(this.survey, this.surveyData, {super.key});

  @override
  State<SurveyQuestion> createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  int currentQuestionIndex = 0;
  int currentPage = 0;
  final pageController = PageController(viewportFraction: 0.8);
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _pageController = PageController();
  final List answerList = const ["tertarik", "biasa", "sangat tertarik", "biasa aja"];
  Map<int, SurveyAnswerNotifier> answerNotifiers = {};

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page?.round() ?? 0;
      });
    });

    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page?.round() ?? 0;
    });

    for (int i = 0; i < widget.surveyData.questions.length; i++) {
      final answerNotifier = SurveyAnswerNotifier();
      answerNotifiers[i] = answerNotifier;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: secondaryColor,
                          ),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            "45 Second Left",
                            style: myTextTheme.titleMedium?.copyWith(color: secondaryColor),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blackColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size(60, 35),
                        ),
                        onPressed: () async {
                          await showTopModalSheet<String?>(context, buildDialog(context));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icon_task.png', height: 20, width: 20),
                            const SizedBox(width: 3),
                            Text(
                              "${_currentPageNotifier.value + 1}/${(widget.surveyData.questions.length / 20).ceil()}",
                              style: myTextTheme.titleSmall?.copyWith(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.surveyData.surveyName,
                      style: myTextTheme.titleMedium?.copyWith(color: blackColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${currentQuestionIndex + 1}. ${widget.surveyData.questions[currentQuestionIndex].questionName}",
                      style: myTextTheme.titleMedium?.copyWith(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: dividerColor,
              width: double.infinity,
              height: 15,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Answer",
                  style: myTextTheme.titleMedium?.copyWith(color: blackColor),
                ),
              ),
            ),
            const Divider(color: dividerColor),
            Consumer<SurveyAnswerNotifier>(
              builder: (context, data, _) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: answerList.length,
                    itemBuilder: (context, index) {
                      final answer = answerList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: answer,
                              groupValue: answerNotifiers[currentQuestionIndex]?.answer,
                              onChanged: (String? value) {
                                setState(() {
                                  answerNotifiers[currentQuestionIndex]?.setAnswer(value!);
                                });
                                _showSnackBar("$answer telah di pilih");
                              },
                            ),
                            Text(answer),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 600),
          child: Row(
            children: [
              Expanded(
                flex: 45,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: secondaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    if (currentQuestionIndex > 0) {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    }
                  },
                  child: Text(
                    "Back",
                    style: myTextTheme.labelLarge?.copyWith(color: secondaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    if (currentQuestionIndex < widget.surveyData.questions.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                      });
                    }
                  },
                  child: Text(
                    "Next",
                    style: myTextTheme.labelLarge?.copyWith(color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SafeArea buildDialog(context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Survei Question',
              style: myTextTheme.titleMedium?.copyWith(color: blackColor),
            ),
          ),
          const Divider(color: textColor),
          SizedBox(
            height: 310,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: (widget.surveyData.questions.length / 20).ceil(),
                    itemBuilder: (context, pageIndex) {
                      final startQuestionNumber = pageIndex * 20;
                      final endQuestionNumber = (pageIndex + 1) * 20;
                      final int questionCount = widget.surveyData.questions.length;
                      final List<Question> visibleQuestions = [];
                      for (int i = startQuestionNumber; i < endQuestionNumber && i < questionCount; i++) {
                        visibleQuestions.add(widget.surveyData.questions[i]);
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        itemBuilder: (context, questionIndex) {
                          final questionNumber = startQuestionNumber + questionIndex;
                          bool isAnswered = answerNotifiers[questionNumber]?.answer != null;

                          Color backgroundColor;
                          Color textColor;
                          Color borderColor;

                          if (questionNumber < endQuestionNumber && questionNumber < widget.surveyData.questions.length) {
                            if (questionNumber == currentQuestionIndex) {
                              backgroundColor = buttonColor;
                              textColor = secondaryColor;
                              borderColor = secondaryColor;
                            } else if (isAnswered) {
                              backgroundColor = secondaryColor;
                              textColor = primaryColor;
                              borderColor = secondaryColor;
                            } else if (!isAnswered) {
                              backgroundColor = primaryColor;
                              textColor = blackColor;
                              borderColor = blackColor;
                            } else {
                              backgroundColor = primaryColor;
                              textColor = blackColor;
                              borderColor = blackColor;
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                pageIndex,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                              setState(() {
                                currentQuestionIndex = questionNumber;
                              });
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: backgroundColor,
                                border: Border.all(color: borderColor, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  '${questionNumber + 1}',
                                  style: myTextTheme.titleSmall?.copyWith(color: textColor),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CirclePageIndicator(
                    currentPageNotifier: _currentPageNotifier,
                    itemCount: (widget.surveyData.questions.length / 20).ceil(),
                    selectedDotColor: secondaryColor,
                    dotColor: indicatorColor,
                    onPageSelected: (int pageIndex) {
                      _pageController.animateToPage(
                        pageIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String errorMessage) {
    final snackBar = SnackBar(content: Text(errorMessage));
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(snackBar);
  }
}
