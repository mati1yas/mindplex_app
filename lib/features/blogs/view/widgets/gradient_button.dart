import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GradientBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String btnName;
  String iconUrl;
  bool isPcked;
  final bool defaultBtn;
  double borderRadius;
  double height;
  double? width;

  GradientBtn({
    Key? key,
    required this.onPressed,
    required this.btnName,
    this.iconUrl = 'https://cdn-icons-png.flaticon.com/512/6062/6062646.png',
    this.isPcked = true,
    required this.defaultBtn,
    this.borderRadius = 10,
    this.height = 35,
    this.width = 135,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(2, 8))
          ],
            color:isPcked
                ? Colors.white
                : defaultBtn
                ? null
                : const Color.fromARGB(255, 73, 150, 154),
          gradient: defaultBtn ? const LinearGradient(colors: [const Color.fromARGB(
              255, 189, 81, 217), const Color.fromARGB(
              255, 183, 36, 238)]) : null,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!defaultBtn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: CachedNetworkImage(
                  imageUrl: iconUrl,
                  height: 20,
                  width: 20,
                ),
              ),
            Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text(
                  btnName,
                  style: TextStyle(
                      fontSize: defaultBtn ? 15 : null,
                      fontWeight: FontWeight.w400,
                      color: !isPcked ? Colors.white : Colors.grey[900]),
                )),
          ],
        ),
      ),
    );
  }
}
