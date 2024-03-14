import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqGroup.dart';
import "../../../../utils/colors.dart";

class FAQ extends StatelessWidget {
  FaqController faqController = Get.put(FaqController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: mainBackgroundColor,
      child: Column(
        children: [
          Container(
            color: ColorPrimaryDark,
            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: double.infinity,
                    height: 50,
                    // color: Colors.red,
                    child: Stack(alignment: Alignment.center, children: [
                      Positioned(
                          top: 0,
                          left: -10,
                          child: Container(
                            child: BackButton(
                              color: Colors.white70,
                            ),
                          )),
                      Text(
                        "FAQs",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      )
                    ])),
                SizedBox(
                  height: 20,
                ),
                Text("Ask us anything",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 20),
                Text("Have any question? We are here to assist you.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search here",
                            prefixIcon: Icon(Icons.search)))),
              ],
            ),
          ),
          Container(
            height: 400,
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(50, 30, 50, 20),
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(height: 60),
              itemBuilder: (context, index) => FaqGroup(
                faqGroup: faqController.faqGroups[index],
              ),
              itemCount: faqController.faqGroups.length,
            ),
          ),
        ],
      ),
    ));
  }
}
