import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user.dart';
import '../../providers/history.dart';
import '../../providers/recommend.dart';
//import '../my_server.dart';

class MyRecommend extends StatefulWidget {
  const MyRecommend({Key? key}) : super(key: key);

  @override
  State<MyRecommend> createState() => _MyHistory();
}

class _MyHistory extends State<MyRecommend> {
  late History history;
  late User user;
  late Recommend recommend;

  //MyServer myServer = MyServer();

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    history = Provider.of<History>(context);
    user = Provider.of<User>(context);
    recommend = Provider.of<Recommend>(context);

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('나의 선호음식 : ${user.viewPreference}'),
                trailing: IconButton(
                  icon: const Icon(Icons.border_color),
                  onPressed: () {
                    Navigator.pushNamed(context, '/selectPreference');
                  },
                ),
              )),
          const SizedBox(height: 10),
          Container(
            width: 200,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.lightGreen),
            child: const Center(
                child: Text('추천 결과',
                    style: TextStyle(fontSize: 20, color: Colors.white))),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemCount: recommend.name.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (recommend.category[index] == '매우추천') {
                      if (recommend.category[index] == '밥') {
                        return Card(
                            child: ListTile(
                                title: Text('${recommend.name[index]}'),
                                subtitle: Text(
                                  '${recommend.category[index]}',
                                  style: const TextStyle(color: Colors.black38),
                                ),
                                leading: Image.asset('assets/rice128.png'),
                                trailing: const Icon(Icons.thumb_up)));
                      } else if (recommend.category[index] == '고기') {
                        return Card(
                            child: ListTile(
                                title: Text('${recommend.name[index]}'),
                                subtitle: Text(
                                  '${recommend.category[index]}',
                                  style: const TextStyle(color: Colors.black38),
                                ),
                                leading: Image.asset('assets/meat128.png'),
                                trailing: const Icon(Icons.thumb_up)));
                      } else if (recommend.category[index] == '면') {
                        return Card(
                            child: ListTile(
                                title: Text('${recommend.name[index]}'),
                                subtitle: Text(
                                  '${recommend.category[index]}',
                                  style: const TextStyle(color: Colors.black38),
                                ),
                                leading: Image.asset('assets/ramen128.png'),
                                trailing: const Icon(Icons.thumb_up)));
                      } else if (recommend.category[index] == '빵') {
                        return Card(
                            child: ListTile(
                                title: Text('${recommend.name[index]}'),
                                subtitle: Text(
                                  '${recommend.category[index]}',
                                  style: const TextStyle(color: Colors.black38),
                                ),
                                leading: Image.asset('assets/bread128.png'),
                                trailing: const Icon(Icons.thumb_up)));
                      }
                    } else {
                      if (recommend.category[index] == '밥') {
                        return Card(
                            child: ListTile(
                              title: Text('${recommend.name[index]}'),
                              subtitle: Text(
                                '${recommend.category[index]}',
                                style: const TextStyle(color: Colors.black38),
                              ),
                              leading: Image.asset('assets/rice128.png'),
                            ));
                      } else if (recommend.category[index] == '고기') {
                        return Card(
                            child: ListTile(
                              title: Text('${recommend.name[index]}'),
                              subtitle: Text(
                                '${recommend.category[index]}',
                                style: const TextStyle(color: Colors.black38),
                              ),
                              leading: Image.asset('assets/meat128.png'),
                            ));
                      } else if (recommend.category[index] == '면') {
                        return Card(
                            child: ListTile(
                              title: Text('${recommend.name[index]}'),
                              subtitle: Text(
                                '${recommend.category[index]}',
                                style: const TextStyle(color: Colors.black38),
                              ),
                              leading: Image.asset('assets/ramen128.png'),
                            ));
                      } else if (recommend.category[index] == '빵') {
                        return Card(
                            child: ListTile(
                              title: Text('${recommend.name[index]}'),
                              subtitle: Text(
                                '${recommend.category[index]}',
                                style: const TextStyle(color: Colors.black38),
                              ),
                              leading: Image.asset('assets/bread128.png'),
                            ));
                      }
                    }
                  }))
        ],
      ),
    );
  }
}
