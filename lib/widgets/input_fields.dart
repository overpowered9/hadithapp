import 'package:flutter/material.dart';
import 'package:mad_project/pallets.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  bool isPass;
   final TextEditingController textEditingController;
    final TextInputType textInputType;
  LoginField({super.key, required this.hintText,this.isPass = false,
  required this.textEditingController,required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallete.borderColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallete.gradient2,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
        ),
        obscureText: isPass,
      ),
    );
  }
}
