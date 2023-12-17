import 'package:capstone_design2/providers/nutrition.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/user.dart';
import '../providers/record.dart';
import 'dart:convert';
import '../my_server.dart';
//import '/appMain.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  String inputID = '';
  String inputPW = '';
  String encryptPW = '';

  late User user;
  late Nutrition nutrition;
  late Record record;
  final myServer = MyServer();

  onPressLogin(id, pw) async {
    try {
      http.Response response = await http.get(Uri.parse("${myServer.login}?id_give=$id&pw_give=$pw"));
      if(response.statusCode == 200 || response.statusCode ==201) {
        if(!mounted) return;
        if(response.body == "0") {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(                                             
              content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("아이디 또는 비밀번호가 잘못되었습니다.")
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('확인'), 
                      onPressed: () {
                      Navigator.of(context).pop();
                            },
                          ),
                        ]
                      );
                    }
          );      
        } else {
          Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
          user.setUser(body['id'], body['name'], body['sex'], body['type'], body['preference'], body['age'], body['height'], body['weight'], body['act']);
          nutrition.setData(body['kcal'], body['carbohydrate'], body['protein'], body['fat']);
          getRecord(id);
          Future.delayed(const Duration(milliseconds: 50), () {
            Navigator.pushNamedAndRemoveUntil(
            context,
            '/main',
            arguments: body['id'],
            (route) => false);  
          });
        }
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
                  Text('로그인 에러')
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text("Error"),
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
  
  String convertHash(String password) {
    const uniqueKey = 'CapDi2';
    final bytes = utf8.encode(password+uniqueKey);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<User>(context);
    nutrition = Provider.of<Nutrition>(context);
    record = Provider.of<Record>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      /*appBar: AppBar(
        //title: const Text('Log in'),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(top: 50)),
          const Center(
            child: Text(
              "로그인",
              style: TextStyle(
                fontSize: 30
              ),
            ),
          ),
          Form(
              child: Theme(
                data: ThemeData(
                    //primaryColor: Colors.grey,
                    inputDecorationTheme: const InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                    padding: const EdgeInsets.all(40.0),
                    // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                    // SingleChildScrollView으로 감싸 줌
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: idController,
                            decoration: const InputDecoration(labelText: 'Enter ID'),
                            keyboardType: TextInputType.text,
                          ),
                          TextField(
                            controller: pwController,
                            decoration: const InputDecoration(labelText: 'Enter password'),
                            keyboardType: TextInputType.text,
                            obscureText: true, // 비밀번호 안보이도록 하는 것
                          ),
                          const SizedBox(height: 40.0,), //로그인 버튼
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: (){
                                  setState(() {
                                    inputID = idController.text;
                                    inputPW = pwController.text;
                                    encryptPW = convertHash(inputPW);                            
                                  });
                                  Future.delayed(const Duration(seconds: 1), () {
                                    onPressLogin(inputID, encryptPW);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: (Colors.lightGreen),
                                    minimumSize: const Size(100, 40)
                                ),
                                  child: const Text('로그인',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),
                                  )
                              )
                          ),                
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}