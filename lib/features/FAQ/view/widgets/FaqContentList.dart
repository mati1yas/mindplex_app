import 'package:flutter/cupertino.dart';
import 'package:mindplex/features/FAQ/model/Content.dart';

import 'package:mindplex/features/FAQ/view/widgets/FaqContent.dart';

class FaqContentList extends StatelessWidget {
  const FaqContentList({super.key, required this.answerContentList});
  final List<HtmlContent> answerContentList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: answerContentList.length,
      itemBuilder: (context, index) {
        return FaqContent(content: answerContentList[index]);
      },
    );
  }
}
