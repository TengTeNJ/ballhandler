import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/services/sqlite/data_base.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/participants/today_data_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../models/game/game_over_model.dart';
import '../../utils/toast.dart';

class TodayDataController extends StatefulWidget {
  const TodayDataController({super.key});

  @override
  State<TodayDataController> createState() => _TodayDataControllerState();
}

class _TodayDataControllerState extends State<TodayDataController> {
  List<GameOverModel> _datas = [];
  bool _hasMode = false;
  int _page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData({bool loadMore = false}) async {
    if (!UserProvider.of(context).hasLogin) {
      // 未登录
      final _result = await DatabaseHelper().getData(kDataBaseTableName);
      _datas = _result;
      setState(() {
    });
    } else {
      if(loadMore){
        TTToast.showLoading();
      }
      // 已登录进行数据请求
      final _todayDate = DateTime.now();
      String _todayString =  StringUtil.dateTimeToString(_todayDate);
      final _response = await Participants.queryTrainListData(1, _todayString, _todayString);
      if(_response.success && _response.data != null){
        _datas.addAll(_response.data!.datas);
        _hasMode = (_datas.length < _response.data!.count);
        setState(() {

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.boldWhiteTextWidget('Today’s Challenge', 30)
              ],
            ),
            SizedBox(
              height:  _datas.length == 0 ? 0 : 30,
            ),
            Expanded(
                child: TodayDataListView(
              datas: _datas,
                  loadMore: (){
                if(_hasMode){
                  _page ++;
                  getData(loadMore: true);
                }
                  },
            ))
          ],
        ),
      ),
    );
  }
}
