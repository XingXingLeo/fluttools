import 'package:flutter/material.dart';
import 'DatePage.dart';

class CalenderListPage extends StatefulWidget {
  Page createState() => Page();
}

class Page extends State<CalenderListPage>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }
  @override
  void dispose() {
    print('dispose_ex');
    super.dispose();
  }
  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(context),
      body: new ListView(
        children: <Widget>[
          dateView(context),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('Calender'));
  }

  Widget dateView(BuildContext context) {
    var desc='this is a calender which can set more info and deal something. \n'
        'use "simple_flutter_table.dart" ';

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          //指定跳转的页面
          return new DatePage();
        },));
      },
      child: itemView('simpleDemo',desc),
    );
  }

  Widget customView(BuildContext context) {
    var desc='this is a custom demo which will show you how to make a complicated table and decide more style. \n'
        'use "custom_flutter_table.dart" ';
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          //指定跳转的页面
          return new DatePage();
        },));
      },
      child: itemView('customDemo',desc),
    );
  }

  Widget itemView(String title,String desc){
    return Container(
      alignment: AlignmentDirectional.centerStart,
      color: Colors.grey[200],
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
            style: TextStyle(
              fontSize: 18,

            ),
          ),
          Text(desc,
            style: TextStyle(
              fontSize: 16,

            ),
          ),
        ],
      ),
    );
  }
}

