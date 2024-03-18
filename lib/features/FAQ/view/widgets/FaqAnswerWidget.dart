import 'package:flutter/cupertino.dart';
import 'package:mindplex/features/FAQ/model/Content.dart';
import 'package:mindplex/features/FAQ/model/FaqAnswer.dart';
import 'package:mindplex/features/FAQ/view/widgets/FaqContentList.dart';

class FaqAnswerWidget extends StatelessWidget {
  const FaqAnswerWidget({super.key, required this.faqAnswer});
  final FaqAnswer faqAnswer;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          faqAnswer.title,
          style:
              TextStyle(color: Color.fromRGBO(129, 193, 255, 1), fontSize: 18),
        ),
        FaqContentList(answerContentList: faqAnswer.contents)
      ],
    );
  }
}
