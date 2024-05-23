import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
import 'package:mindplex/features/FAQ/view/widgets/faq_top_bar_widget.dart';
import 'package:mindplex/utils/colors.dart';

class FaqSearch extends StatelessWidget {
  FaqSearch({super.key});
  TextEditingController _controller = TextEditingController();
  FaqController faqController = Get.find();
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        faqController.changeSearchMode(true);
      }
    });
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: ColorPrimaryDark,
      padding: EdgeInsets.only(top: 30),
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: double.infinity,
              height: 50,
              child: FAQTopBarWidget(screenWidth: screenWidth)),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
            child: Column(
              children: [
                Text(
                  "Ask us anything",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text("Have any question? We are here to assist you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search here",
                          prefixIcon: Icon(Icons.search)),
                      controller: _controller,
                      focusNode: _focusNode,
                      onSubmitted: (_) {
                        if (_controller.text == null ||
                            _controller.text.length < 3) return;
                        faqController.searchFaq(_controller.text);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
