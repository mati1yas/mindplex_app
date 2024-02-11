import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import 'package:mindplex/features/user_profile_displays/models/picked_social_photo_model.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/status.dart';

// class BookmarksController extends BlogsController {
class DraftedPostsController extends GetxController {
  RxBool editingSocialPostDraft = false.obs;
  RxBool preparingContentForEdition = false.obs;

  RxBool updatingDraft = false.obs;
  RxBool savingDraft = false.obs;
  RxBool makingPost = false.obs;
  RxBool deletingDraft = false.obs;
  Rx<Blog> beingEditeDraftBlog = Blog().obs;
  RxInt beingDeletedDaftIndex = (-1).obs;
  RxInt beingEditedDaftIndex = (-1).obs;

  Rx<TextEditingController> textEditingController = TextEditingController().obs;

  BlogsController blogsController = Get.find();
  PageNavigationController pageNavigationController = Get.find();

  RxList<Blog> blogs = <Blog>[].obs;
  Rx<Status> status = Status.unknown.obs;
  RxString errorMessage = "Something is very wrong!".obs;
  ScrollController draftScorllController = ScrollController();
  RxBool isReachedEndOfList = false.obs;
  RxInt blogPage = 1.obs;
  ProfileServices profileService = ProfileServices();

  RxList<SelectedImage> selectedImages = <SelectedImage>[].obs;

  @override
  void onInit() {
    super.onInit();
    draftScorllController.addListener(() {
      if (!isReachedEndOfList.value &&
          draftScorllController.position.pixels >=
              draftScorllController.position.maxScrollExtent) {
        loadMoreDrafts();
      }
    });
  }

  Future<List<Blog>> fetchApi() async {
    List<Blog> res = await profileService.getDraftPosts(page: blogPage.value);
    return res;
  }

  Future<void> loadMoreDrafts() async {
    status(Status.loadingMore);
    blogPage.value += 1;

    List<Blog> res = await fetchApi();

    if (res.isEmpty) {
      isReachedEndOfList.value = true;
    } else {
      blogs.addAll(res);
    }

    status(Status.success);
  }

  // Future<List<Blog>> fetchApi();

  Future<void> loadBlogs() async {
    status(Status.loading);
    isReachedEndOfList.value = false;
    blogPage.value = 1;

    try {
      List<Blog> res = await fetchApi();

      if (res.isEmpty) isReachedEndOfList.value = true;

      blogs.value = res;

      status(Status.success);
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      Toster(message: errorMessage.value);
    }
  }

  Future<void> handleDraftEditing(
      {required int draftIndex,
      required Blog draftedBlog,
      required BlogsController blogsController,
      required PageNavigationController pageNavigationController}) async {
    editingSocialPostDraft.value = true;
    preparingContentForEdition.value = true;
    beingEditedDaftIndex.value = draftIndex;
    beingEditeDraftBlog.value = draftedBlog;

    final draftImageUrls = <String>[];
    final draftTextLines = [];

    for (var content in beingEditeDraftBlog.value.content!) {
      if (content.type == 'img') {
        draftImageUrls.add(content.content);
      } else {
        draftTextLines.add(content.content);
      }
    }

    textEditingController.value.text = draftTextLines.join('\n');
    final filePaths = await downloadImageUrlToFiles(imageUrls: draftImageUrls);
    selectedImages.value = filePaths ?? [];
    blogsController.loadContents("social", "all");
    Get.back();
    pageNavigationController.navigatePage(0);
    beingEditedDaftIndex.value = -1;
    preparingContentForEdition.value = false;
  }

