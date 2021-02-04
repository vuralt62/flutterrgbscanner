import 'package:flutter/material.dart';

import 'colorsmodel.dart';
import 'dbHelper.dart';

class RgbToColor extends StatefulWidget {
  @override
  _RgbToColorState createState() => _RgbToColorState();
}

class _RgbToColorState extends State<RgbToColor> {
  GlobalKey anikey;
  TextEditingController redcontroller;
  TextEditingController greencontroller;
  TextEditingController bluecontroller;
  //int r=1,g=1,b=1;
  double r=1;
  double g=1;
  double b=1;
  Color newcolor;
  DbHelper _dbHelper;
  @override
    void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }
  @override
    showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: 140.0,
              right: 155.0,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  //color: Colors.amber
                ),
                
                width: 100,
                height: 100,
                duration: Duration(seconds: 2),
                curve: Curves.decelerate,
                child: Icon(Icons.check, color: Colors.black, size: 75,),
              ),
            ));

// OverlayEntry overlayEntry = OverlayEntry(
//         builder: (context) => Positioned(
//               top: MediaQuery.of(context).size.height / 2.0,
//               width: MediaQuery.of(context).size.width / 2.0,
//               child: CircleAvatar(
//                 radius: 50.0,
//                 backgroundColor: Colors.red,
//                 child: Text("1"),
//               ),
//             ));
    overlayState.insert(overlayEntry);

    await Future.delayed(Duration(seconds: 2));

    overlayEntry.remove();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RGB"),),
      floatingActionButton: 
      FloatingActionButton(
        child: Icon(Icons.save),
        onPressed:()async{
          var colorModel = ColorModel(r.toInt().toString(),g.toInt().toString(),b.toInt().toString());
          await _dbHelper.insertColor(colorModel);
          showOverlay(context);
        } 
        ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
            width: 150,
            height: 150,
            decoration: new BoxDecoration(
                  color: Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 1),
                  borderRadius: BorderRadius.circular(9999999)
                ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('R:${r.toInt()}   G:${g.toInt()}    B:${b.toInt()}',
              style: Theme.of(context).textTheme.display1),
          ),
          Slider(
            min: 1.0,
            max: 255.0,
            inactiveColor: Colors.red,
            activeColor: Colors.red,
            onChanged: (newRating) {
                    setState(() => r = newRating);
            },
            value: r,
          ),
          Slider(
            min: 1.0,
            max: 255.0,
            inactiveColor: Colors.green,
            activeColor: Colors.green,
            onChanged: (newRating) {
                    setState(() => g = newRating);
            },
            value: g,
          ),
          Slider(
            min: 1.0,
            max: 255.0,
            inactiveColor: Colors.blue,
            activeColor: Colors.blue,
            onChanged: (newRating) {
                    setState(() => b = newRating);
            },
            value: b,
          ),
        ],
      )
    );
  }
}