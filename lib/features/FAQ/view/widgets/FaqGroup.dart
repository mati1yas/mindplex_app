import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/model/faqGroup.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqList.dart';

import 'faqTile.dart';

class FaqGroupCard extends StatelessWidget {
  FaqGroupCard({super.key, required this.faqGroup});
  final FaqGroup faqGroup;
  FaqController faqController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(
        Icons.wallet,
        size: 50,
        color: Colors.white70,
      ),
      Text(faqGroup.name,
          style: TextStyle(
            color: Color.fromRGBO(129, 193, 255, 1),
            fontSize: 20,
          )),
      SizedBox(
        height: 10,
      ),
      Obx(
        () => ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: faqController.viewMore.value == faqGroup.slug
              ? faqGroup.sub.length
              : faqGroup.sub[0].faqQuestions.length,
          itemBuilder: (context, index) {
            return faqController.viewMore.value == faqGroup.slug
                ? FqaList(faqList: faqGroup.sub[index])
                : FaqTile(faq: faqGroup.sub[0].faqQuestions[index]);
          },
        ),
      ),
      Container(
        width: 80,
        height: 30,
        alignment: Alignment.centerLeft,
        child: OutlinedButton(
          onPressed: () {
            faqController.toggleView(faqGroup.slug);
          },
          child: Obx(() => Text(
                faqController.viewMore.value == faqGroup.slug
                    ? "View less"
                    : "View more",
                style: TextStyle(color: Colors.red),
              )),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              side: BorderSide(color: Colors.red, width: 2)),
        ),
      )
    ]);
  }
}
