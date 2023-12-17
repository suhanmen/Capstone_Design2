import 'dart:convert';
import 'package:capstone_design2/my_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';
import '../providers/nutrition.dart';
import '../providers/history.dart';
import '../providers/food.dart';
import '../providers/recommend.dart';
import '../providers/record.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  late User user;
  late Nutrition nutrition;
  late History history;
  late Food food;
  late Recommend recommend;
  late Record record;

  String inputAct = '';
  String inputType = '';
  int inputHeight = 0;
  int inputWeight = 0;
  int inputAge = 0;

  MyServer myServer = MyServer();

  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  void getNutrition(String id) async {
    try {
      http.Response response = await http.get(Uri.parse("${myServer.getNutrition}?id_give=$id"));
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(body);
      if(!mounted) return;
      nutrition.setData(list[0]['kcal'], list[0]['carbohydrate'], list[0]['protein'], list[0]['fat']);   
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

                Text('getNutrition error')
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

  void deleteUser(String id) async {
    http.Response response = await http.post(Uri.parse(myServer.deleteUser), body: {'id_give': id});
    if(!mounted) return;
    if(response.body == "1") {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);  
      user.clear();
      food.clear();
      history.clear();
      nutrition.clear();
      recommend.clear();
      record.clear();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
          content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('회원탈퇴 오류')
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


  editProfile (String id, String sex, int age, int height, int weight, String type, String act) async {
    try{
      http.Response response = await http.post(Uri.parse(myServer.editProfile), 
      body: {'id_give': id, 'sex_give': sex, 'age_give': age.toString(), 'type_give': type, 'height_give': height.toString(), 'weight_give': weight.toString(), 'act_give': act});
      if(!mounted) return;
      if(response.body == "1") {
        user.editHeight(height);
        user.editWeight(weight);
        user.editAge(age);
        user.editAct(int.parse(act));
        user.editType(type);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(                                             
            content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('프로필 변경 완료')
                    ],
                  ),
                ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Text("OK"),
                  onPressed: () {
                    getNutrition(id);
                    Navigator.of(context).pop();
                  },
                ),
              ]
            );
          }
        );  
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(                                             
            content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('response error')
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
              Text('Error')
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
    user = Provider.of<User>(context);
    nutrition = Provider.of<Nutrition>(context);

    late String userAct;
    late String userType;
    late int userHeight;
    late int userWeight;
    late int userAge;

    if(inputAct != '') {
      userAct = inputAct;
    } else {
      userAct = user.act.toString();
    }

    if(inputType != '') {
      userType = inputType;
    } else {
      userType = user.type;
    }

    if(inputHeight > 0) {
      userHeight = inputHeight;
    } else {
      userHeight = user.height;
    }

    if(inputWeight > 0) {
      userWeight = inputWeight;
    } else {
      userWeight = user.weight;
    }

    if(inputAge > 0) {
      userAge = inputAge;
    } else {
      userAge = user.age;
    }

    editAge() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
            content: SingleChildScrollView(
              child: TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: '나이 입력',
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    inputAge = int.parse(value!);
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("닫기"),
                onPressed: () {
                  setState(() {
                    inputAge = 0;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("수정"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          );
        }
      );   
    }

    editHeight() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
            content: SingleChildScrollView(
              child: TextFormField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: '키(cm) 입력',
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    inputHeight = int.parse(value!);
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("닫기"),
                onPressed: () {
                  setState(() {
                    inputHeight = 0;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("수정"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          );
        }
      );   
    }

    editWeight() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
            content: SingleChildScrollView(
              child: TextFormField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: '몸무게(kg) 입력',
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.text,
                onChanged: (String? value) {
                  setState(() {
                    inputWeight = int.parse(value!);
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("닫기"),
                onPressed: () {
                  setState(() {
                    inputWeight = 0;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("수정"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          );
        }
      );   
    }

    editType() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
            content: SingleChildScrollView(
              child: DropdownButtonFormField<String?>(
                decoration: const InputDecoration(
                  labelText: '구분',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                  hintText: "자신의 상태를 선택해주세요"
                ),
                onChanged: (String? value) {
                  setState(() {
                    inputType = value!;
                  });
                },
                items:
                  ['N', 'H', 'D'].map<DropdownMenuItem<String?>>((String? i) {
                    return DropdownMenuItem<String?>(
                      value: i,
                      child: Text({'N': '일반인', 'H': '운동', 'D': '다이어트'}[i] ?? ''),
                    );
                  }).toList(),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("닫기"),
                onPressed: () {
                  setState(() {
                    inputType = '';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("수정"),
                onPressed: () {
                  Navigator.of(context).pop();
                  /*setState(() {
                    userAct = user.viewAct(int.parse(inputAct));
                  });*/
                },
              ),
            ]
          );
        }
      );   
    }

    editAct() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
            content: SingleChildScrollView(
              child: DropdownButtonFormField<String?>(
                decoration: const InputDecoration(
                  labelText: '활동량',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                  hintText: "평소 걸음수를 선택해주세요",
                ),
                onChanged: (String? value) {
                  setState(() {
                    inputAct = value!;
                  });
                },
                items:
                  ['25', '30', '33', '35', '40'].map<DropdownMenuItem<String?>>((String? i) {
                    return DropdownMenuItem<String?>(
                      value: i,
                      child: Text({'25': '5000보 이하', '30': '5000~10000만보', '33': '10000~15000보', '35' : '150000~20000보', '40': '15000보 이상'}[i] ?? ''),
                    );
                  }).toList(),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("닫기"),
                onPressed: () {
                  setState(() {
                    inputAct = '';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text("수정"),
                onPressed: () {
                  Navigator.of(context).pop();
                  /*setState(() {
                    userAct = user.viewAct(int.parse(inputAct));
                  });*/
                },
              ),
            ]
          );
        }
      );   
    }

    //Map<String, Object> args = ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
    //String args = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('내 프로필' , style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('ID', style: TextStyle(color: Colors.white),)
                ),
                title: Text(user.id),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('이름', style: TextStyle(color: Colors.white),)
                ),
                title: Text(user.name),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('성별', style: TextStyle(color: Colors.white),)
                ),
                title: Text(user.viewSex),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('나이', style: TextStyle(color: Colors.white),)
                ),
                title: Text("$userAge세"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    editAge();
                  },),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('키', style: TextStyle(color: Colors.white),)
                ),
                title: Text(userHeight.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    editHeight();
                  },),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('체중', style: TextStyle(color: Colors.white),)
                ),
                title: Text(userWeight.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    editWeight();
                  },),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('구분', style: TextStyle(color: Colors.white),)
                ),
                title: Text(user.viewType(userType)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    editType();
                  },),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text('활동', style: TextStyle(color: Colors.white),)
                ),
                title: Text(user.viewAct(int.parse(userAct))),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    editAct();
                  },),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      minimumSize: const Size(100, 40)),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(                                             
                        content: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              const Text('변경내용', style: TextStyle(fontSize: 15),),
                              const Text(""),
                              Text('나이: ${user.age}세 => $userAge세'),
                              Text('키: ${user.height}cm => ${userHeight}cm'),
                              Text('체중: ${user.weight}kg => ${userWeight}kg'),
                              Text('구분: ${user.viewType(user.type)} => ${user.viewType(userType)}'),
                              Text('활동: ${user.viewAct(user.act)}'),
                              Text(' => ${user.viewAct(int.parse(userAct))}'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen),
                            child: const Text("취소"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen),
                            child: const Text("저장"),
                            onPressed: () {
                              editProfile(user.id, user.sex, userAge, userHeight, userWeight, userType, userAct);
                              Navigator.of(context).pop();
                            },
                          ),
                        ]
                      );
                    }
                  );   
                  //
                }, 
                child: const Text('저장하기', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              )
            ),
            ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      minimumSize: const Size(100, 40)),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(                                             
                        content: const SingleChildScrollView(
                          child: Column(
                            children: [
                              Text("회원탈퇴시 모든 정보가 삭제됩니다."),
                              Text("정말 회원탈퇴 하시겠습니다까?")
                            ],)
                          ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen),
                            child: const Text("취소"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen),
                            child: const Text("탈퇴"),
                            onPressed: () {
                              deleteUser(user.id);
                            },
                          ),
                        ]
                      );
                    }
                  );   
                  //
                }, 
                child: const Text('탈퇴하기', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              )
            ),
          ]
        )
      )
    );
  }
}