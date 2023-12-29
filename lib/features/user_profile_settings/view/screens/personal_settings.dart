import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindplex/features/user_profile_settings/models/social_link.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../services/api_services.dart';
import '../../../../utils/colors.dart';
import '../../../authentication/controllers/auth_controller.dart';
import '../../models/user_profile.dart';

class PersonalSettingsPage extends StatefulWidget {
  const PersonalSettingsPage({Key? key}) : super(key: key);

  @override
  State<PersonalSettingsPage> createState() => _PersonalSettingsPageState();
}

final _formKey = GlobalKey<FormState>();
String? first_name, last_name, biography, education, profilePic;
List<String>? interests = [];
List<String> genderChoices = [
  'Male',
  'Female',
  'Non Binary',
  'Prefer not to say',
  'Other'
];
List<String> educationChoices = [
  'Doctorate Degree',
  'Master\'s Degree',
  'Bachelor\'s Degree',
  'Certificate or Diploma',
  'High School'
];
String? nameError, lastNameError, ageError, socialLinkError;

bool _isUpdating = false;

class _PersonalSettingsPageState extends State<PersonalSettingsPage> {
  Rx<LocalStorage> localStorage =
      LocalStorage(flutterSecureStorage: FlutterSecureStorage()).obs;
  String? title;
  bool isSaved = false;
  bool isLinkAdded = false;
  bool isValueSet = false;
  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());

  int? age;
  String? gender;
  String social = " ";
  List<String> _socialMediaLinks = [];

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    profileController.getAuthenticatedUser();
    first_name = profileController.authenticatedUser.value.firstName ?? " ";
    last_name = profileController.authenticatedUser.value.lastName ?? " ";
    profilePic = profileController.authenticatedUser.value.image ?? "";
    fetchUserProfile();
  }

  int mapEducationFromApi(String apiResponse) {
    return 38 - int.parse(apiResponse);
  }

  int mapGenderFromApi(String apiResponse) {
    for (int i = 0; i < genderChoices.length; i++) {
      if (apiResponse == genderChoices[i]) {
        return i;
      }
    }
    return -1;
  }

  int mapEducationToApi(String education) {
    for (int i = 0; i < educationChoices.length; i++) {
      if (education == educationChoices[i]) {
        return 38 - i;
      }
    }
    return -1;
  }

  void addSocialMediaLink() {
    setState(() {
      _socialMediaLinks.add(social);
    });
  }

  String detectSocialMediaPlatform(String url) {
    if (RegExp(r'^https?:\/\/(?:www\.)?facebook\.com\/.*').hasMatch(url)) {
      return "facebook";
    } else if (RegExp(r'^https?:\/\/(?:www\.)?twitter\.com\/.*')
            .hasMatch(url) ||
        RegExp(r'^https?:\/\/(?:www\.)?x\.com\/.*').hasMatch(url)) {
      return "twitter";
    } else if (RegExp(r'^https?:\/\/(?:www\.)?linkedin\.com\/.*')
        .hasMatch(url)) {
      return "linkedin";
    } else {
      return "";
    }
  }

  String searchSocialMediaPlaform(List<String> urls, int index) {
    if (index == 1) {
      for (var value in urls) {
        if (detectSocialMediaPlatform(value) == "linkedin") {
          return value;
        }
      }
    } else if (index == 2) {
      for (var value in urls) {
        if (detectSocialMediaPlatform(value) == "facebook") {
          return value;
        }
      }
    } else if (index == 3) {
      for (var value in urls) {
        if (detectSocialMediaPlatform(value) == "twitter") {
          return value;
        }
      }
    }
    return "";
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    ProfileController profileController = Get.put(ProfileController());

    try {
      UserProfile userProfile = await _apiService.fetchUserProfile(
          userName: profileController.authenticatedUser.value.username!);

      setState(() {
        age = userProfile.age!;
        gender = genderChoices[mapGenderFromApi(userProfile.gender!)];
        biography = Html(
                data: htmlParser
                    .parse(parse(userProfile.biography).documentElement!.text)
                    .body
                    ?.text)
            .data;
        interests = userProfile.interests!;
        education =
            educationChoices[mapEducationFromApi(userProfile.education!.id!)];
        _socialMediaLinks = userProfile.socialLink!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Handle any errors that occurred during the API request
      print('Error fetching user profile: $e');
    }
  }

  Future<String> updateUserProfile(firstName, lastName) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(color: Colors.green[900]),
            ));
    setState(() {
      _isUpdating = true;
    });
    try {
      UserProfile updatedProfile = UserProfile(
          firstName: firstName,
          lastName: lastName,
          age: age,
          gender: gender,
          biography: biography,
          interests: interests,
          educationRequest: mapEducationToApi(education!),
          socialLink: _socialMediaLinks);
      String? updatedValues = await _apiService.updateUserProfile(
        updatedProfile: updatedProfile,
      );
      print(updatedValues);
      setState(() {
        _isUpdating = false;
      });
      localStorage.value
          .updateUserInfo(firstName: firstName, lastName: lastName);
      Navigator.of(context).pop();
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        titleSize: 20,
        messageSize: 17,
        messageColor: Colors.white,
        backgroundColor: Colors.green,
        borderRadius: BorderRadius.circular(8),
        message: "Saved",
        duration: const Duration(seconds: 2),
      ).show(context);
      return updatedValues;
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      print('Error updating user profile: $e');
      return '';
    }
  }

  void _saveSelectedChoice(String choice) {
    print(choice);
    setState(() {
      education = choice;
    });
  }

  void _saveSelectedChoiceGender(String choice) {
    setState(() {
      gender = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstName =
        profileController.authenticatedUser.value.firstName ?? " ";
    final lastName = profileController.authenticatedUser.value.lastName ?? " ";
    final name = firstName + " " + lastName;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: mainBackgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              buildImage(),
              SizedBox(
                height: 15,
              ),
              buildAddPhoto()
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(children: [
                  const SizedBox(height: 10),
                  _container(context, false, null, name, TextInputType.name,
                      name, "name", "", (() {})),
                  nameError != null && isSaved
                      ? errorMessage(nameError.toString())
                      : Container(),
                  _container(context, false, null, biography,
                      TextInputType.name, biography, "bio", "", (() {}),
                      maxLines: 8),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Education",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity, // Cover the whole width
                        decoration: BoxDecoration(
                          color: mainBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(15), // Apply border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ), // Set the background color to white
                        child: Align(
                          alignment: Alignment
                              .center, // Align the dropdown to the center
                          child: Container(
                            width: double
                                .infinity, // Set the width of the dropdown
                            decoration: BoxDecoration(
                              color: mainBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.amber,
                                  width: 2.0), // Apply border radius
                            ),
                            child: DropdownButton<String>(
                              value:
                                  education, // Set the initial value to the first choice (placeholder)
                              items: educationChoices.map((String choice) {
                                return DropdownMenuItem<String>(
                                  value: choice,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      choice,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                _saveSelectedChoice(newValue!);
                              },
                              style: TextStyle(
                                  color:
                                      Colors.white), // Customize the text color
                              dropdownColor: Colors
                                  .purpleAccent, // Customize the dropdown menu's background color
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.amber,
                              ), // Custom dropdown arrow icon
                              iconSize: 40, // Set the icon size as needed
                              isExpanded:
                                  true, // Expand the dropdown to cover the width
                              underline:
                                  SizedBox(), // Remove the default underline
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _container(
                    context,
                    false,
                    null,
                    age == 0 ? "" : age.toString(),
                    TextInputType.number,
                    age.toString(),
                    "age",
                    "",
                    (() {}),
                  ),
                  ageError != null && isSaved
                      ? errorMessage(ageError.toString())
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Gender",
                            style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity, // Cover the whole width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(15), // Apply border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ), // Set the background color to white
                        child: Align(
                          alignment: Alignment
                              .center, // Align the dropdown to the center
                          child: Container(
                            width: double
                                .infinity, // Set the width of the dropdown
                            decoration: BoxDecoration(
                              color: mainBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.amber,
                                  width: 2.0), // Apply border radius
                            ),
                            child: DropdownButton<String>(
                              value:
                                  gender, // Set the initial value to the first choice (placeholder)
                              items: genderChoices.map((String choice) {
                                return DropdownMenuItem<String>(
                                  value: choice,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      choice,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                _saveSelectedChoiceGender(newValue!);
                              },
                              style: TextStyle(
                                  color:
                                      Colors.white), // Customize the text color
                              dropdownColor: Colors
                                  .purpleAccent, // Customize the dropdown menu's background color
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.amber,
                              ), // Custom dropdown arrow icon
                              iconSize: 40, // Set the icon size as needed
                              isExpanded:
                                  true, // Expand the dropdown to cover the width
                              underline:
                                  SizedBox(), // Remove the default underline
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InterestDropdown(
                    selectedItems: interests!,
                    onSelectionChanged: (List<String> newSelectedItems) {
                      setState(() {
                        interests = newSelectedItems;
                      });
                    },
                  ),
                  _container(context, false, null, "", TextInputType.name, null,
                      "social", "Enter your social links here", () {}),
                  socialLinkError != null && isLinkAdded
                      ? errorMessage(socialLinkError.toString())
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: _socialMediaLinks
                            .where(
                                (text) => detectSocialMediaPlatform(text) == "")
                            .map((text) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _socialMediaLinks.remove(text);
                                        });
                                      },
                                      child: Text(
                                        "Delete Link",
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            searchSocialMediaPlaform(_socialMediaLinks, 1) != ""
                                ? Row(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.amber),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Icon(
                                              searchSocialMediaPlaform(
                                                          _socialMediaLinks,
                                                          1) !=
                                                      ""
                                                  ? FontAwesome.linkedin
                                                  : null,
                                              size: 24,
                                              color: Colors.amber),
                                        ),
                                        onTap: () async {
                                          await launchUrl(Uri.parse(
                                              searchSocialMediaPlaform(
                                                  _socialMediaLinks, 1)));
                                        },
                                      ),
                                      IconButton(
                                          alignment: Alignment.bottomLeft,
                                          onPressed: () {
                                            setState(() {
                                              _socialMediaLinks.remove(
                                                  searchSocialMediaPlaform(
                                                      _socialMediaLinks, 1));
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete_forever,
                                            size: 16,
                                            color: Colors.redAccent,
                                          ))
                                    ],
                                  )
                                : SizedBox(
                                    width: 0,
                                  ),
                            searchSocialMediaPlaform(_socialMediaLinks, 2) != ""
                                ? Row(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.amber),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Icon(
                                              searchSocialMediaPlaform(
                                                          _socialMediaLinks,
                                                          2) !=
                                                      ""
                                                  ? FontAwesome.facebook
                                                  : null,
                                              size: 24,
                                              color: Colors.amber),
                                        ),
                                        onTap: () async {
                                          await launchUrl(Uri.parse(
                                              searchSocialMediaPlaform(
                                                  _socialMediaLinks, 2)));
                                        },
                                      ),
                                      IconButton(
                                          alignment: Alignment.bottomLeft,
                                          onPressed: () {
                                            setState(() {
                                              _socialMediaLinks.remove(
                                                  searchSocialMediaPlaform(
                                                      _socialMediaLinks, 2));
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete_forever,
                                            size: 16,
                                            color: Colors.redAccent,
                                          ))
                                    ],
                                  )
                                : SizedBox(
                                    width: 0,
                                  ),
                            searchSocialMediaPlaform(_socialMediaLinks, 3) != ""
                                ? Row(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.amber),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: SvgPicture.asset(
                                              'assets/icons/x-twitter.svg',
                                              width:
                                                  22, // Set the desired width
                                              height: 22,
                                              color: Colors
                                                  .amber, // Set the desired height
                                            )),
                                        onTap: () async {
                                          await launchUrl(Uri.parse(
                                              searchSocialMediaPlaform(
                                                  _socialMediaLinks, 3)));
                                        },
                                      ),
                                      IconButton(
                                          alignment: Alignment.bottomLeft,
                                          onPressed: () {
                                            setState(() {
                                              _socialMediaLinks.remove(
                                                  searchSocialMediaPlaform(
                                                      _socialMediaLinks, 3));
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete_forever,
                                            size: 16,
                                            color: Colors.redAccent,
                                          ))
                                    ],
                                  )
                                : SizedBox(
                                    width: 0,
                                  ),
                          ],
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: buildButton("Add link", () {
                            isLinkAdded = false;
                            final isValidLink = socialLinkError == null;
                            setState(() {
                              isLinkAdded = true;
                            });
                            if (isValidLink) {
                              addSocialMediaLink();
                              _socialMediaLinks.forEach((element) {
                                print(element);
                              });
                            }
                          }, Colors.amber, true),
                        ),
                      ],
                    ),
                  ),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                buildButton("Cancel", () async {
                  print("account deleted");
                }, Colors.blueAccent, false),
                Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: buildButton("Save", (() async {
                      isSaved = false;
                      final isValidForm = _formKey.currentState!.validate();
                      setState(() {
                        isSaved = true;
                      });
                      if (isValidForm) {
                        updateUserProfile(first_name, last_name)
                            .then((String updatedValues) {})
                            .catchError((error) {
                          print('Error updating user profile: $error');
                        });
                      } else {
                        Flushbar(
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                          titleSize: 20,
                          messageSize: 17,
                          messageColor: Colors.white,
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          message: "invalid value on 1 or more input",
                          duration: const Duration(seconds: 2),
                        ).show(context);
                      }
                    }), Colors.blueAccent.shade200, true))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  buildAddPhoto() {
    return Container(
      child: InkWell(
          onTap: () async {
            String? filePath = await pickImage();
            // let's show a loading dialog with a loading message
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            );
            // let's upload the image to the api
            if (filePath != null) {
              // let's try to upload the image

              try {
                String? imageUrl =
                    await _apiService.changeProfilePicture(filePath);
                print(imageUrl);
                setState(() {
                  profilePic = imageUrl;
                });
                localStorage.value.updateUserInfo(image: imageUrl);
              } catch (error) {
                // let's show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to upload image. Try again later."),
                  ),
                );
              }
            } else {
              // display a snackbar with error message (to the user)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid file selected."),
                ),
              );
            }
            // pop the dialog
            Navigator.pop(context);
          },
          child: Text(
            "Change Picture",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
          )),
    );
  }

  Future<String?> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    }

    return null;
  }

  Widget buildImage() {
    ImageProvider<Object> image = NetworkImage(
      profilePic ?? "assets/images/profile.PNG",
    );
    return CircleAvatar(
      radius: 45,
      foregroundImage: image,
      child: const Material(
        color: Color.fromARGB(0, 231, 6, 6), //
      ),
    );
  }

  String? hintText(String? inputType) {
    if (inputType == "name") {
      return "Name";
    } else if (inputType == "bio") {
      return "Biography";
    } else if (inputType == "age") {
      return "Age";
    } else if (inputType == "social") return "Social links";
    return null;
  }

  Widget _container(
      BuildContext context,
      bool readOnly,
      TextEditingController? controller,
      String? initialValue,
      TextInputType? inputType,
      String? value,
      String? type,
      String hint,
      VoidCallback onTap,
      {maxLines = 1}) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Color secondbackgroundColor = Theme.of(context).cardColor;
    IconThemeData icontheme = Theme.of(context).iconTheme;

    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              hintText(type) ?? " ",
              style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
              color: secondbackgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(1, 1),
                  color: const Color.fromARGB(54, 188, 187, 187),
                )
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: readOnly,
                    controller: controller,
                    initialValue: initialValue,
                    keyboardType: inputType,
                    maxLines: maxLines,
                    style: textTheme.headline2?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: mainBackgroundColor,
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        errorStyle:
                            const TextStyle(fontSize: 0.01, color: Colors.red),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.amber, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 25, top: 10, bottom: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey),
                        suffix: type == 'age'
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  "Years",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber),
                                ),
                              )
                            : null),
                    onTap: onTap,
                    onChanged: (value) {
                      if (type == "name") {
                        List<String> parts = value.split(
                            ' '); // Split the text into two parts at the first whitespace
                        if (parts.length > 1) {
                          first_name = parts[0]
                              .trim(); // Remove leading and trailing whitespace from the first part
                          last_name = parts[1]
                              .trim(); // Remove leading and trailing whitespace from the second part
                        } else if (parts.length == 1) {
                          first_name = parts[0];
                        }
                      } else if (type == "age") {
                        age = int.parse(value);
                      } else if (type == "bio") {
                        biography = value;
                      } else if (type == "social") {
                        social = value;
                      }
                    },
                    validator: ((value) {
                      if (type == "name") {
                        if (value != null && value.length < 1) {
                          nameError = "Please enter your First name";
                          return nameError;
                        } else if (value!.trim().split(" ").length > 2) {
                          nameError = "Please specify first and last name only";
                          return nameError;
                        } else {
                          nameError = null;
                          return null;
                        }
                      } else if (type == "age") {
                        if (value != null && value.length < 1) {
                          ageError = "Please enter your age";
                          return ageError;
                        } else if (!isNumeric(value!)) {
                          ageError = 'Please enter a valid age';
                          return ageError;
                        } else {
                          ageError = null;
                          return null;
                        }
                      } else if (type == "social") {
                        final urlPattern = RegExp(
                          r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
                          caseSensitive: false,
                        );
                        if (value != null && !urlPattern.hasMatch(value)) {
                          socialLinkError =
                              "invalid link make sure your link start with https://";
                          return socialLinkError;
                        } else {
                          socialLinkError = null;
                          return null;
                        }
                      }
                      return null;
                    })))),
      ],
    );
  }
}

