import 'package:flutter/cupertino.dart';
import 'package:mindplex/features/FAQ/model/FaqList.dart';

import 'faqTile.dart';

class FqaList extends StatelessWidget {
  const FqaList({super.key, required this.faqList});
  final FaqListModel faqList;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(faqList.title,
          style: TextStyle(
            color: Color.fromRGBO(129, 193, 255, 1),
            fontSize: 16,
          )),
      ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: faqList.faqs.length,
        itemBuilder: (context, index) {
          return FaqTile(faq: faqList.faqs[index]);
        },
      ),
    ]);
  }
}
