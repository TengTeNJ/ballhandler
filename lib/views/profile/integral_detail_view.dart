import 'package:code/constants/constants.dart';
import 'package:code/services/http/profile.dart';
import 'package:flutter/material.dart';
class IntegralView extends StatefulWidget {
  IntegralModel model;
   IntegralView({required this.model});

  @override
  State<IntegralView> createState() => _IntegralViewState();
}

class _IntegralViewState extends State<IntegralView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 16,right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.mediumWhiteTextWidget(widget.model.integralName, 14),
              SizedBox(height: 8,),
              Row(
                children: [
                  Constants.regularGreyTextWidget(widget.model.modelName, 14),
                  SizedBox(width: 8,),
                  Constants.regularGreyTextWidget(widget.model.createTime, 14),
                ],
              )
            ],
          ),
          Constants.customTextWidget( (widget.model.integralType == 1 ? '+' : '-' )+'${widget.model.integralVal}', 14,widget.model.integralType == 1 ? '#5BCC6A':'#E33E3E')
        ],
      ),
    );
  }
}
