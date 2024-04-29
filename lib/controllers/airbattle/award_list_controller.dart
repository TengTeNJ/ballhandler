import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/award_model.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/services/http/profile.dart';
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
  List<AwardModel>_datas = [];
 int _page = 1;
 bool hasMore = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryAwardListData();
  }

  queryAwardListData({bool loadMore = false}) async{
    if(loadMore){
      TTToast.showLoading();
    }
    final _response = await AirBattle.queryMyAwardData(_page);
    if(_response.success && _response.data != null ){
      _datas.addAll(_response.data!.data);
      hasMore = _datas.length < _response.data!.count;
      setState(() {

      });
    }
    if(loadMore){
      TTToast.hideLoading();
    }

  }

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
              datas: _datas,
              loadMore: (){
                if(hasMore){
                  _page ++ ;
                  queryAwardListData(loadMore: true);
                }
              },
              selectItem: (AwardModel model) {
                model.rewardStatus = 1;
                setState(() {

                });
                TTDialog.awardDialog(context,() async{
                  //await AirBattle.readAwardMessage(model.re)
                });
              },
            ))
          ],
        ),
      ),
    );
  }
}
