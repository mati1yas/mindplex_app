import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/model/FaqList.dart';
import 'package:mindplex/features/FAQ/model/faqGroups.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqList.dart';

import 'faqTile.dart';

class FaqGroup extends StatelessWidget {
  FaqGroup({super.key, required this.faqGroup});
  final FaqGroupModel faqGroup;
  FaqController faqController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      faqGroup.icon,
      Text(faqGroup.title,
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
          itemCount: faqController.viewMore.value == faqGroup.id
              ? faqGroup.faqLists.length
              : faqGroup.faqLists[0].faqs.length,
          itemBuilder: (context, index) {
            return faqController.viewMore.value == faqGroup.id
                ? FqaList(faqList: faqGroup.faqLists[index])
                : FaqTile(faq: faqGroup.faqLists[0].faqs[index]);
          },
        ),
      ),
      Container(
        width: 80,
        height: 30,
        alignment: Alignment.centerLeft,
        child: OutlinedButton(
          onPressed: () {
            faqController.toggleView(faqGroup.id);
          },
          child: Obx(() => Text(
                faqController.viewMore.value == faqGroup.id
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
