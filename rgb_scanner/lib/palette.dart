import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colorsmodel.dart';
import 'dbHelper.dart';
Future<List<ColorModel>> fetchColorFromDatabase() async {
  var dbHelper = DbHelper();
  Future<List<ColorModel>> colormodel = dbHelper.getColors();
  return colormodel;
}

class SaveColors extends StatefulWidget {
  @override
  _SaveColorsState createState() => _SaveColorsState();
}

class _SaveColorsState extends State<SaveColors> {
  DbHelper _dbHelper;
  @override
    void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("Renkler"),),
      body: FutureBuilder(
      future: fetchColorFromDatabase(),
        builder: (BuildContext context, AsyncSnapshot<List<ColorModel>> snapshot) {
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          if(snapshot.data.isEmpty) return Center(child: Text("Kayıtlı Renk Bulunmamaktadır"),);
          
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index){
              ColorModel colorModel;
              colorModel = snapshot.data[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white,),
                    ),
                secondaryBackground: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white,),
                    ),
                onDismissed: (value){
                    _dbHelper.removeColor(colorModel.red,colorModel.green,colorModel.blue);
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Renk silindi.'),
                    action: SnackBarAction(
                          label: "Geri Al",
                          onPressed: () async {
                            await _dbHelper.insertColor(colorModel);
                            setState(() {});
                          }
                        ),
                      ),
                    );
                },
                child: ListTile(
                  onTap: (){

                  },
                  leading: CircleAvatar( 
                    backgroundColor: Color.fromRGBO(int.parse(colorModel.red), int.parse(colorModel.green), int.parse(colorModel.blue), 1), 
                      
                    ),
                  title: Text("R:"+colorModel.red.toString()+"   G:"+colorModel.green.toString()+"   B:"+colorModel.blue.toString(), style: TextStyle(fontWeight: FontWeight.bold),),

                  
                  ),
              );
            }
          );

          }
    )
    );
  }
}