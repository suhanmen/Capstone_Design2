import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/food.dart';
import '../../providers/user.dart';

class SelectFood extends StatefulWidget {
  const SelectFood ({Key? key}) : super(key: key);

  @override
  State<SelectFood> createState() => _SelectFood();
}

class _SelectFood extends State<SelectFood> {
  late List<String> foodCode = List.empty(growable: true);
  late List<String> foodName = List.empty(growable: true);
  late List<int> foodAmount = List.empty(growable: true);
  String searchText ="";


  @override
  Widget build(BuildContext context) {

    //Map<String, Object> args = ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
    List args = ModalRoute.of(context)?.settings.arguments as List;

    var food = Provider.of<Food>(context);
    var user = Provider.of<User>(context);

    foodCode = List.filled(args.length, "");
    foodName = List.filled(args.length, "");
    foodAmount = List.filled(args.length, 0);

    for(int i=0; i<args.length; i++) {
      foodCode[i] = args[i]['code'];
      foodName[i] = args[i]['name'];
      foodAmount[i] = args[i]['amount'];
    }    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("먹은 음식 기록하기"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "음식을 입력해주세요",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              }
            )
          ),
          Expanded(
            child: ListView.builder(
            itemCount: foodName.length,
            itemBuilder: (BuildContext context, int index) {
              if(searchText.isNotEmpty && 
                  !foodName[index]
                    .toLowerCase()
                    .contains(searchText.toLowerCase())){
                return const SizedBox.shrink();
              } else {
                return Card(
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    title: 
                      Text(foodName[index]   ,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          )),
                    subtitle: 
                      Text("1인분 기준: ${foodAmount[index]}g"),
                    onTap: () {
                      food.setId = user.id;
                      food.setCode = foodCode[index];
                      food.setGram = foodAmount[index].toDouble();
                      Navigator.pushNamed(context, '/writeFoodDetail', arguments: foodName[index]);
                    }
                  ),
                );
              }
            }
            )
          )
        ]
      ),
    );
  }
}