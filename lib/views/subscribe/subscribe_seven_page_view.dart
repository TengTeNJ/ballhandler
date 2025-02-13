import 'package:code/constants/constants.dart';
import 'package:code/views/subscribe/comparison_list_view.dart';
import 'package:code/views/subscribe/subscribe_title_view.dart';
import 'package:flutter/material.dart';

class SubscribeSevenPageView extends StatefulWidget {
  const SubscribeSevenPageView({super.key});

  @override
  State<SubscribeSevenPageView> createState() => _SubscribeSevenPageViewState();
}

class _SubscribeSevenPageViewState extends State<SubscribeSevenPageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Constants.boldWhiteTextWidget(
            'Unlock Elite Features with\n14 Days Free', 24),
        SizedBox(height: 4,),
        Constants.mediumGreyTextWidget('Activate Your Free Trial Today', 16),
        SizedBox(
          height: 24,
        ),
        Constants.boldWhiteTextWidget('What You Get', 20),
        SizedBox(height: 18,),
        SubscribeTitleView(),
        SizedBox(height: 14,),
        Container(
          height:7 * 52,
          child: ComparisonListView() ,
        )
      ],
    );
  }
}
