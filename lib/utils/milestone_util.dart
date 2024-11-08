/*
* 根据总得分获取里程碑数据
* */
Map getScoreMileStoneData(int score) {
  int level = -1;
  List<String> array = [];
  array.add('First Train');
  // sec/pts
  List<num> _avgDatas = [500,2500,5000,15000,20000,25000,30000,35000,40000,50000];
  for(int i = 0; i < _avgDatas.length; i++){
    array.add('${_avgDatas[i]}pts');
  }
  num _map = _avgDatas.lastWhere((element)  => element <= score,orElse: () => -1 );
  if(_map != -1){
    int index = _avgDatas.indexOf(_map);
    level = index + 1;
  }else{
    if(score > 0){
      level = 0;
    }
  }
  return {'data': array, "level": level};
}

Map getAvgPaceMileStoneData(num avgPace) {
  int level = -1;
  List<String> array = [];
  array.add('First Train');
  // sec/pts
  List<num> _avgDatas = [5,4.5,4,3.5,3,2.5,2,1.5,1,0.5];
  for(int i = 0; i < _avgDatas.length; i++){
    array.add('${_avgDatas[i]} sec/pts');
  }
  num _map = _avgDatas.lastWhere((element)  => element >= avgPace, orElse: () => -1);
  if(_map != -1 && avgPace != 0){
    int index = _avgDatas.indexOf(_map);
    level = index + 1;
  }else{
    if(avgPace > 0){
      level = 0;
    }
  }
  return {'data': array, "level": level};
}
