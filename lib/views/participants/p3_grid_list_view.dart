import 'package:code/models/airbattle/p3_item_model.dart';
import 'package:code/views/participants/p3_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class P3GridListView extends StatefulWidget {
  Function?selectItem;
   P3GridListView({this.selectItem});

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
    List<String> _paths = ['dekes','zigzag','drag','triangles','backhand','legs','figure','handed'];
    List<String> _titles = ['Wide Dekes','Zigzag','Toe Drag','Triangles','Backhand','Through the legs','Figure 8','One handed'];
    List<int> _times = [30,30,30,30,30,30,30,30];
    for(int i = 0; i <_paths.length; i++){
      P3ItemModel model = P3ItemModel();
      model.index = i;
      model.timeString = _times[i].toString() + 's';
      model.title = _titles[i];
      model.imagePath = _paths[i];
      _datas.add(model);
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
