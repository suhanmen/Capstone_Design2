//import 'package:capstone_design2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/user.dart';
import '../my_server.dart';

class JoinUser extends StatefulWidget {
  const JoinUser({super.key});

  @override
  State<JoinUser> createState() => _JoinUser();
}

class _JoinUser extends State<JoinUser> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController chController = TextEditingController();
  String inputID = '';
  String inputPW = '';
  String checkPW = '';
  String encryptPW = '';

  final validId = RegExp(r"^(?=.*\d)(?=.*[a-zA-Z])");
  final validPw = RegExp(r"^(?=.*\d)(?=.*[a-zA-Z!@#$%^&+=])(?=.*[!@#$%^&+=])");

  late User user;
  final myServer = MyServer();

  checkAvailable(id, pw) async {
    try {
      // ignore: unused_local_variable
      http.Response response = await http.get(Uri.parse("${myServer.checkAvailable}?id_give=$id"));
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
                    Text("이미 가입된 ID 입니다.")
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
        } else if(response.body == "1") {
          user.writeAccount(id, pw);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(                                             
                content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("사용가능한 ID 입니다.")
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen),
                        child: const Text('Next'),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/join2', ModalRoute.withName('/')); 
                        },
                      ),
                    ]
                );
                }
            );      
        }
      }
    } catch(e) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('error')
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text('ok'),
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
              "New User",
              style: TextStyle(
                fontSize: 30
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Theme(
              data: ThemeData(
                  //primaryColor: Colors.grey,
                  inputDecorationTheme: const InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20.0))),
              child: Container(
                  padding: const EdgeInsets.all(40.0),
                  // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                  // SingleChildScrollView으로 감싸 줌
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: idController,
                          decoration: const InputDecoration(
                            labelText: 'Enter ID',
                            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                              if(value == null || value.isEmpty) {
                                return "ID를 입력하세요";
                              } else if(value.length > 15) {
                                return "15자 이내로 입력해주세요";
                              } else if(value.length < 5) {
                                return "5자 이상 입력해주세요";
                              } else if(validId.hasMatch(value) == false) {
                                  return "영문과 숫자를 사용하여 ID를 입력해주세요";
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              inputID = value!;
                            },
                        ),
                        TextFormField(
                          controller: pwController,
                          decoration: const InputDecoration(
                            labelText: 'Enter password',
                            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          validator: (value) {
                              if(value == null || value.isEmpty) {
                                return "비밀번호를 입력하세요";
                              } else if(value.length < 8) {
                                return "8자 이상 입력해주세요";
                              } else if (value.length > 15) {
                                return "16자 이내로 입력해주세요";
                              } else if(validPw.hasMatch(value) == false) {
                                  return "영문, 숫자, 특수문자를 포함하여 비밀번호를 입력해주세요";
                                }
                              inputPW = value;
                              return null;
                            },
                            onSaved: (String? value) {
                              inputPW = value!;
                            },
                        ),
                        TextFormField(
                          controller: chController,
                          decoration: const InputDecoration(
                            labelText: 'Check password',
                            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                          validator: (value) {
                              if(value == null || value.isEmpty) {
                                return "비밀번호를 입력하세요";
                              } else if(value != inputPW) {
                                return "비밀번호가 일치하지 않습니다";
                              } 
                              return null;
                            },
                        ),
                        const SizedBox(height: 40.0,), //회원가입 버튼
                        ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: (){
                                if(_formkey.currentState!.validate()) {
                                  _formkey.currentState!.save();
                                  checkAvailable(inputID, inputPW);
                                }                                
                              },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                    minimumSize: const Size(100, 40)
                                ),
                                child: const Text('Next',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18))
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

class WriteUserInfo extends StatefulWidget {
  const WriteUserInfo({super.key});

  @override
  State<WriteUserInfo> createState() => _WriteUserInfo();
}

class _WriteUserInfo extends State<WriteUserInfo> {

  final _formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  
  late String inputName;
  late String inputSex;
  late String inputType;
  late String inputAct;
  late int inputAge;
  late int inputHeight;
  late int inputWeight;

  late User user;
  final myServer = MyServer();
  
  onPressJoin(id, pw, name, age, sex, type, height, weight, act) async {
    try {
      // ignore: unused_local_variable
      http.Response response = await http.post(Uri.parse(myServer.join), 
      body: {'id_give': id, 'pw_give': pw, 'name_give': name, 'age_give': age, 'sex_give': sex, 'type_give': type, 'height_give': height, 'weight_give': weight, 'act_give': act});
      if(!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(                                             
          content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("회원가입 완료")
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  child: const Text('OK'), 
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); 
                  },
                ),
              ]
          );}          
      );  
    } catch(e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('error'),
                  Text('$id / $pw / $name / $age / $sex / $type / $height / $weight / $act')
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen),
                child: const Text('ok'),
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

    var user = Provider.of<User>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "User Detail",
              style: TextStyle(
                fontSize: 30
              )
            ),
          ),
          Form(
            key: _formkey,
            child: Theme(
              data: ThemeData(
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.teal, fontSize: 20))),
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child:SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: '이름',
                          labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return "이름을 입력하세요";
                          } else if(value.length > 15 || value.length < 3) {
                            return "이름을 3자리에서 15자리 이내로 입력해주세요";
                          }
                          return null;
                        },
                          onSaved: (String? value) {
                            inputName = value!;
                          },
                      ),
                      DropdownButtonFormField<String?>(
                        decoration: const InputDecoration(
                          labelText: '성별',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            inputSex = value!;
                          });
                        },
                        items:
                        ['M', 'F'].map<DropdownMenuItem<String?>>((String? i) {
                          return DropdownMenuItem<String?>(
                            value: i,
                            child: Text({'M': '남성', 'F': '여성'}[i] ?? ''),
                          );
                        }).toList(),
                        validator: (val){
                          if(val == null){
                            return '성별을 입력하세요';
                          }
                          return null;
                        },
                    ),
                      TextFormField(
                          controller: ageController,
                          decoration: const InputDecoration(
                            labelText: '나이',
                            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),),
                          keyboardType: TextInputType.text,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return "나이를 입력하세요";
                            } else if (int.parse(value) < 1){
                              return "0이상으로 입력하세요";
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            inputAge = int.parse(value!);
                          },
                      ),
                      TextFormField(
                          controller: heightController,
                          decoration: const InputDecoration(
                            labelText: '키(cm)',
                            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return "키를 입력하세요";
                            } else if (int.parse(value) < 1){
                              return "0이상으로 입력하세요";
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            inputHeight = int.parse(value!);
                          },
                      ),
                      TextFormField(
                          controller: weightController,
                          decoration: const InputDecoration(
                            labelText: '몸무게(kg)',
                            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                          keyboardType: TextInputType.text,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return "몸무게를 입력하세요";
                            } else if (int.parse(value) < 1){
                              return "0이상으로 입력하세요";
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            inputWeight= int.parse(value!);
                          },
                      ),
                      DropdownButtonFormField<String?>(
                      decoration: const InputDecoration(
                        labelText: '구분',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
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
                        validator: (val){
                          if(val == null){
                            return '자신의 상태를 입력해주세요';
                          }
                          return null;
                        },
                    ),
                    DropdownButtonFormField<String?>(
                      decoration: const InputDecoration(
                        labelText: '활동량',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
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
                        validator: (val){
                          if(val == null){
                            return '평소 걸음수를 입력해주세요';
                          }
                          return null;
                        },
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen),
                      child: const Text("Join"),
                      onPressed: () {
                          if(_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          user.writeUser(inputName, inputSex, inputType, inputAge, inputHeight, inputWeight, int.parse(inputAct));
                          onPressJoin(user.id, user.pw, user.name, user.age.toString(), user.sex, user.type, user.height.toString(), user.weight.toString(), user.act.toString());
                        } 
                      })
                  ],)
                  )
              )
            )
          ),
        ],)
    );
  }
}