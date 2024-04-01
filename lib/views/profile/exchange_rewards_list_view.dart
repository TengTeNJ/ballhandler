import 'package:code/constants/constants.dart';
import 'package:code/views/profile/exchange_rewards_view.dart';
import 'package:flutter/material.dart';

class ExchangeRewardListView extends StatefulWidget {
  const ExchangeRewardListView({super.key});

  @override
  State<ExchangeRewardListView> createState() => _ExchangeRewardListViewState();
}

class _ExchangeRewardListViewState extends State<ExchangeRewardListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ExchangeRewardsView();
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 12,
          ),
          itemCount: 6),
    );
  }
}