bool isNumeric(String value) {
  try {
    int age = int.parse(value);
    if (age > 0) {
      return true; // Age is a positive integer
    }
  } catch (e) {
    return false;
  }
  return false;
}

Widget buildButton(String label, VoidCallback onTap, Color color1, bool fill) {
  return SizedBox(
    key: UniqueKey(),
    width: 150,
    height: label == "Add link" ? 35 : 50,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: fill
            ? BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.circular(10),
              )
            : BoxDecoration(
                border: Border.all(color: color1),
                borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            label,
            style: fill
                ? TextStyle(color: Colors.white, fontSize: 20)
                : TextStyle(color: color1, fontSize: 20),
          ),
        ),
      ),
    ),
  );
}

Widget errorMessage(String? error) {
  return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 5, left: 10),
      child: Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ));
}

class InterestDropdown extends StatefulWidget {
  late final List<String> selectedItems;
  final ValueChanged<List<String>> onSelectionChanged;

  InterestDropdown(
      {required this.selectedItems, required this.onSelectionChanged});

  @override
  _InterestDropdownState createState() => _InterestDropdownState();
}

class _InterestDropdownState extends State<InterestDropdown> {
  List<String> dropdownItems = [
    'Classroom Study',
    'Software Development',
    'Hardware Development',
    'Blockchain Development',
    'Robotics',
    'Design',
    'Research',
    'Trading',
    'Marketing',
    'Partnership',
    'Finance And Investing',
    'Fashion In Wearable Tech',
    'Love In Virtual Word',
    'Dating Robots And Other Tech Entities',
    'Fitness Technologies',
    'Travel',
    'AI Art',
    '3D Food Printing',
    'Space',
    'Law',
    'Journalism',
    'Philosophy And Related',
    'Healthcare And Related',
    'Agriculture And Related',
    'Accounting',
    'Environmental And Wildlife',
    'Governance',
    'Military',
    'Commerce',
    'Art',
  ];
  List<String> searchOutputs = [];

