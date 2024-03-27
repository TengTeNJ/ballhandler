import 'package:code/constants/constants.dart';
import 'package:code/views/ranking/ranking_card_page_view.dart';
import 'package:code/views/ranking/ranking_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:tt_indicator/tt_indicator.dart';

class RankingController extends StatefulWidget {
  const RankingController({super.key});

  @override
  State<RankingController> createState() => _RankingControllerState();
}

class _RankingControllerState extends State<RankingController> {
  int _currentPageIndex = 0;

  void _pageViewOnChange(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Constants.boldWhiteTextWidget('Rankings', 30),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: Constants.screenWidth(context),
              height: 152,
              child: RankingCardPageView(onChange: _pageViewOnChange),
            ),
            IndicatorView(
              count: 3,
              currentPage: _currentPageIndex,
              currentPageColor: Constants.baseStyleColor,
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Constants.mediumWhiteTextWidget('Training Rank', 16),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: RankingListView(),
            )),
          ],
        ),
      ),
    );
  }
}
