/*
* 根据总得分获取里程碑数据
* */
Map getScoreMileStoneData(int score) {
  int level = -1;
  List<String> array = [];
  array.add('First Train');
  if (score == 0) {
    return {'data': array, "level": level};
  }
  if (score > 500) {
    int div = (score / 500).toInt();
    for (int i = 1; i <= div; i++) {
      array.add('${500 * i}pts');
    }
    level = div;
    array.add('${500 * (div + 1)}pts');
  } else {
    array.add('500pts');
    level = 0;
  }
  return {'data': array, "level": level};
}

Map getAvgPaceMileStoneData(num avgPace) {
  int level = -1;
  List<String> array = [];
  array.add('First Train');
  if (avgPace == 0) {
    return {'data': array, "level": level};
  }
  if (avgPace < 3) {
    array.add('5 sec/pts');
    array.add('4.5 sec/pts');
    array.add('4.0 sec/pts');
    array.add('3.5 sec/pts');
    array.add('3.0 sec/pts');
    double difference = 3.0 - avgPace;
    int div = (difference / 0.1).toInt();
    if (div == 0) {
      array.add('2.9 sec/pts');
      level = 6;
    } else {
      for (int i = 0; i <= div; i++) {
        array.add('${(3 - 0.1 * i).toStringAsFixed(1)} sec/pts');
      }
      level = 6 + div;
      array.add('${(3 - 0.1 * (div + 1)).toStringAsFixed(1)} sec/pts');
    }
  } else {
    array.add('5 sec/pts');
    if (avgPace > 5) {
      level = 0;
    } else if (avgPace <= 5 && avgPace > 4.5) {
      array.add('4.5 sec/pts');
      level = 1;
    } else if (avgPace <= 4.5 && avgPace > 4) {
      array.add('4.5 sec/pts');
      array.add('4.0 sec/pts');
      level = 2;
    } else if (avgPace <= 4 && avgPace > 3.5) {
      array.add('4.5 sec/pts');
      array.add('4.0 sec/pts');
      array.add('3.5 sec/pts');
      level = 3;
    } else if (avgPace <= 3.5 && avgPace > 3) {
      array.add('4.5 sec/pts');
      array.add('4.0 sec/pts');
      array.add('3.5 sec/pts');
      array.add('3.0 sec/pts');
      level = 4;
    } else if (avgPace == 3.0) {
      array.add('4.5 sec/pts');
      array.add('4.0 sec/pts');
      array.add('3.5 sec/pts');
      array.add('3.0 sec/pts');
      array.add('2.9 sec/pts');
      level = 5;
    }
  }
  return {'data': array, "level": level};
}
