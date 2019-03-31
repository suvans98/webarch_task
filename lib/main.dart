import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data;
  Future<Jokes> post;
  String url="https://official-joke-api.appspot.com/random_joke";
  var response;
  Future<Jokes> getData() async {

     response =
        await http.get(url, headers: {"Accept": "application/json"});

     if (response.statusCode == 200) {
       return Jokes.fromJson(json.decode(response.body));
     } else {
       throw Exception('Failed to load post');
     }



  }

   changeApi()
  {
    setState(() {
      if (response.statusCode == 200) {
        return Jokes.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    });
  }

@override

void initState()
{
  super.initState();
  this.getData();
}


  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    // TODO: implement build
    return Scaffold(

      key: key,
      backgroundColor: Colors.amberAccent,
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FutureBuilder<Jokes>(
              future:
                  getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //checks if the response returns valid data
                  return Center(


                      child: Column(

                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Container(
                            color:Colors.white,
                            margin: new EdgeInsets.only(

                              bottom: 100.0,
                            ),
                            child: Text(
                                "Random Jokes Generator",
                              style: TextStyle(fontSize: 28.0, fontFamily: "Roboto"),
                            ),
                          ),

                          Container(

                            child: Column(

                              children: <Widget>[

                                new GestureDetector(

                                  child: new Text(
                                    snapshot.data.setup ,
                                    style: TextStyle(fontFamily: "Roboto", fontSize: 27.0 ),

                                  ),
                                  onLongPress: ()
                                  {
                                    Clipboard.setData(new ClipboardData(text: snapshot.data.setup, ));
                                    key.currentState.showSnackBar(
                                        new SnackBar(content: new Text("Copied to Clipboard"),));
                                  },
                                ),

                                SizedBox(
                                  height: 10.0,
                                ),

                                new GestureDetector(

                                  child: new Text(
                                    " - ${snapshot.data.punchline}",
                                    style: TextStyle(fontFamily: "Roboto", fontSize: 17.0),
                                  ),

                                  onLongPress: ()
                                  {

                                    Clipboard.setData(new ClipboardData(text: snapshot.data.punchline));
                                    key.currentState.showSnackBar(
                                        new SnackBar(content: new Text("Copied to Clipboard"),));
                                  },

                                ),

                              ],

                            ),

                          ),



                        ],
                      ),
                  );
                } else if (snapshot.hasError) {
                  //checks if the response throws an error
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
            SizedBox(
              height: 25.0,
            ),
            new RaisedButton(
                onPressed: changeApi,
                color: Colors.pinkAccent,
                child: Text("Press for a new joke", style: TextStyle(color: Colors.white,)),
            )


          ],
        ),
      ),
    );
  }
}

class Jokes {
  final String setup;
  final String punchline;

  Jokes({this.setup, this.punchline});

  factory Jokes.fromJson(Map<String, dynamic> json) {
    return Jokes(setup: json['setup'], punchline: json['punchline']);
  }
}

