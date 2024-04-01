import 'package:flutter/material.dart';
class RewardView extends StatefulWidget {
  const RewardView({super.key});

  @override
  State<RewardView> createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image(image: AssetImage('images/profile/gold.png'),width: 37,height: 42,),
        SizedBox(width: 18,),
        Image(image: AssetImage('images/profile/grey.png'),width: 37,height: 42,),
      ],
    );
  }
}
