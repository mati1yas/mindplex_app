import 'dart:convert';
import 'dart:io';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as ql;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindplex/features/blogs/controllers/blogs_controller.dart';
import 'package:mindplex/features/blogs/models/blog_model.dart';
import 'package:mindplex/features/bottom_navigation_bar/controllers/bottom_page_navigation_controller.dart';
import 'package:mindplex/features/user_profile_displays/models/picked_social_photo_model.dart';
import 'package:mindplex/features/user_profile_displays/services/profileServices.dart';
import 'package:mindplex/utils/AppError.dart';
import 'package:mindplex/utils/Toster.dart';
import 'package:mindplex/utils/awesome_snackbar.dart';
import 'package:mindplex/utils/empty_content_exception.dart';
import 'package:mindplex/utils/network/connection-info.dart';
import 'package:mindplex/utils/snackbar_constants.dart';
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
  ql.QuillController quillController = ql.QuillController.basic();
  BlogsController blogsController = Get.find();
  PageNavigationController pageNavigationController = Get.find();
  ConnectionInfoImpl connectionChecker = Get.find();

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

  Future<BuildContext> getContext() async {
    BuildContext? context = Get.context;
    return context!;
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
      if (!await connectionChecker.isConnected) {
        throw NetworkException("");
      }
      List<Blog> res = await fetchApi();

      if (res.isEmpty) isReachedEndOfList.value = true;

      blogs.value = res;

      status(Status.success);
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage(e.message);
      }
      if (e is NetworkException)
        showSnackBar(
            context: await getContext(),
            title: SnackBarConstantTitle.failureTitle,
            message: SnackBarConstantMessage.noInternetConnection,
            type: "failure");
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
    if (!await userCanMakePost()) return;
    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException("");
      }

      savingDraft.value = true;
      final postContent = extractPostContentFromTextFieldEditor();
      final processedImages = await processImages();
      if (is_empty_form() && processedImages.length == 0) {
        throw EmptyContentException("");
      }

      Blog newDraft = await profileService.createNewDraft(
          postContent: postContent, images: processedImages);
      savingDraft.value = false;

      // this makes the newly created draft available for further editing
      editingSocialPostDraft.value = true;
      beingEditeDraftBlog.value = newDraft;

      showSnackBar(
          context: await getContext()!,
          title: SnackBarConstantTitle.successTitle,
          message: SnackBarConstantMessage.draftSaveSuccess,
          type: "success");
      // Toster(message: "Draft Saved Successfully ", color: Colors.green);
    } catch (e) {
      status(Status.error);
      if (e is AppError) {
        errorMessage("Failed To Save");
      }

      String error = "";
      if (e is NetworkException) {
        error = SnackBarConstantMessage.noInternetConnection;
      } else if (e is EmptyContentException) {
        error = SnackBarConstantMessage.emptyContent;
      } else {
        error = SnackBarConstantMessage.draftSaveFailure;
      }

      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.failureTitle,
          message: error,
          type: "failure");
    }
    savingDraft.value = false;
  }

  Future<void> updateDraft() async {
    if (!await userCanMakePost()) return;
    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException("");
      }

      updatingDraft.value = true;
      final draftId = extractDaftId();
      final postContent = extractPostContentFromTextFieldEditor();
      final processedImages = await processImages();
      if (is_empty_form() && processedImages.length == 0) {
        throw EmptyContentException("");
      }

      await profileService.updateDraft(
          draftId: draftId, postContent: postContent, images: processedImages);

      updatingDraft.value = false;
      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.successTitle,
          message: SnackBarConstantMessage.draftUpdateSuccess,
          type: "success");
      updatingDraft.value = false;
    } catch (e) {
      status(Status.error);
      updatingDraft.value = false;

      if (e is AppError) {
        errorMessage("Failed To Update");
      }
      String error = "";
      if (e is NetworkException) {
        error = SnackBarConstantMessage.noInternetConnection;
      } else if (e is EmptyContentException) {
        error = SnackBarConstantMessage.emptyContent;
      } else {
        error = SnackBarConstantMessage.draftUpdateFailure;
      }

      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.failureTitle,
          message: error,
          type: "failure");
    }
  }

  Future<void> postDraftToSocial() async {
    if (!await userCanMakePost()) return;
    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException("");
      }

      makingPost.value = true;
      final draftId = extractDaftId();
      final postContent = extractPostContentFromTextFieldEditor();
      final processedImages = await processImages();
      if (is_empty_form() && processedImages.length == 0) {
        throw EmptyContentException("");
      }
      await profileService.postDraftToSocial(
          draftId: draftId, postContent: postContent, images: processedImages);
      makingPost.value = false;
      resetDrafting();
      blogsController.loadContents('social', 'all');
      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.successTitle,
          message: SnackBarConstantMessage.socialPostSucccess,
          type: "success");
      makingPost.value = false;
    } catch (e) {
      status(Status.error);
      makingPost.value = false;
      if (e is AppError) {
        errorMessage("Failed To post");
      }

      String error = "";
      if (e is NetworkException) {
        error = SnackBarConstantMessage.noInternetConnection;
      } else if (e is EmptyContentException) {
        error = SnackBarConstantMessage.emptyContent;
      } else {
        error = SnackBarConstantMessage.socialPostFailure;
      }

      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.failureTitle,
          message: error,
          type: "failure");
    }
  }

  Future<void> postNewToSocial() async {
    if (!await userCanMakePost()) return;
    try {
      if (!await connectionChecker.isConnected) {
        throw NetworkException("");
      }

      makingPost.value = true;
      final postContent = extractPostContentFromTextFieldEditor();

      final processedImages = await processImages();
      if (is_empty_form() && processedImages.length == 0) {
        throw EmptyContentException("");
      }
      await profileService.postNewToSocial(
          postContent: postContent, images: processedImages);
      makingPost.value = false;
      resetDrafting();
      blogsController.loadContents('social', 'all');
      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.successTitle,
          message: SnackBarConstantMessage.socialPostSucccess,
          type: "success");
      makingPost.value = false;
    } catch (e) {
      makingPost.value = false;
      if (e is AppError) {
        errorMessage("Failed To post");
      }
      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.failureTitle,
          message: e is NetworkException
              ? SnackBarConstantMessage.noInternetConnection
              : SnackBarConstantMessage.socialPostFailure,
          type: "failure");
    }
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
      if (!await connectionChecker.isConnected) {
        throw NetworkException("");
      }

      deletingDraft.value = true;
      beingDeletedDaftIndex.value = draftIndex;
      beingEditeDraftBlog.value = blog;

      final draftId = extractDaftId();
      await profileService.deleteDraft(draftId: draftId);
      deletingDraft.value = false;
      blogs.removeAt(draftIndex);
      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.successTitle,
          message: SnackBarConstantMessage.draftDeleteSuccess,
          type: "success");
      makingPost.value = false;
    } catch (e) {
      deletingDraft.value = false;
      if (e is AppError) {
        errorMessage("Failed To post");
      }
      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.failureTitle,
          message: e is NetworkException
              ? SnackBarConstantMessage.noInternetConnection
              : SnackBarConstantMessage.draftDeleteFailure,
          type: "failure");
    }
    deletingDraft.value = false;
    beingDeletedDaftIndex.value = -1;
  }

//  HELPER FUNTIONS BELOW

  bool is_empty_form() {
    final lines = getLines();
    for (var line in lines) {
      if (!line.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  dynamic getLines() {
    final lines =
        DeltaToHTML.encodeJson(quillController.document.toDelta().toJson())
            .split('<br>');

    return lines;
  }

  String extractPostContentFromTextFieldEditor() {
    final lines = getLines();

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
    quillController.replaceText(
      0,
      quillController.document.length,
      '',
      TextSelection(baseOffset: 0, extentOffset: 0),
    );

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

  Future<bool> userCanMakePost() async {
    var canPostAfter = blogsController.socialFeedSetting.value.timeBetweenPost;

    if (canPostAfter != "0") {
      showSnackBar(
          context: await getContext(),
          title: SnackBarConstantTitle.failureTitle,
          message:
              "you can only post after : $canPostAfter  or try refreshing the page.  ",
          type: "warning");
      return false;
    }
    return true;
  }
}
