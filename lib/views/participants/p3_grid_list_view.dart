import 'package:code/models/airbattle/p3_item_model.dart';
import 'package:code/views/participants/p3_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class P3GridListView extends StatefulWidget {
  const P3GridListView({super.key});

  @override
  State<P3GridListView> createState() => _P3GridListViewState();
}

class _P3GridListViewState extends State<P3GridListView> {

  int selectCount = 0;
  late List<P3ItemModel> _datas;
  List<P3ItemModel> _selectModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datas = [];
    for(int i = 0; i <10; i++){
      P3ItemModel model = P3ItemModel();
      model.index = i;
      _datas.add(model);
    }
  }

  void _selectItem(index){
    P3ItemModel model = _datas[index];
    if(model.selected){
      selectCount ++;
      model.selectedIndex = selectCount;
      _selectModels.add(model);
    }else{
      selectCount --;
      _selectModels.remove(model);
      _selectModels.forEach((element) {
        if(element.selectedIndex  > model.selectedIndex){
          element.selectedIndex --;
        }
      });
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1141,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              P3ItemView(model: _datas[0],selectItem: _selectItem,),
              SizedBox(
                width: 4,
              ),
              P3ItemView(model: _datas[1],selectItem: _selectItem)
            ],
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              P3ItemView(model: _datas[2],selectItem: _selectItem),
              SizedBox(
                width: 4,
              ),
              P3ItemView(model: _datas[3],selectItem: _selectItem)
            ],
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              P3ItemView(model: _datas[4],selectItem: _selectItem),
              SizedBox(
                width: 4,
              ),
              P3ItemView(model: _datas[5],selectItem: _selectItem)
            ],
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              P3ItemView(model: _datas[6],selectItem: _selectItem),
              SizedBox(
                width: 4,
              ),
              P3ItemView(model: _datas[7],selectItem: _selectItem)
            ],
          ),
          SizedBox(height: 4,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              P3ItemView(model: _datas[8],selectItem: _selectItem),
              SizedBox(
                width: 4,
              ),
              P3ItemView(model: _datas[9],selectItem: _selectItem)
            ],
          ),
          SizedBox(height: 4,),
        ],
      ),
    );
  }
}
