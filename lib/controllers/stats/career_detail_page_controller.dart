import 'package:code/views/stats/career_list_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/http/profile.dart';
import '../../widgets/navigation/CustomAppBar.dart';
class CareerDetailPageController extends StatefulWidget {
  const CareerDetailPageController({super.key});

  @override
  State<CareerDetailPageController> createState() => _CareerDetailPageControllerState();
}

class _CareerDetailPageControllerState extends State<CareerDetailPageController> {
   int _score = 1000;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryTotalScore();
  }

  queryTotalScore() async{
    final _response = await Profile.queryIMyAccountInfoData();
    print('_response = ${_response.data!.trainScore}');
     if(_response != null && _response.success && _response.data != null){
        _score = _response.data!.trainScore;
        setState(() {

        });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(showBack: true,),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Constants.boldWhiteTextWidget('My Career', 30),
            Expanded(child: CareerListView(score: _score))
          ],
        ),
      ),
    );
  }
}