  bool showDropDown = false;
  TextEditingController searchText = TextEditingController();

  void updateInterests(String query) {
    setState(() {
      searchOutputs = dropdownItems
          .where((interest) =>
              interest.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    searchOutputs = dropdownItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Interests",
              style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            setState(() {
              showDropDown = !showDropDown;
            });
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber, width: 2.0),
              color: mainBackgroundColor,
              borderRadius: BorderRadius.circular(15), // Apply border radius
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children:
                        List.generate(widget.selectedItems.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: mainBackgroundColor,
                            border: Border.all(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(
                              8.0), // Adjust the padding as needed
                          child: Text(
                            widget.selectedItems[index],
                            style: TextStyle(color: Colors.purpleAccent),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Icon(
                  showDropDown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 40,
                  color: Colors.amber,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            width: double.infinity,
            height: showDropDown ? 260 : 0,
            decoration: BoxDecoration(
                color: Color.fromARGB(100, 130, 16, 185),
                border: Border.all(
                  color: Color.fromARGB(100, 52, 5, 112),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15)),
            child: showDropDown
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Search your interest here...",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  controller: searchText,
                                  onChanged: (value) {
                                    updateInterests(value);
                                  },
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      4.0, // Adjust this value to change the aspect ratio of the checkboxes
                                ),
                                itemCount: searchOutputs
                                    .length, // Replace 'choices' with your list of choices
                                itemBuilder: (context, index) {
                                  return Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Colors.white,
                                        checkboxTheme: CheckboxThemeData(
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Colors.white))),
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor: Colors.purpleAccent,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        searchOutputs[index],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      value: widget.selectedItems
                                              .contains(searchOutputs[index])
                                          ? true
                                          : false,
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue == true) {
                                            widget.selectedItems
                                                .add(searchOutputs[index]);
                                          } else {
                                            widget.selectedItems
                                                .remove(searchOutputs[index]);
                                          }
                                          print(widget.selectedItems);
                                          widget.onSelectionChanged(
                                              widget.selectedItems);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        )
      ],
    );
  }
}
