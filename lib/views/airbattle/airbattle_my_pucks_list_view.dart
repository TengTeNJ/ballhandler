import 'package:code/models/airbattle/my_pucks_model.dart';
import 'package:code/views/airbattle/airbattle_my_pucks_view.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class AirbattleMyPucksListView extends StatefulWidget {
  List<MyPucksModel>? datas;

  AirbattleMyPucksListView({super.key, this.datas});

  @override
  State<AirbattleMyPucksListView> createState() =>
      _AirbattleMyPucksListViewState();
}

class _AirbattleMyPucksListViewState extends State<AirbattleMyPucksListView> {
  List<MyPucksModel> _datas = [];

  initDatas() {
    List<String> _titles = [
      'Highest Record',
      'Avg.Record',
      'Play Times',
      'Break Record'
    ];
    List<String> _imageNames = ['highest', 'avg', 'playtimes', 'break'];
    List<String> _dess = [
      'Rank 100',
      'Your average React Time in this Air Battle',
      'Rank 100',
      'Rank 100'
    ];
    List<String> _units = ['Sec/pt', 'Sec/pt', 'Sec/pt', 'Sec/pt'];
    List<bool> _specialShows = [true, false, true, true];
    for(int i = 0; i < _imageNames.length; i ++){
      MyPucksModel model = MyPucksModel();
      model.title = _titles[i];
      model.des = _dess[i];
      model.unit = _units[i];
      model.imageName =   'images/airbattle/${_imageNames[i]}.png';
      model.specialShow = _specialShows[i];
      if(i == 0){
        model.upValue = '10%';
      }
      _datas.add(model);
    }
    setState(() {

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDatas();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        // 禁止滑动
        shrinkWrap: true,
        // ListView 的 shrinkWrap 属性设置为 true，可以让 ListView 根据其内容的实际高度来调整自身大小，而不是无限扩展
        itemBuilder: (context, index) {
          return AirbattleMyPucksView(model: _datas[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
              height: 1,
              decoration: BoxDecoration(
                  color: hexStringToColor('#565674'),
                  borderRadius: BorderRadius.circular(1)));
        },
        itemCount: 4);
  }
}
