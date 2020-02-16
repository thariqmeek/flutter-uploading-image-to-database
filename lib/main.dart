import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scan And Upload to database",
      home: MyHomePage(),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  bool _uploaded;
  String _downloadUrl;
  StorageReference _reference = FirebaseStorage.instance.ref().child('myimg.jpg');


  Future getImage (bool isCamera) async {
    File image;
    if(isCamera){
      image = await ImagePicker.pickImage(source: ImageSource.camera);

    }else{
      image = await  ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });

  }

  Future uploadImage () async{
    StorageUploadTask uploadTask = _reference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      _uploaded = true;
    });
}

Future downloadImage() async{
    String downloadAddress = await _reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
    (
      title: Text('IMAGE TO DATABASE'),
      centerTitle: true,
      backgroundColor: Colors.red[600],
    ),
    body: SingleChildScrollView(
      child:Center(
              child: Column(children: <Widget>[
          RaisedButton(
            child: Text('TAKE SNAP'),
            
            onPressed: ()
            
            {
              getImage(true);


            },
            
            color: Colors.amber,),
            SizedBox(height:10.0,),
              
            
            RaisedButton(
              child: Text ('Take FROM GALLERY'),
              
              
              onPressed: (){
                getImage(false);


              },
              color: Colors.amber,),
              _imageFile == null ? Container() : Image.file(
                _imageFile, 
                height: 300.0, 
                width: 300.0),
                _imageFile == null ? Container(child: Text('NOTHING')): RaisedButton(
                  child: Text( "UPLOAD"),
                  onPressed: ()
                  
                  {

                    uploadImage();
                  },
                  color: Colors.amber,),
                  _uploaded ==false ? Container(child : Text( 'NOT UPLOADED')): RaisedButton(child : Text ('DOWNLOAD IMAGE'),
                  onPressed: ()
                  {
                      downloadImage();

                  }
                  
                  ),
                  _downloadUrl == null? Container() : Image.network(_downloadUrl), 

              

        ],),
      )
    ),
      
    );
  }
}