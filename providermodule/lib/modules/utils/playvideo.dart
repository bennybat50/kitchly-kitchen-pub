import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class PlayVideo extends StatefulWidget {
  final bool online;
  final String url;
  const PlayVideo({Key key, this.online, this.url}) : super(key: key);
  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(Ionicons.ios_close,size: 40,),
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical:28.0),
        child: Center(
          child: widget.url==null?Text('No video file available',style: TextStyle(color: Colors.white),):SingleChildScrollView(
            child:Text("Video")
          ),
        ),
      ),
    );
  }
}
