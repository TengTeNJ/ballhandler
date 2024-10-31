import 'package:code/constants/constants.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/profile/exchange_rewards_view.dart';
import 'package:flutter/material.dart';

import '../../services/http/profile.dart';

class ExchangeRewardListView extends StatefulWidget {
  int integralMinLevel = 0;
  int integralMaxLevel = 2000;
  int userIntegral = 0; // 用户的积分
  ExchangeRewardListView({this.integralMinLevel = 0,this.integralMaxLevel = 2000,this.userIntegral = 0});

  @override
  State<ExchangeRewardListView> createState() => _ExchangeRewardListViewState();
}

class _ExchangeRewardListViewState extends State<ExchangeRewardListView> {
  List<ExchangeGoodModel> _datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryExchangeGoodsData();
    print('widget.integralMinLevel = ${widget.integralMinLevel} widget.integralMaxLevel = ${widget.integralMaxLevel}');
  }


/*查询可兑换商品列表*/
  queryExchangeGoodsData() async {
    final _response = await Profile.queryIExchangeGoodsListData(1);
    if (_response.success && _response.data != null) {
      _datas.clear();
      _response.data!.forEach((element){
          if( widget.integralMaxLevel >= element.goodsIntegral ){
            _datas.add(element);
          }
      });
      setState(() {
        print('_datas = ${_datas}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16,right: 16),
      width: Constants.screenWidth(context) - 32,
      child: _datas.length == 0 ? NoDataView() : ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ExchangeRewardsView(model: _datas[index]),
              onTap: () {
                TTDialog.integralExchangeDialog(context, () async{
                  final _response = await Profile.exchange(_datas[index].goodsId);
                  // 积分兑换通知
                  EventBus().sendEvent(kIntegralChange);
                  if(_response.success){
                    NavigatorUtil.pop();
                    TTDialog.integralExchangeSuccessDialog(context);
                  }
                });
              },
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                height: 12,
              ),
          itemCount: _datas.length),
    );
  }
}
