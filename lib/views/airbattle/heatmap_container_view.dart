import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/heatmap_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/airbattle/heat_map_view.dart';
import 'package:flutter/material.dart';

class HeatMapContainerView extends StatefulWidget {
  const HeatMapContainerView({super.key});

  @override
  State<HeatMapContainerView> createState() => _HeatMapContainerViewState();
}

class _HeatMapContainerViewState extends State<HeatMapContainerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
          ),
          Constants.boldWhiteTextWidget('Days Active', 16),
          SizedBox(
            width: 22,
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.mediumWhiteTextWidget(StringUtil.monthToAbbreviation(9), 10,height: 2.5),
              HeatMapView(
                heatMapDats: [
                  HeatMapModel(),
                  HeatMapModel(statu: HeatMapStatu.Middle),
                  HeatMapModel(statu: HeatMapStatu.Active),
                  HeatMapModel(statu: HeatMapStatu.Active),
                  HeatMapModel(statu: HeatMapStatu.Zero),
                  HeatMapModel(statu: HeatMapStatu.Primary),
                  HeatMapModel(statu: HeatMapStatu.Primary)
                ],
                monthDay: 9,
                startDayIndex: 17,
              ),
              SizedBox(height: 16,),
            ],
          )),
          SizedBox(
            width: 32,
          ),
        ],
      ),
    );
  }
}
