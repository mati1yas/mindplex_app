import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqAnswerWidget.dart';
import 'package:mindplex/features/FAQ/view/widgets/faq_top_bar_widget.dart';
import 'package:mindplex/utils/status.dart';
import "../../../../../utils/colors.dart";

class FaqAnswerPage extends StatelessWidget {
  FaqController faqController = Get.put(FaqController());
  final String slug = Get.arguments;
  @override
  Widget build(BuildContext context) {
    faqController.loadAnswer(slug);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      color: mainBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // FaqSearch(),
            Container(
              color: ColorPrimaryDark,
              padding: EdgeInsets.fromLTRB(0, 30, 10, 10),
              height: 70,
              child: FAQTopBarWidget(screenWidth: screenWidth),
            ),
            Container(
              width: double.infinity,
              height: screenHeight * 0.9,
              child: Obx(
                () => faqController.statusAnswer == Status.loading
                    ? Center(child: CircularProgressIndicator())
                    : faqController.statusAnswer == Status.error
                        ? Center(
                            child: Icon(Icons.error),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.all(25),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemBuilder: (context, index) => FaqAnswerWidget(
                              faqAnswer: faqController.faqAnswers[index],
                            ),
                            itemCount: faqController.faqAnswers.length,
                          ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