  Future<void> createNewDraft() async {
    try {
      savingDraft.value = true;
      final postContent = extractPostContentFromTextFieldEditor();
      final processedImages = await processImages();

      Blog newDraft = await profileService.createNewDraft(
          postContent: postContent, images: processedImages);
      savingDraft.value = false;

      // this makes the newly created draft available for further editing
      editingSocialPostDraft.value = true;
      beingEditeDraftBlog.value = newDraft;
      Toster(message: "Draft Saved Successfully ", color: Colors.green);
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage("Failed To Save");
      }
      Toster(message: errorMessage.value);
    }
    savingDraft.value = false;
  }

  Future<void> updateDraft() async {
    try {
      updatingDraft.value = true;
      final draftId = extractDaftId();
      final postContent = extractPostContentFromTextFieldEditor();
      final processedImages = await processImages();

      await profileService.updateDraft(
          draftId: draftId, postContent: postContent, images: processedImages);

      updatingDraft.value = false;
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage("Failed To Update");
      }
      Toster(message: errorMessage.value);
    }
    Toster(message: " Draft Updated", color: Colors.green);
    updatingDraft.value = false;
  }

  Future<void> postDraftToSocial() async {
    try {
      makingPost.value = true;
      final draftId = extractDaftId();
      final postContent = extractPostContentFromTextFieldEditor();
      final processedImages = await processImages();
      await profileService.postDraftToSocial(
          draftId: draftId, postContent: postContent, images: processedImages);
      makingPost.value = false;
      resetDrafting();
      blogsController.loadContents('social', 'all');
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage("Failed To Delete");
      }
      Toster(message: errorMessage.value);
    }

    Toster(message: " Draft Posted Successfully ", color: Colors.green);
    makingPost.value = false;
  }

  Future<void> postNewToSocial() async {
    try {
      makingPost.value = true;
      final postContent = extractPostContentFromTextFieldEditor();

      final processedImages = await processImages();
      await profileService.postNewToSocial(
          postContent: postContent, images: processedImages);
      makingPost.value = false;
      resetDrafting();
      blogsController.loadContents('social', 'all');
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage("Failed To Delete");
      }
      Toster(message: errorMessage.value);
    }

    Toster(message: " Successfully Posted ", color: Colors.green);
    makingPost.value = false;
  }

  /// returns list of base64 encoded images
  Future<List<String>> processImages() async {
    List<String> processedImages = [];
    for (var i = 0; i < selectedImages.length; i++) {
      File imageFile = File(selectedImages[i].path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      processedImages.add(base64Image);
    }

    return processedImages;
  }

  /// this methods takes in list of url and downloads each image related to the url if it is not in the cache
  Future<List<SelectedImage>?> downloadImageUrlToFiles(
      {required List<String> imageUrls}) async {
    DefaultCacheManager cacheManager = DefaultCacheManager();
    final List<SelectedImage> imageFilePaths = [];
    try {
      for (var imageUrl in imageUrls) {
        File file = await cacheManager.getSingleFile(imageUrl);
        imageFilePaths.add(SelectedImage(path: file.path));
      }

      // No need to use http.get here, as cacheManager.getSingleFile handles downloading
    } catch (e) {
      print('Error: $e');
      return null;
    }

    return imageFilePaths;
  }

  Future<void> deleteDraft(
      {required Blog blog, required int draftIndex}) async {
    try {
      deletingDraft.value = true;
      beingDeletedDaftIndex.value = draftIndex;
      beingEditeDraftBlog.value = blog;

      final draftId = extractDaftId();
      await profileService.deleteDraft(draftId: draftId);
      deletingDraft.value = false;
      blogs.removeAt(draftIndex);
      Toster(message: "Deleted Succesfully", color: Colors.green);
    } catch (e) {
      print(e.toString());
      status(Status.error);
      if (e is AppError) {
        errorMessage("Failed To Delete");
      }
      Toster(message: errorMessage.value);
    }
    deletingDraft.value = false;
    beingDeletedDaftIndex.value = -1;
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
    selectedImages.value = [];
  }

  Future<void> pickImages() async {
    List<XFile>? selectedImagesFromPhone = await ImagePicker().pickMultiImage();
    if (selectedImagesFromPhone.isNotEmpty) {
      for (var i = 0; i < selectedImagesFromPhone.length; i++) {
        selectedImages
            .add(SelectedImage(path: selectedImagesFromPhone[i].path));
      }
    }
  }

  Future<void> removeSelectedImage({required int photoIndex}) async {
    selectedImages.removeAt(photoIndex);
  }
}
