import 'package:capstone_design2/main_page/calendar.dart';
import 'package:capstone_design2/main_page/food_record/write_food_detail.dart';
import 'package:capstone_design2/main_page/select_preference.dart';
import 'package:capstone_design2/providers/nutrition.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'registration/login.dart';
import 'registration/join.dart';
import 'package:provider/provider.dart';
import 'providers/food.dart';
import 'providers/user.dart';
import 'providers/history.dart';
import 'providers/record.dart';
import 'providers/recommend.dart';
import 'main_page/my_report.dart';
import 'main_page/my_history.dart';
import 'main_page/my_recommend.dart';
import '/main_page/main_page.dart';
import 'main_page/food_record/select_food.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => User()),
        ChangeNotifierProvider(create: (BuildContext context) => Food()),
        ChangeNotifierProvider(create: (BuildContext context) => History()),
        ChangeNotifierProvider(create: (BuildContext context) => Nutrition()),
        ChangeNotifierProvider(create: (BuildContext context) => Record()),
        ChangeNotifierProvider(create: (BuildContext context) => Recommend()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/' : (context) => const HomeScreen(),
          '/main' : (context) => const MainPage(),
          '/home' : (context) => const MyReport(),
          '/myhistory' : (context) => const MyHistory(),
          '/login' : (context) => const LogIn(),
          '/join1' : (context) => const JoinUser(),
          '/join2' : (context) => const WriteUserInfo(),
          '/selectFood' : (context) => const SelectFood(),
          '/writeFoodDetail' : (context) => const WriteFoodDetail(),
          '/myrecommend' : (context) => const MyRecommend(),
          '/myCalender' : (context) => const MyCalendar(),
          '/selectPreference' : (context) => const SelectPreference()
        },
        debugShowCheckedModeBanner: false,
        title: '식단추천',)
        //home: HomeScreen(),) 
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      /*appBar: AppBar(
        //title: const Text('AI 식단추천'),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),*/
      //extendBodyBehindAppBar: false,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
              children: [
                Text('나만의 맞춤 식단추천',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ))
              ],),

              Image.asset('assets/meal128.png'),
              Column(
                children: [
                  ElevatedButton(
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ButtonStyle(
                      minimumSize:
                      MaterialStateProperty.all(Size(300, 50)),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.lightGreen,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      onPressed: () {
                        //Navigator.pushNamed(context, '/join');

                        Navigator.pushNamed(context, '/join1');
                      },
                      style: ButtonStyle(
                        minimumSize:
                        MaterialStateProperty.all(Size(300, 50)),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.lightGreen,
                        ),
                      ))
                ],
              )
            ],
          ))));
  }
}
