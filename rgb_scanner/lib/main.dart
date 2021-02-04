import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'colorsmodel.dart';
import 'dbHelper.dart';
import 'palette.dart';
import 'rgbtocolors.dart';

void main() => runApp(Main());
Color selectedColor;
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
GlobalKey appkey = GlobalKey();

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class _MainPageState extends State<MainPage> {
  int pixel32;
  var image;
  var _image;
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();
  String imagePath;
  DbHelper _dbHelper;

  // CHANGE THIS FLAG TO TEST BASIC IMAGE, AND SNAPSHOT.
  bool useSnapshot = true;

  // based on useSnapshot=true ? paintKey : imageKey ;
  // this key is used in this example to keep the code shorter.
  GlobalKey currentKey;

  final StreamController<Color> _stateController = StreamController<Color>();
  img.Image photo;

  showPoint(BuildContext context, Offset point) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
         builder: (context) => Positioned(

              top: point.dy-20,
              left: point.dx-20,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    style: BorderStyle.solid,
                  )
                ),
                
                width: 40,
                height: 40,
                duration: Duration(seconds: 1),
                curve: Curves.decelerate,
                child: Icon(Icons.add),
              ),
            ));
    overlayState.insert(overlayEntry);

    await Future.delayed(Duration(seconds: 1));

    overlayEntry.remove();
  }

  @override
  void initState() {
    currentKey = useSnapshot ? paintKey : imageKey;
    _dbHelper = DbHelper();
    super.initState();
  }
  Future getImage() async {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
  /*Future getImageCamera() async {

    image = await ImagePicker.pickImage(source: ImageSource.camera);
    

    setState(() {
      _image = image;
    });
  }*/

  @override

  

  showOverlay(BuildContext context, bool err) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: 140.0,
              right: 145.0,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  color: Color.fromRGBO(r, g, b, 1)
                ),
                
                width: 100,
                height: 100,
                duration: Duration(seconds: 2),
                curve: Curves.decelerate,
                child: Icon(err==true?Icons.check:Icons.cancel, color: Colors.white, size: 75,),
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
    //final String title = useSnapshot ? "snapshot" : "basic";

    return MaterialApp(
      
      home: Scaffold(
        floatingActionButton: SpeedDial(
          backgroundColor: selectedColor,
          overlayOpacity: 0,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              onTap: getImage,
              child: Icon(Icons.photo),
              backgroundColor: selectedColor == Colors.white ? selectedColor=Colors.blue:selectedColor,
            ),
            /*SpeedDialChild(
              onTap: (){
                getImage(false);
              },
              child: Icon(Icons.camera_alt),
              backgroundColor: selectedColor == Colors.white ? selectedColor=Colors.blue:selectedColor,
            ), */
            SpeedDialChild(
              child: Icon(Icons.color_lens),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => SaveColors()));
              },
              backgroundColor: selectedColor == Colors.white ? selectedColor=Colors.blue:selectedColor,
            ),
            SpeedDialChild(
              onTap: () async {
                if (_image!=null) {

                  var colorModel = ColorModel(r.toString(),g.toString(),b.toString());

                  await _dbHelper.insertColor(colorModel);
                  showOverlay(context, true);
                }
                else{
                  showOverlay(context, false);
                }
                  
                },
                child: Icon(Icons.save),
                backgroundColor: selectedColor == Colors.white ? selectedColor=Colors.blue:selectedColor,
            ),
            SpeedDialChild(
              backgroundColor: selectedColor == Colors.white ? selectedColor=Colors.blue:selectedColor,
              child: Icon(Icons.colorize),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => RgbToColor()),);
              },
            ),
          ],
        ),
        /*Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: (){
                  //showOverlay(context);
                  //_dbHelper.removeAll();
                },
              ),
              FloatingActionButton(
                heroTag: "rgbtocolor",
                child: Icon(Icons.colorize),
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => RgbToColor()),);
                },
              ),
              Container(width: 20,height: 20),
              FloatingActionButton(
                
                heroTag: "save",
                onPressed: () async {
                  if (r!=0 && g!= 0 && b!=0) {

                    var colorModel = ColorModel(r.toString(),g.toString(),b.toString());

                    await _dbHelper.insertColor(colorModel);
                    showOverlay(context);
                  }
                  
                },
                child: Icon(Icons.save),
              ),
              Container(width: 20,height: 20),
              FloatingActionButton(
                heroTag: "showcolors",
                child: Icon(Icons.color_lens),
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => SaveColors()));
                },
              ),
              Container(width: 20,height: 20),
              FloatingActionButton(
                heroTag: "getImage",
                onPressed: getImage,
                child: Icon(Icons.photo),
                ),
              
            ],
          ),*/
        body: StreamBuilder(
              initialData: Colors.white,
              stream: _stateController.stream,
              builder: (buildContext, snapshot) {
                selectedColor = snapshot.data ?? Colors.white;
                return Stack(
                  children: <Widget>[
                    RepaintBoundary(
                      
                      key: paintKey,
                      child: GestureDetector(
                        onPanDown: (details) async{

                          showPoint(context,details.globalPosition);
                          await searchPixel(details.globalPosition);
                          
                        },
                        /*onPanUpdate: (details) async {
                          await searchPixel(details.globalPosition);
                          
                        },*/
                        
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
                          child: Center(
                            child: _image == null ? Text('Resim Seçilmedi.',
                            style: TextStyle(color: Colors.black, fontSize:10, decorationStyle: TextDecorationStyle.dotted),) 
                            : Image.file(_image,fit: BoxFit.scaleDown,key: imageKey,),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.all(70),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 101),
                      width: 5000,
                      height: 80,
                      decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          color: selectedColor == Colors.white ? selectedColor=Colors.blue:selectedColor,
                          //border: Border.all(width: 2.0, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 8))
                          ]),
                    ),
                    Positioned(
                      child: Text('${rgbs==null?rgbs='RGB Scanner':rgbs}',
                          style: TextStyle(
                              color: Colors.white, fontSize: 23, 
                                shadows:[Shadow(blurRadius: 5, color: Colors.black12,offset: Offset(0, 0))] 
                                  ),
                                ),
                      left: 10,
                      top: 40,
                    ),
                  ],
                );
              }),
      )
    );
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }else if(photo != _image){
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey.currentContext.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    if (!useSnapshot) {
      double widgetScale = box.size.width / photo.width;
      px = (px / widgetScale);
      py = (py / widgetScale);
    }
    width =px;
    height = py;
    pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    hex = abgrToArgb(pixel32);
    _stateController.add(Color(hex));
    hexTorgb(hex);
  }

double height;
double width;

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext.findRenderObject();
    ui.Image capture = await boxPaint.toImage();
    ByteData imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}

int hex;
int r=0,g=0,b=0;
String rgbs;

hexTorgb (int hex)async{
  String temp = Color(hex).toString();
  temp = temp.replaceAll('Color(0xff', '');
  temp = temp.replaceAll(')', '');
  //hex = int.parse(temp);
  List<String> temp2 = temp.split('');
  for (var i = 0; i < 6; i++) {
    switch (temp2[i]) {
      case 'a':
        temp2[i]='10';
        break;
      case 'b':
        temp2[i]='11';
        break;
      case 'c':
        temp2[i]='12';
        break;
      case 'd':
        temp2[i]='13';
        break;
      case 'e':
        temp2[i]='14';
        break;
      case 'f':
        temp2[i]='15';
        break;
      default: break;
    }
  }
  r= (int.parse(temp2[0])*16)+ int.parse(temp2[1]);
  g= (int.parse(temp2[2])*16)+ int.parse(temp2[3]);
  b= (int.parse(temp2[4])*16)+ int.parse(temp2[5]);
  rgbs = 'R:'+r.toString()+' G:'+g.toString()+' B:'+b.toString();
  return await rgbs;
}