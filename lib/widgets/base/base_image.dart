import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class TTNetImage extends StatelessWidget {
  String url;
  String placeHolderPath;
  double width;
  double height;
  BorderRadius? borderRadius;

  TTNetImage(
      {required this.url,
      required this.placeHolderPath,
      required this.width,
      required this.height,
      this.borderRadius });

  @override
  Widget build(BuildContext context) {
    if(url.contains('http')){
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero, // 设置圆角半径
        child: Image.network(
          url,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Center(
              child: Image(image: AssetImage(placeHolderPath),width: width,height: height,),
            );
          },
          fit: BoxFit.fill,
          width: width,
          height: height,
        ),
      );
    }else{
      return  Center(
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero, // 设置圆角半径
          child: Image(image: AssetImage(placeHolderPath),width: width,height: height,fit: BoxFit.fill,),
        ),
      );
    }
  }
}
