import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KropLka',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

Stream<QuerySnapshot> _serchStream (String _fild, _conditionData){
  return Firestore.instance.collectionGroup(_path).where(_fild, isEqualTo: _conditionData).snapshots();

}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}
const String _path = 'bard-test-1';
class _MyHomePageState extends State<MyHomePage> {
  StreamController<QuerySnapshot> _streamController = new StreamController();
  Stream<QuerySnapshot> _firestoreList = Firestore.instance.collectionGroup('bard-test-1').snapshots();

  TextEditingController _textEditingController = new TextEditingController();



  int index = 0;

  @override

  void _cancelSerch(){
    setState(() {


      _firestoreList = Firestore.instance.collection(_path).snapshots();
      _textEditingController.text = "";
    });
  }

  void _dataGetFirebaseSnapshot() {
    setState(() {
      print('in funcion');
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_textEditingController.text.isEmpty){
        _firestoreList = Firestore.instance.collection(_path).snapshots();
      }else {
        _firestoreList = Firestore.instance.collection(_path).where(
            'title', isEqualTo: _textEditingController.text).snapshots();
      }


      //TODO:make serching by more data

      //_streamController.close();



      //_streamController.addStream(Firestore.instance.collection(_path).where('usser', isEqualTo: _textEditingController.text).snapshots());



    });
  }


  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title:
          Row(
            children: <Widget>[

             SizedBox.fromSize(

               size: Size.fromWidth(200),
               child:TextFormField(
                decoration: InputDecoration(
                  labelText: 'Serch'
                ),
                controller: _textEditingController,
              ),
             ),
              IconButton(
                icon: Icon(
                  Icons.cancel
                ),
                onPressed: _cancelSerch,

              )
            ],
          ),

      ),
      body: Center(

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
       child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreList,
         // stream: Firestore.instance.collection('events').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
            //_dataGetFirebaseSnapshot();
            //while (!snapshot.hasData){
              //print('...');
            //}
            if (!snapshot.hasData) return const Text('Loading...');
            print("...");
            return new ListView(

            //return _buildListItems(snapshot);
              children: snapshot.data.documents.map((DocumentSnapshot document)
            {
              return new ListTile(
                title:Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.teal,
                    ),
                    Column(
                        children: [
                          Text(document['title']),
                          Text(document['usser']),

                        ]
                    )
                  ]
              ),
              );

          }

            ).toList()
            );

          }
    )


      ),
        floatingActionButton: FloatingActionButton(
          onPressed: _dataGetFirebaseSnapshot,
          tooltip: 'Increment',
          child: Icon(Icons.search),
    )
    );






              //_buildListItems(_firestorelist)






            // This trailing comma makes auto-formatting nicer for build methods.


          }
  }

