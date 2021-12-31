import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:melon_market/screens/home/items_page.dart';
import 'package:melon_market/states/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: TextStyle(fontSize: 30, color: Colors.grey),
    ),
    Text(
      'Main',
      style: TextStyle(fontSize: 30, color: Colors.grey),
    ),
    Text(
      'Search',
      style: TextStyle(fontSize: 30, color: Colors.grey),
    ),
    Text(
      'Setting',
      style: TextStyle(fontSize: 30, color: Colors.grey),
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '홈 화면',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                //context.read<UserProvider>().setUserAuth(false);
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(CupertinoIcons.square_arrow_left)),
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.text_justify)),
        ],
      ),
      body: IndexedStack(
        index: _selectIndex,
        children: [
          ItemsPage(),
          Container(
            color: Colors.accents[3],
          ),
          Container(
            color: Colors.accents[6],
          ),
          Container(
            color: Colors.accents[9],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
              ),
              label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.map,
              ),
              label: '내근처'),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.chat_bubble_text,
              ),
              label: '채팅'),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.settings,
              ),
              label: '내정보'),
        ],
        currentIndex: _selectIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
