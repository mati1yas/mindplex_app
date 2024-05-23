import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqGroup.dart';
import 'package:mindplex/utils/status.dart';

class FaqGroupLists extends StatelessWidget {
  FaqGroupLists({super.key});
  FaqController faqController = Get.find();
  @override
  Widget build(BuildContext context) {
    faqController.loadFaq();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.65,
      child: Obx(
        () => faqController.status == Status.loading
            ? Center(child: CircularProgressIndicator())
            : faqController.status == Status.error
                ? Center(
                    child: Icon(Icons.error),
                  )
                : faqController.status == Status.success
                    ? ListView.separated(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 50),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 30),
                        itemBuilder: (context, index) => FaqGroupCard(
                          faqGroup: faqController.faqGroups[index],
                        ),
                        itemCount: faqController.faqGroups.length,
                      )
                    : Text("No result found"),
      ),
    );
  }
}
