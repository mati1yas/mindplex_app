import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as ql;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mindplex/features/comment/controllers/comment_controller.dart';

class CustomCommentTextEditor extends StatelessWidget {
  final CommentController commentController;
  final bool showNumberList;
  final bool showBulletList;
  CustomCommentTextEditor(
      {super.key,
      required this.commentController,
      this.showNumberList = true,
      this.showBulletList = true});

  ql.QuillToolbarToggleStyleButtonOptions get getButtonOptions =>
      ql.QuillToolbarToggleStyleButtonOptions(
        // iconSize: 20,
        iconTheme: ql.QuillIconTheme(
          // iconButtonUnselectedData: ql.IconButtonData(color: Colors.white),
          iconButtonSelectedData:
              ql.IconButtonData(color: Color.fromARGB(255, 21, 180, 148)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                border: Border(
                    left: BorderSide(color: Colors.green),
                    right: BorderSide(color: Colors.green),
                    top: BorderSide(color: Colors.green))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: ql.QuillToolbar(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuillToolbarToggleStyleButton(
                          options: getButtonOptions,
                          controller: commentController.quillController,
                          attribute: Attribute.bold,
                        ),
                        QuillToolbarToggleStyleButton(
                          options: getButtonOptions,
                          controller: commentController.quillController,
                          attribute: Attribute.italic,
                        ),
                        QuillToolbarToggleStyleButton(
                          options: getButtonOptions,
                          controller: commentController.quillController,
                          attribute: Attribute.underline,
                        ),
                        if (showNumberList)
                          QuillToolbarToggleStyleButton(
                            options: getButtonOptions,
                            controller: commentController.quillController,
                            attribute: Attribute.ol,
                          ),
                        if (showBulletList)
                          QuillToolbarToggleStyleButton(
                            options: getButtonOptions,
                            controller: commentController.quillController,
                            attribute: Attribute.ul,
                          ),
                        QuillToolbarLinkStyleButton(
                            options: ql.QuillToolbarLinkStyleButtonOptions(
                              iconTheme: ql.QuillIconTheme(
                                  // iconButtonUnselectedData:
                                  //     ql.IconButtonData(color: Colors.white),
                                  ),
                            ),
                            controller: commentController.quillController),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      border: Border.all(color: Colors.green)),
                  child: ql.QuillEditor(
                    configurations: ql.QuillEditorConfigurations(
                      enableSelectionToolbar: false,
                      controller: commentController.quillController,
                      minHeight: 50,
                      maxHeight: 90,
                    ),
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
