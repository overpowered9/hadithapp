import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mad_project/pallets.dart';

class SocialButton extends StatelessWidget {
  final String social;
  final String label;
  final double horizontalpadding;
  const SocialButton({super.key, required this.social, required this.label,
  this.horizontalpadding = 100});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: SvgPicture.asset(
        social, width: 25,
        // ignore: deprecated_member_use
        color: Pallete.whiteColor,
      ),
      label: Text(
        label,
        style: const TextStyle(color: Pallete.whiteColor, fontSize: 17),
      ),
      style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: horizontalpadding),
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Pallete.borderColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
