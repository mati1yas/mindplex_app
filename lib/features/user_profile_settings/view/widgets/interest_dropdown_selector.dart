import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindplex/utils/colors.dart';

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
                                  return CheckboxWithTitle(
                                    onChanged: (newValue) {
                                      print("Tile method called");
                                      setState(() {
                                        if (newValue == true) {
                                          print("adding ");
                                          widget.selectedItems
                                              .add(searchOutputs[index]);
                                        } else {
                                          print('remvoing');
                                          widget.selectedItems
                                              .remove(searchOutputs[index]);
                                        }
                                      });
                                    },
                                    title: searchOutputs[index],
                                    value: widget.selectedItems
                                        .contains(searchOutputs[index]),
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

class CheckboxWithTitle extends StatefulWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  CheckboxWithTitle({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  _CheckboxWithTitleState createState() => _CheckboxWithTitleState();
}

class _CheckboxWithTitleState extends State<CheckboxWithTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(
              unselectedWidgetColor: Colors.white,
              checkboxTheme: CheckboxThemeData(
                  fillColor: MaterialStateProperty.all(Colors.white))),
          child: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.purpleAccent,
            value: widget.value,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value!);
              });
            },
          ),
        ),
        Expanded(
            child: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        )),
      ],
    );
  }
}
