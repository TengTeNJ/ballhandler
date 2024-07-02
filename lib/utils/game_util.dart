import 'package:code/constants/constants.dart';

import '../models/game/light_ball_model.dart';

List<LightBallModel> initUltimateLightModels() {
  List<LightBallModel> _list = [];
  List<double> _lefts = [
    0.0526,
    0.170,
    0.108,
    0.1177,
    0.145429,
    0.295,
    0.295,
    0.363,
    0.422,
    0.611,
    0.5512,
    0.673,
    0.673,
    0.835,
    0,
    0,
    0,
    0
  ];
  List<double> _rights = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0.1150,
    0.108,
    0.170,
    0.0526
  ];
  List<double> _bottoms = [
    0.0842,
    0.0842,
    0.236,
    0.342,
    0.6712,
    0.818,
    0.5679,
    0.679,
    0.6956,
    0.679,
    0.6956,
    0.818,
    0.5679,
    0.6712,
    0.342,
    0.236,
    0.0842,
    0.0842
  ];
  for(int i = 0; i<_lefts.length; i ++){
    LightBallModel model = LightBallModel(color: Constants.baseLightRedColor);
    model.left = _lefts[i];
    model.right = _rights[i];
    model.bottom = _bottoms[i];
    model.show = true;
    if([2,7,10,13].contains(i)){
      model.color = Constants.baseLightBlueColor;
    }
    _list.add(model);
  }
  return _list;
}
