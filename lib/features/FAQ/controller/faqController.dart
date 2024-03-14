import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/FAQ/model/FaqList.dart';
import 'package:mindplex/features/FAQ/model/faqGroups.dart';
import 'package:mindplex/features/FAQ/model/faqModel.dart';

class FaqController extends GetxController {
  RxInt currentIndex = (-1).obs;
  RxInt viewMore = (-1).obs;

  final faqGroups = [
    FaqGroupModel(
        title: "General",
        faqLists: [
          FaqListModel(
              title: "getStarted",
              faqs: [
                Faq(
                    question: "Using Mindplex",
                    id: 1,
                    answer:
                        "You can use Mindplex by following the steps below: \n1. Create an account \n2. Verify your account \n3. Start using Mindplex"),
                Faq(
                    question: "How to Create Mindplex Account",
                    id: 2,
                    answer:
                        "You can create a Mindplex account by following the steps below: \n1. Visit the Mindplex website \n2. Click on the 'Create Account' button \n3. Fill in the required details \n4. Click on the 'Create Account' button")
              ],
              id: 1),
          FaqListModel(
              title: "login",
              faqs: [
                Faq(
                    question: "Using Mindplex",
                    id: 3,
                    answer:
                        "You can use Mindplex by following the steps below: \n1. Create an account \n2. Verify your account \n3. Start using Mindplex"),
                Faq(
                    question: "How to Create Mindplex Account",
                    id: 4,
                    answer:
                        "You can create a Mindplex account by following the steps below: \n1. Visit the Mindplex website \n2. Click on the 'Create Account' button \n3. Fill in the required details \n4. Click on the 'Create Account' button"),
                Faq(
                    question: "Mindplex tokens",
                    id: 5,
                    answer:
                        "Mindplex tokens are the official currency of Mindplex. You can use them to buy products and services on the Mindplex platform."),
                Faq(
                    question: "MPXR and how to use it",
                    id: 6,
                    answer:
                        "MPXR is a digital asset that can be used to buy products and services on the Mindplex platform. You can use it by following the steps below: \n1. Buy MPXR \n2. Use MPXR to buy products and services on the Mindplex platform"),
              ],
              id: 3)
        ],
        id: 2,
        icon: Icon(Icons.masks_rounded, size: 50, color: Colors.white70)),
    FaqGroupModel(
        title: "Tokenomics",
        faqLists: [
          FaqListModel(
              title: "Tokenomics",
              faqs: [
                Faq(
                    question: "Mindplex tokens",
                    id: 7,
                    answer:
                        "Mindplex tokens are the official currency of Mindplex. You can use them to buy products and services on the Mindplex platform."),
                Faq(
                    question: "MPXR and how to use it",
                    id: 8,
                    answer:
                        "MPXR is a digital asset that can be used to buy products and services on the Mindplex platform. You can use it by following the steps below: \n1. Buy MPXR \n2. Use MPXR to buy products and services on the Mindplex platform")
              ],
              id: 2)
        ],
        id: 3,
        icon: Icon(Icons.hail, size: 50, color: Colors.white70)),
    FaqGroupModel(
        title: "Mindplex Recommendation",
        faqLists: [
          FaqListModel(
              title: "Tokenomics",
              faqs: [
                Faq(
                    question: "Mindplex tokens",
                    id: 9,
                    answer:
                        "Mindplex tokens are the official currency of Mindplex. You can use them to buy products and services on the Mindplex platform."),
                Faq(
                    question: "MPXR and how to use it",
                    id: 10,
                    answer:
                        "MPXR is a digital asset that can be used to buy products and services on the Mindplex platform. You can use it by following the steps below: \n1. Buy MPXR \n2. Use MPXR to buy products and services on the Mindplex platform")
              ],
              id: 2)
        ],
        id: 4,
        icon: Icon(Icons.ac_unit_rounded, size: 50, color: Colors.white70)),
  ];

  void changeIndex(int index) {
    if (currentIndex.value == index) {
      currentIndex.value = -1;
      return;
    }
    currentIndex(index);
  }

  void toggleView(int index) {
    if (viewMore.value == index) {
      viewMore.value = -1;
      return;
    }
    viewMore(index);
  }
}
