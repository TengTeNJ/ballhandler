import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
class TTNetImage extends StatefulWidget {
  String url;
  String placeHolderPath;
  double? width;
  double? height;
  BorderRadius? borderRadius;
  BoxFit? fit;
  TTNetImage(
      {required this.url,
        required this.placeHolderPath,
        this.width,
        this.height,
        this.borderRadius ,
        this.fit = BoxFit.fill});

  @override
  State<TTNetImage> createState() => _TTNetImageState();
}

class _TTNetImageState extends State<TTNetImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.url.contains('http')){
      return ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero, // 设置圆角半径
        child:   Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              fit: BoxFit.fill,
              width: widget.width,
              height: widget.height,
              imageUrl: widget.url, // 网络图片URL
              placeholder: (context, url) => placeHolderImage()  , // 加载中的占位符
              errorWidget: (context, url, error) =>placeHolderImage() , // 加载失败的占位符
            )
          ],
        ),
      );
    }else if(widget.url.contains('.png')){
      return  Center(
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.zero, // 设置圆角半径
          child:    Image(image: AssetImage(widget.url),width: widget.width,height: widget.height,fit: widget.fit,),
        ),
      );
    }else{
      if(widget.placeHolderPath.length == 0){
        return Container(
          width: widget.width,
          height: widget.height,
          color: hexStringToColor('#AA9155'),
        );
      }else{
        return  Center(
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero, // 设置圆角半径
            child:    Image(image: AssetImage(widget.placeHolderPath),width: widget.width,height: widget.height,fit: widget.fit,),
          ),
        );
      }

    }
  }
  Widget placeHolderImage(){
    if(!widget.placeHolderPath.contains('png')){
      return Container(
        width: widget.width,
        height: widget.height,
        color: hexStringToColor('#AA9155'),
      );
    }else{
     return  Center(
        child: Image(image: AssetImage(widget.placeHolderPath),width: widget.width,height: widget.height,),
      );
    }
  }

}







