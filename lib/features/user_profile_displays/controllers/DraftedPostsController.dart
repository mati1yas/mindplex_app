import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import './BlogsController.dart' as localBlogsController;

class DraftedPostsController extends localBlogsController.BlogsController {
  RxBool editingSocialPostDraft = false.obs;
  RxBool updatingDraft = false.obs;
  RxBool savingDraft = false.obs;
  RxBool makingPost = false.obs;
  RxBool deletingDraft = false.obs;
  Rx<Blog> beingEditeDraftBlog = Blog().obs;

  Rx<TextEditingController> textEditingController = TextEditingController().obs;

  BlogsController blogsController = Get.find();
  PageNavigationController pageNavigationController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<List<Blog>> fetchApi() async {
    List<Blog> res = await profileService.getDraftPosts(page: blogPage.value);
    return res;
  }

  Future<void> handleDraftEditing(
      {required Blog draftedBlog,
      required BlogsController blogsController,
      required PageNavigationController pageNavigationController}) async {
    editingSocialPostDraft.value = true;
    beingEditeDraftBlog.value = draftedBlog;
    blogsController.loadContents("social", "all");
    textEditingController.value.text = beingEditeDraftBlog.value.content!
        .map((e) => e.content)
        .toList()
        .join('\n');
    Get.back();
    pageNavigationController.navigatePage(0);
  }

  Future<void> createNewDraft() async {
    try {
      savingDraft.value = true;
      final postContent = extractPostContentFromTextFieldEditor();

      Future.delayed(Duration(seconds: 3));
      await profileService.createNewDraft(postContent: postContent);
      savingDraft.value = false;
    } catch (e) {
      print(e);
    }
    savingDraft.value = false;
  }

  Future<void> updateDraft() async {
    try {
      updatingDraft.value = true;
      final draftId = extractDaftId();
      final postContent = extractPostContentFromTextFieldEditor();

      await profileService.updateDraft(
          draftId: draftId, postContent: postContent);

      updatingDraft.value = false;
    } catch (e) {
      print(e);
    }
    updatingDraft.value = false;
  }

  Future<void> postDraftToSocial() async {
    try {
      makingPost.value = true;
      final draftId = extractDaftId();
      final postContent = extractPostContentFromTextFieldEditor();
      await profileService.postDraftToSocial(
          draftId: draftId, postContent: postContent);
      makingPost.value = false;
      resetDrafting();
      blogsController.loadContents('social', 'all');
    } catch (e) {}
    makingPost.value = false;
  }

  Future<void> postNewToSocial() async {
    try {
      makingPost.value = true;
      final postContent = extractPostContentFromTextFieldEditor();
      await profileService.postNewToSocial(postContent: postContent);
      makingPost.value = false;
      resetDrafting();
      blogsController.loadContents('social', 'all');
    } catch (e) {}
    makingPost.value = false;
  }

  Future<void> deleteDraft({required Blog blog}) async {
    try {
      deletingDraft.value = true;
      beingEditeDraftBlog.value = blog;
      final draftId = extractDaftId();
      await profileService.deleteDraft(draftId: draftId);
      deletingDraft.value = true;
    } catch (e) {}
    deletingDraft.value = true;
  }

//  HELPER FUNTIONS BELOW
  String extractPostContentFromTextFieldEditor() {
    final lines = textEditingController.value.text.split('\n');
    final postContent = lines.map((line) => '<p>$line</p>').join('');

    return postContent;
  }

  String extractDaftId() {
    var url = beingEditeDraftBlog.value.url ?? "";
    RegExp regex = RegExp(r'p=(\d+)');

    Match? match = regex.firstMatch(url);

    if (match != null && match.groupCount > 0) {
      String draftId = match.group(1)!;
      // return int.parse(postIdString);

      return draftId;
    }

    return "";
  }

  Future<void> resetDrafting() async {
    editingSocialPostDraft.value = false;
    textEditingController.value.text = '';
    beingEditeDraftBlog.value = Blog();
  }
}
