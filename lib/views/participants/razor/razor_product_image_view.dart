import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
class RazorProductImageView extends StatefulWidget {
  String imageName;
  RazorProductImageView({super.key,required this.imageName});

  @override
  State<RazorProductImageView> createState() => _RazorProductImageViewState();
}

class _RazorProductImageViewState extends State<RazorProductImageView> with TickerProviderStateMixin{
  late GifController _controller ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = GifController(vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/razor/razor_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
      width: Constants.screenWidth(context),
      height: 659/719 * Constants.screenWidth(context), // 659/719 图片的高宽比
      child: Center(
        child: Container(
          // color: Colors.red,
          child: Center(
            child: Gif(
             // width: 500,
              //fit: BoxFit.contain,
              useCache:false,
              image: AssetImage(widget.imageName),
              controller: _controller, // if duration and fps is null, original gif fps will be used.
              // fps: 24,
              duration: const Duration(milliseconds: 1500),
              autostart: Autostart.no,
              placeholder: (context) => const Text('Loading...'),
              onFetchCompleted: () {
                print('++++++');
                _controller.reset();
                _controller.forward();
              },
            ),
          ),
         // child: Image .asset(widget.imageName,fit: BoxFit.fill,repeat: ImageRepeat.noRepeat,),
        ),
      )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('GifController----');
    _controller.dispose();
    super.dispose();
  }
}
