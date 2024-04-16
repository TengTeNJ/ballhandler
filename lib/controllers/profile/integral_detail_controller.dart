import 'package:code/constants/constants.dart';
import 'package:code/services/http/profile.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/profile/integral_detail_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

class IntegralDetailController extends StatefulWidget {
  const IntegralDetailController({super.key});

  @override
  State<IntegralDetailController> createState() =>
      _IntegralDetailControllerState();
}

class _IntegralDetailControllerState extends State<IntegralDetailController> {
  List<IntegralModel>_datas = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryIntegralListData();
  }
  queryIntegralListData() async{
    final _response = await Profile.queryIntegralListData(1);
    if(_response.success && _response.data != null){
      _datas.addAll(_response.data!);
      setState(() {

      });
    }else{

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
        title: 'Points Details ',
      ),
      body: Column(children:[
        Expanded(
          child: _datas.length > 0 ? ListView.separated(
              itemBuilder: (context, index) {
                return IntegralView(model: _datas[index],);
              },
              separatorBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(color: hexStringToColor('#565674')),
                height: 1,
              ),
              itemCount: _datas.length) :NoDataView(),
        )
      ] ,),
    );
  }
}
