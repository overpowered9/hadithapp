import 'package:flutter/material.dart';
import 'package:mad_project/pallets.dart';

class GradientButton extends StatelessWidget {
  final bool prog;
  final String txt;
  final VoidCallback fun;
  const GradientButton({super.key, required this.txt, required this.fun,required this.prog});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Pallete.gradient1,
        Pallete.gradient2,
        Pallete.gradient3
      ])),
      child: ElevatedButton(
        onPressed: fun,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(395, 55),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child:prog?const CircularProgressIndicator(
                      color: Pallete.whiteColor,
                    ): Text(
          txt,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
    );
  }
}
