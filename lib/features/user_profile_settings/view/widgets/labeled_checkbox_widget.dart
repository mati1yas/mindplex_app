import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  side: BorderSide(color: Colors.transparent),
                  fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
                  checkColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                ),
              ),
              child: Checkbox(
                activeColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 255, 73, 139)),
                value: value,
                onChanged: (bool? newValue) {
                  onChanged(newValue!);
                },
              ),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    label,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}