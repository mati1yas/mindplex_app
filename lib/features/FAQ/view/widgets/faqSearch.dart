import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mindplex/features/FAQ/controller/faqController.dart';
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
    return Container(
      color: ColorPrimaryDark,
      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
      height: screenHeight * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: double.infinity,
              height: 50,
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
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search here",
                    prefixIcon: Icon(Icons.search)),
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: (_) {
                  if (_controller.text == null || _controller.text.length < 3)
                    return;
                  faqController.searchFaq(_controller.text);
                },
              )),
        ],
      ),
    );
  }
}
