import 'package:code/constants/constants.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:code/views/profile/exchange_rewards_view.dart';
import 'package:flutter/material.dart';

import '../../services/http/profile.dart';

class ExchangeRewardListView extends StatefulWidget {
  const ExchangeRewardListView({super.key});

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
  }


/*查询可兑换商品列表*/
  queryExchangeGoodsData() async {
    final _response = await Profile.queryIExchangeGoodsListData(1);
    if (_response.success && _response.data != null) {
      _datas.addAll(_response.data!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      child: ListView.separated(
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
