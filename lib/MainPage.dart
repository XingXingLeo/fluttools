import 'package:flutter/material.dart';
import 'package:flutter_app/CalenderListPage.dart';
import 'package:flutter_app/TableListPage.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, home: new MainPageWidget());
  }
}

class MainPageWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPageWidget> {




  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['Table', 'Calender'];

  /*
   * 存放三个页面，跟fragmentList一样
   */
  var _pageList = [
    TableListPage(),
    CalenderListPage(),
  ];

  var _pageController = PageController();

  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: const Color(0xff1296db)));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 14.0, color: const Color(0xff515151)));
    }
  }

  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 24.0, height: 24.0);
  }

  void _pageChanged(int index) {
    print('_pageChanged');
    setState(() {
      if (_tabIndex != index) _tabIndex = index;
    });
  }

  void initData() {
    //获取屏幕信息dp、px等
   // print(MediaQuery.of(context).size.width);
    /*
     * 初始化选中和未选中的icon
     */
    tabImages = [
      [getTabImage('images/home.png'), getTabImage('images/home_selected.png')],
      [getTabImage('images/find.png'), getTabImage('images/find_selected.png')],
    ];
  }

  @override
  Widget build(BuildContext context) {
    //初始化数据
    initData();
    return Scaffold(
        body: PageView.builder(
            //要点1
            physics: ClampingScrollPhysics(),//NeverScrollableScrollPhysics(),//禁止页面左右滑动切换
            controller: _pageController,
            onPageChanged: _pageChanged, //回调函数
            itemCount: _pageList.length,
            itemBuilder: (context, index) => _pageList[index]),
        bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0), title: getTabTitle(0)),
            new BottomNavigationBarItem(
                icon: getTabIcon(1), title: getTabTitle(1)),
          ],
          type: BottomNavigationBarType.fixed,
          //默认选中首页
          currentIndex: _tabIndex,
          iconSize: 24.0,
          //点击事件
          onTap: (index) {
            print('onTap');
            _pageController.jumpToPage(index);
          },
        ));
  }
}
