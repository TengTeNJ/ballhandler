import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/award_model.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/airbattle/award_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class AwardListController extends StatefulWidget {
  const AwardListController({super.key});

  @override
  State<AwardListController> createState() => _AwardListControllerState();
}

class _AwardListControllerState extends State<AwardListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
      ),
      backgroundColor: Constants.darkThemeColor,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Constants.boldWhiteTextWidget('Award', 30),
            SizedBox(
              height: 6,
            ),
            Expanded(
                child: AwardListView(
              datas: [
                AwardModel(),
                AwardModel(),
              ],
              selectItem: (AwardModel model) {
                TTDialog.awardDialog(context);
              },
            ))
          ],
        ),
      ),
    );
  }
}
