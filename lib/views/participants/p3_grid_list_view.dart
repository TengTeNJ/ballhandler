import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/p3_item_model.dart';
import 'package:code/views/participants/p3_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class P3GridListView extends StatefulWidget {
   Function?selectItem;
   List<P3ItemModel>? selectedItemIndexs;
   P3GridListView({this.selectItem,this.selectedItemIndexs});

  @override
  State<P3GridListView> createState() => _P3GridListViewState();
}

class _P3GridListViewState extends State<P3GridListView> {

  int selectCount = 0;
  late List<P3ItemModel> _datas; // 初始化数据展示的
  List<P3ItemModel> _selectModels = []; // 选中的

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datas = [];
    List<String> _paths = ['dekes','zigzag','drag','triangles','backhand','legs','figure','handed'];
    List<String> _titles = ['Wide Dekes','Zigzag','Toe Drag','Triangles','Backhand','Through the legs','Figure 8','One handed'];
    // 初始化数据
    for(int i = 0; i <_paths.length; i++){
      Map<String,int>? _map = kP3IndexAndDurationMap[i];
      int? time = _map?['second'];
      P3ItemModel model = P3ItemModel();
      model.index = i;
      model.timeString = time.toString() + 's';
      model.title = _titles[i];
      model.imagePath = _paths[i];
      P3ItemModel matchModel = model;
      // 记录上次选择的
      if(widget.selectedItemIndexs != null){
        matchModel = widget.selectedItemIndexs!.firstWhere((element)=>element.title == model.title,orElse: (){
          return model;
        });
      }
      if(matchModel.selectedIndex != 0){
        selectCount ++;
        _selectModels.add(matchModel);
      }
      _datas.add(matchModel);
    }
  }

  void _selectItem(index){
    P3ItemModel model = _datas[index];
    if(model.selected){
      selectCount ++;
      model.selectedIndex = selectCount;
      _selectModels.add(model);
      if(widget.selectItem != null){
        widget.selectItem!(_selectModels);
      }
    }else{
      selectCount --;
      _selectModels.remove(model);
      _selectModels.forEach((element) {
        if(element.selectedIndex  > model.selectedIndex){
          element.selectedIndex --;
        }
      });
      if(widget.selectItem != null){
        widget.selectItem!(_selectModels);
      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 814,
      child: SingleChildScrollView(child: Column(
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
        ],
      ),),
    );
  }
}
