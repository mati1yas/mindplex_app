import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/model/Content.dart';

class FaqContent extends StatelessWidget {
  final HtmlContent content;
  FaqContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.type == "li")
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.circle, size: 10, color: Colors.white70)),
        if (content.type == "li") SizedBox(width: 10),
        if (content.content.length == 0 && content.type == "table")
          SizedBox(width: 10),
        if (content.content.length > 0 && content.type == "table")
          Container(
            width: screenWidth * 0.82,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 2000,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: content.content.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white70,
                  ),
                  itemBuilder: (context, index) {
                    return Row(
                      children: List.generate(
                        content.content[index].length,
                        (i) => Container(
                          width: 300,
                          child: Text(
                            content.content[index][i],
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

        //       child: DataTable(
        //         headingRowHeight: 50, // Optional: Set the heading row height
        //         // dataRowHeight: 70,
        //         columns: content.content[0]
        //             .map<DataColumn>((e) => DataColumn(
        //                     // Allow the column to expand
        //                     label: Text(
        //                   e,
        //                   // overflow: TextOverflow.ellipsis,
        //                 )))
        //             .toList(),
        //         rows: List<DataRow>.generate(
        //             content.content.length - 1,
        //             (index) => DataRow(
        //                 cells: content.content[index + 1]
        //                     .map<DataCell>((e) => DataCell(
        //                           Container(
        //                             // Wrap LayoutBuilder with Container and provide fixed width
        //                             width:
        //                                 100, // Set a fixed width or provide appropriate width
        //                             child: LayoutBuilder(
        //                               builder: (context, constraints) {
        //                                 return SizedBox(
        //                                   height: constraints.maxHeight,
        //                                   child: Text(
        //                                     e,
        //                                     overflow: TextOverflow.visible,
        //                                   ),
        //                                 );
        //                               },
        //                             ),
        //                           ),
        //                         ))
        //                     .toList())),
        //       ),
        //     ),
        //   ),
        // ),
        if (content.type == "p" || content.type == "li")
          Container(
            // width:
            //     content.type == "li" ? screenWidth * 0.82 : screenWidth * 0.82,
            child: Expanded(
              child: Html(
                data: content.content,
                style: {
                  "body": Style(
                    color: Colors.white70,
                    fontSize: FontSize(16),
                    margin: Margins.zero,
                    lineHeight: LineHeight.number(1.4),
                  )
                },
              ),
            ),
          )
      ],
    );
  }
}
