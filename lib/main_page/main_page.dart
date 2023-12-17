// ignore_for_file: use_build_context_synchronously
import 'package:capstone_design2/main_page/calendar.dart';
//import 'package:capstone_design2/main_page/select_category.dart';
import 'package:flutter/material.dart';
//import 'my_history.dart';
import 'my_profile.dart';
import 'my_report.dart';
import 'my_recommend.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../my_server.dart';
import '../providers/food.dart';
import '../providers/history.dart';
import '../providers/recommend.dart';
import '../providers/user.dart';
import '../providers/nutrition.dart';
import '../providers/record.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  late User user;
  late Food food;
  late History history;
  late Nutrition nutrition;
  late Recommend recommend;
  late Record record;

  int _selectedIndex = 1; //선택된 페이지의 인덱스 번호 초기화
  String title = "영양 분석"; //AppBar title 처음에는 Home

  final List<Widget> _widgetOptions = <Widget>[
    const MyRecommend(),
    const MyReport(),
    const MyCalendar()
    //const MyHistory(),
  ]; // 연결할 페이지 지정

  final myServer = MyServer();

  void getHistory(String id) async {
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
  } 

  getAnalysis(String id) async {
    try {
      http.Response response = await http.get(Uri.parse("${myServer.getAnalysis}?id_give=$id"));
      if(!mounted) return;
      Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      nutrition.setRate(body['carbohydrate'], body['protein'], body['fat']);
    } catch(e) {
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

  void getNutrition(String id) async {
    http.Response response = await http.get(Uri.parse("${myServer.getNutrition}?id_give=$id"));
    String body = utf8.decode(response.bodyBytes);
    List<dynamic> list = jsonDecode(body);
    if(!mounted) return;
    nutrition.setData(list[0]['kcal'], list[0]['carbohydrate'], list[0]['protein'], list[0]['fat']);    
  }

  void getRecommend(String id, String label) async {
    // ignore: unused_local_variable
    http.Response response = await http.get(Uri.parse("${myServer.getRecommend}?id_give=$id&label_give=$label"));
    String body = utf8.decode(response.bodyBytes);
    List<dynamic> list = jsonDecode(body);
    if(!mounted) return;
    recommend.setList = list;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch(index) { //AppBar title 변경
        case 0: 
          getRecommend(user.id, user.preference);
          title = "추천 음식";
        case 1: 
          getNutrition(user.id);
          //Future.delayed(const Duration(seconds: 1), () {
          //  getAnalysis(user.id);
          //}); 
          title = "영양 분석";

        case 2: 
        getHistory(user.id);
        title = "나의 기록";
      }
    }); // 탭을 클릭했을 때 지정한 페이지로 이동
  }

  void _floatingActionButtonTapped() async{
    try {
      http.Response response = await http.get(Uri.parse(myServer.food));
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(body);
      Navigator.pushNamed(context, '/selectFood', arguments: list);
    } catch(e) {
      showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(                                             
              content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Error") 
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

  @override
  Widget build(BuildContext context) {

    user = Provider.of<User>(context);
    food = Provider.of<Food>(context);
    history = Provider.of<History>(context);
    recommend = Provider.of<Recommend>(context);
    record = Provider.of<Record>(context);
    nutrition = Provider.of<Nutrition>(context);

    //getAnalysis(user.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
        onPressed: (){
          food.setId = user.id;
          _floatingActionButtonTapped();
        },
        child: const Icon(Icons.add)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: "추천"),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "분석"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: "기록"),
        ],
        currentIndex: _selectedIndex, //지정인덱스로 이동
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            const SizedBox(
              height: 110,
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                  ),
                  child: Text(
                    "카테고리",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.white),
                  )),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white24),
                elevation: MaterialStateProperty.all(0),
              ),
              child: const Row(
                children: [
                  Icon(Icons.person, color: Colors.green),
                  SizedBox(width: 20),
                  Text(
                    '내 정보',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const MyPage()));
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white24),
                elevation: MaterialStateProperty.all(0),
              ),
              child: const Row(
                children: [
                  Icon(Icons.storage, color: Colors.green),
                  SizedBox(width: 20),
                  Text(
                    '전체 기록',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                getHistory(user.id);
                Navigator.pushNamed(context, '/myhistory');
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white24),
                elevation: MaterialStateProperty.all(0),
              ),
              child: const Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.green),
                  SizedBox(width: 20),
                  Text(
                    '로그아웃',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(                                             
                      content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('로그이웃 하시겠습니까?')
                        ],
                      ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey)
                          ),
                          child: const Text("취소"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.lightGreen)
                          ),
                          child: const Text("확인"),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false);  
                            user.clear();
                            food.clear();
                            history.clear();
                            nutrition.clear();
                            recommend.clear();
                            record.clear();
                          },
                        ),
                      ]
                    );
                  }
                ); 
              },
            )
          ]
        )
      )
    );
  }
  @override
  void initState() {
    super.initState();
  }

  @override dispose() {
    super.dispose();
  }
}