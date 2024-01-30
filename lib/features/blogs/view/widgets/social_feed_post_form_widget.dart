import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/controllers/DraftedPostsController.dart';

class SocialFeedForm extends StatelessWidget {
  const SocialFeedForm({
    super.key,
    required this.draftedPostsController,
    required this.editingDraft,
  });
  final bool editingDraft;
  final DraftedPostsController draftedPostsController;

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Form(
            key: formkey,
            child: TextFormField(
              validator: (value) {
                if (value != null &&
                    value.isEmpty &&
                    draftedPostsController.selectedImages.isEmpty) {
                  return "Empty Post";
                }

                return null;
              },
              onChanged: (value) {
                draftedPostsController.textEditingController.value.text = value;
              },
              style: TextStyle(color: Colors.white), // Set the text color

              controller: draftedPostsController.textEditingController.value,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 4, 28, 49),
                  border: OutlineInputBorder()),
              maxLines: 2,
              minLines: 1,
            ),
          ),
          Obx(
            () => draftedPostsController.selectedImages.length == 0
                ? SizedBox.shrink()
                : Container(
                    height: 85,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: draftedPostsController.selectedImages.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(draftedPostsController
                                      .selectedImages[index].path),
                                  width: 85,
                                  height: 85,
                                  fit: BoxFit.fill,
                                ),
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: GestureDetector(
                                      onTap: () {
                                        draftedPostsController
                                            .removeSelectedImage(
                                                photoIndex: index);
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      )),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icon(
                  //   Icons.headphones_outlined,
                  //   color: Colors.green,
                  // ),
                  // Icon(
                  //   Icons.video_camera_back_outlined,
                  //   color: Colors.red[200],
                  // ),
                  GestureDetector(
                    onTap: () {
                      draftedPostsController.pickImages();
                    },
                    child: Icon(
                      Icons.image,
                      size: 45,
                      color: Color.fromARGB(255, 5, 175, 223),
                    ),
                  )
                ],
              ),
              Spacer(),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          if (editingDraft == true) {
                            draftedPostsController.updateDraft();
                          } else {
                            draftedPostsController.createNewDraft();
                          }
                        }
                      },
                      child: Obx(() =>
                          draftedPostsController.updatingDraft.value == true ||
                                  draftedPostsController.savingDraft.value ==
                                      true
                              ? Container(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ))
                              : Text(editingDraft == true
                                  ? "Update Draft"
                                  : "Save Draft"))),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 5, 209, 224))),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          if (editingDraft == true) {
                            draftedPostsController.postDraftToSocial();
                          } else {
                            draftedPostsController.postNewToSocial();
                          }
                        }
                      },
                      child: Obx(
                          () => draftedPostsController.makingPost.value == true
                              ? Container(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ))
                              : Text("Post")))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
