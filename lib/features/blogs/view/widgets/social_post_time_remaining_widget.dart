import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';

class PostTimeRemaining extends StatelessWidget {
  PostTimeRemaining({
    super.key,
    required this.blog,
  });

  final Blog blog;

  BlogsController blogsController = Get.find();

  double calculateNeededMpxrToAvoidDeletion() {
    double currentRep =
        blog.reputation.value != null ? blog.reputation.value!.postRep! : 0.0;

    double needed = double.parse(
            blogsController.socialFeedSetting.value.minRequiredMpxr ?? "0.0") -
        currentRep;

    if (needed < 0.0) {
      return 0.0;
    }
    return needed;
  }

  @override
  Widget build(BuildContext context) {
    double neededMpxrtoAvoidDeletion = calculateNeededMpxrToAvoidDeletion();
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(children: [
                Expanded(
                    child: Text(
                        "Current post Reputation: ${blog.reputation.value != null && blog.reputation.value!.postRep != null ? blog.reputation.value!.postRep!.toStringAsFixed(5) : '  -'}"))
              ]),
              Row(children: [
                Expanded(
                    child: Text(
                        "Post needs ${neededMpxrtoAvoidDeletion.toStringAsFixed(5)} MPXR to avoid auto deletion."))
              ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'The post will be deleted after:',
                    ),
                  ),

                  // adding extra 3 hours bse there is time zone difference .
                  CountDownText(
                    due: DateTime.parse(blog.publishedTimestamp!)
                        .add(Duration(
                            hours: int.parse(blogsController.socialFeedSetting
                                    .value.timeBeforeDeletion ??
                                "0")))
                        .add(Duration(hours: 3)),

                    finishedText: "Done",
                    showLabel: true,
                    // longDateName: true,
                    daysTextShort: " d ",
                    hoursTextShort: " h ",
                    minutesTextShort: " min ",
                    secondsTextShort: " s ",
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Dismis",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
