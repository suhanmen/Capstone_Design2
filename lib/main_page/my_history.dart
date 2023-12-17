import 'dart:convert';
import 'package:capstone_design2/my_server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/user.dart';
import '../../providers/history.dart';
import '../../providers/record.dart';
import '../../providers/nutrition.dart';

class MyHistory extends StatefulWidget {
  const MyHistory ({Key? key}) : super(key: key);

  @override
  State<MyHistory> createState() => _MyHistory();
}

class _MyHistory extends State<MyHistory> {

  late History history;
  late User user;
  late Record record;
  late Nutrition nutrition;

  MyServer myServer = MyServer();

  deleteHistory(String index) async {
    try{
      http.Response response = await http.post(Uri.parse(myServer.deleteHistory), 
      body: {'num_give': index});
      if(response.body == "1") {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(                                             
            content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("삭제완료")
                    ],
                  ),
                ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Text('OK'), 
                  onPressed: () {
                    getHistory(user.id); 
                    Navigator.of(context).pop(); 
                  },
                ),
              ]
            );
          }
        );    
      }
    } catch(e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
          content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("에러 발생")
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Text('OK'), 
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                ),
              ]
            );
          }
        );      
      }
    }

    getHistory(String id) async {
    // ignore: unused_local_variable
    http.Response response = await http.get(Uri.parse("${myServer.getHistory}?id_give=$id"));
    String body = utf8.decode(response.bodyBytes);
    List<dynamic> list = jsonDecode(body);
    if(!mounted) return;
    if(list.isEmpty) {
      history.setEmpty();
    } else {
      history.setList = list;
      history.setLength = list.length;   
    }
    getRecord(user.id);   
  }

    getRecord(String id) async {
    try {
      http.Response response = await http.get(Uri.parse("${myServer.getRecord}?id_give=$id"));
      //if(!mounted) return;
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(body);
      //debugPrint(list as String?);
      record.setRecords(list);
      getAnalysis(id);
      } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
            content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('getRecord Error')
              ],
            ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          );
        }
      );                    
    }
  }      

  getAnalysis(String id) async {
    try {
      http.Response response = await http.get(Uri.parse("${myServer.getAnalysis}?id_give=$id"));
      if(!mounted) return;
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      nutrition.setRate(body['carbohydrate'], body['protein'], body['fat']);
    } catch(e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
            content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('getAnalysis Error')
              ],
            ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          );
        }
      ); 
    }
  }   

  @override
  Widget build(BuildContext context) {

    history = Provider.of<History>(context);
    user = Provider.of<User>(context);
    record = Provider.of<Record>(context);
    nutrition = Provider.of<Nutrition>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('섭취 기록' , style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: Colors.lightGreen,
        ),
      //resizeToAvoidBottomInset: false,
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          if(history.length == 0) {
            return const Text("기록이 없습니다.");
          } else {
            return Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                title: 
                  Text(history.foodName[index]),
                subtitle: 
                  Text("${history.foodDate[index]}  섭취량: ${history.foodAmount[index]}인분 총${history.foodTotal[index]}g"),
                trailing: 
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteHistory(history.foodIndex[index]);
                    },)
              ),
            );
          } 
        }
      ),
    );
  }
}