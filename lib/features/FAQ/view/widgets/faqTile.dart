import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/model/faqQuestion.dart';
import 'package:mindplex/routes/app_routes.dart';

import '../../controller/faqController.dart';
import '../../model/faqModel.dart';
// import "package:mindplex/utils/colors.dart";

class FaqTile extends StatelessWidget {
  final FaqQuestion faq;
  FaqTile({super.key, required this.faq});

  FaqController faqController = Get.find();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.faqAnswer, arguments: faq.slug);
          },
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: Colors.white70,
              ),
              SizedBox(width: 10),
              Container(
                width: screenWidth * 0.75,
                child: Text(faq.title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    )),
              )
            ],
          ),
        ),
        // if (faqController.currentIndex == faq.id)
        //   Row(
        //     children: [
        //       Container(
        //         padding: EdgeInsets.all(20),
        //         margin: EdgeInsets.all(5),
        //         decoration: BoxDecoration(
        //           color: Colors.blueAccent,
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         width: 300,
        //         child: Text(faq.answer,
        //             style: TextStyle(
        //               color: Colors.white70,
        //               fontSize: 16,
        //             )),
        //       )
        //     ],
        //   )
      ],
    );
  }
}
