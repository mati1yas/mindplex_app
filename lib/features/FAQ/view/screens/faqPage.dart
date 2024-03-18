import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/services/FaqSerivces.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqGroup.dart';
import 'package:mindplex/features/FAQ/view/widgets/faqSearch.dart';
import 'package:mindplex/utils/status.dart';
import "../../../../utils/colors.dart";

class FAQ extends StatelessWidget {
  FaqController faqController = Get.put(FaqController());
  @override
  Widget build(BuildContext context) {
    faqController.loadFaq();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      color: mainBackgroundColor,
      child: Column(
        children: [
          FaqSearch(),
          Container(
            height: screenHeight * 0.65,
            child: Obx(
              () => faqController.status == Status.loading
                  ? Center(child: CircularProgressIndicator())
                  : faqController.status == Status.error
                      ? Center(
                          child: Icon(Icons.error),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 60),
                          itemBuilder: (context, index) => FaqGroupCard(
                            faqGroup: faqController.faqGroups[index],
                          ),
                          itemCount: faqController.faqGroups.length,
                        ),
            ),
          ),
        ],
      ),
    ));
  }
}
