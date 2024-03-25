import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqGroup.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqGroupLists.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqSearchResult.dart';
import 'package:mindplex/features/FAQ/view/widgets/blog_shimmer.dart';
// import 'package:mindplex/features/FAQ/services/FaqSerivces.dart';
// import 'package:mindplex/features/FAQ/view/widgets/FaqGroup.dart';
// import 'package:mindplex/features/FAQ/view/widgets/FaqSearchResult.dart';
import 'package:mindplex/features/FAQ/view/widgets/faqSearch.dart';
import 'package:mindplex/utils/status.dart';
import "../../../../../utils/colors.dart";

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
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                FaqSearch(),
                faqController.searchMode.value
                    ? FaqSearchResult()
                    : FaqGroupLists()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
