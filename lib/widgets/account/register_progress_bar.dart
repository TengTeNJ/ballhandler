import 'package:flutter/material.dart';

class RegisterProgressBar extends StatelessWidget {
  final int currentStep;

  const RegisterProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double barWidth = (screenWidth - 32 - 16) / 3;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return Container(
            width: barWidth,
            height: 4,
            decoration: BoxDecoration(
              color: index < currentStep
                  ? const Color(0xFFF8850B)
                  : const Color(0xFF65657D),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
