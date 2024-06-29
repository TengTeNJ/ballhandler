import 'package:code/constants/constants.dart';
import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  Function(int index)? onTap;
  CustomBottomNavigationBar({this.onTap});
  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
        icon: Image(
          image: AssetImage('images/bottom/participants.png'),
          width: 32,
          height: 16,
        ),
        label: 'Participants'),
    BottomNavigationBarItem(
        icon: Image(
            image: AssetImage('images/bottom/airbattle.png'),
            width: 40,
            height: 17
        ),
        label: 'Air Battle'),
    BottomNavigationBarItem(
        icon: Image(
            image: AssetImage('images/bottom/ranking.png'),
            width: 20,
            height: 20
        ),
        label: 'Ranking'),
    BottomNavigationBarItem(
        icon: Image(
          fit: BoxFit.cover,
          image: AssetImage('images/bottom/profile.png'),
          width: 20,
          height: 20,
        ),
        label: 'Profile'),
  ]; // default Items
  final List<Image> _selectedImages = [
   Image(
      image: AssetImage('images/bottom/participants_selected.png'),
      width: 32,
      height: 16,
    ),
    Image(
        image: AssetImage('images/bottom/airbattle_selected.png'),
        width: 40,
        height: 17
    ),
    Image(
        image: AssetImage('images/bottom/ranking_selected.png'),
        width: 20,
        height: 20
    ),Image(
      image: AssetImage('images/bottom/profile_selected.png'),
      width: 20,
      height: 20,
    )
  ]; // 选中状态的图片
  int currentIndex = 0;
  final double iconSize = 24;
  final double selectedFontSize = 10;
  final double unselectedFontSize = 10;
  final double spacing = 6; // 图标和文字之间的间距
  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      backgroundColor: Constants.darkThemeColor,
      currentIndex: currentIndex,
      onTap: (index) async{
        setState(() {
          print(controBlueLightBoard(3, [1,1,0,1]));
          // AirBattle页面登录拦截
         if(index != 0){
           // 判断登录的拦截
           final _hasLogin =  UserProvider.of(context).hasLogin ;
           if(_hasLogin == false){
             //Navigator.pushNamed(NavigatorUtil.utilContext, Routes.login);
             print('Routes.login=${Routes.login}');
            NavigatorUtil.present(LoginPageController(),routesName: Routes.login);
           }else{
             this.currentIndex = index;
             if(widget.onTap != null){
               widget.onTap!(index);
             }
           }

         }else{
           this.currentIndex = index;
           if(widget.onTap != null){
             widget.onTap!(index);
           }
         }

        });
      },
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      selectedItemColor: Constants.baseStyleColor,
      unselectedItemColor: Constants.baseGreyStyleColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.w400,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.w400,
      ),
      items: _items.map((item) {
        return BottomNavigationBarItem(
          icon: _buildIcon(  _items.indexOf(item) == this.currentIndex ? _selectedImages[_items.indexOf(item)]: item.icon, item.label.toString(), _items.indexOf(item) == this.currentIndex ? Constants.baseStyleColor : Constants.baseGreyStyleColor),
          label: item.label,
        );
      }).toList(),
    );
  }

  Widget _buildIcon(Widget icon, String label,Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        SizedBox(height: spacing),
      ],
    );
  }
}

