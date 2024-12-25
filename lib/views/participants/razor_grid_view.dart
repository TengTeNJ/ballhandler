import 'package:code/views/participants/razor_mode_view.dart';
import 'package:flutter/material.dart';

class RazorGridView extends StatelessWidget {
  final List<String> imageNames;

  const RazorGridView({super.key, required this.imageNames});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RazorModeView(imageName: imageNames[0]),
            SizedBox(width: 6,),
            RazorModeView(imageName: imageNames[1]),
            SizedBox(width: 6,),
            RazorModeView(imageName: imageNames[2]),

          ],
        ),
        SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RazorModeView(imageName: imageNames[3]),
            SizedBox(width: 6,),
            RazorModeView(imageName: imageNames[4]),
            SizedBox(width: 6,),
            RazorModeView(imageName: imageNames[5]),

          ],
        )
      ],
    );
  }
}
