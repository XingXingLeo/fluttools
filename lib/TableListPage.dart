import 'package:flutter/material.dart';
import 'SimpleTablePage.dart';
import 'CustomTablePage.dart';
import 'ComplicatedTablePage.dart';

class TableListPage extends StatefulWidget {
  Page createState() => Page();
}

class Page extends State<TableListPage>  with AutomaticKeepAliveClientMixin{
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
          simpleView(context),
          customView(context),
          complicatedView(context),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('Table'));
  }

  Widget simpleView(BuildContext context) {
    var desc='this is a simple demo which will show you how to make a simple but flexible table. \n'
    'use "simple_flutter_table.dart" ';

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          //指定跳转的页面
          return new SimpleTablePage();
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
          return new CustomTablePage();
        },));
      },
      child: itemView('customDemo',desc),
    );
  }
  Widget complicatedView(BuildContext context) {
    var desc='this is a custom demo which will show you how to make a veary complicated table. \n'
        'use "custom_flutter_table.dart" ';
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          //指定跳转的页面
          return new ComplicatedTablePage();
        },));
      },
      child: itemView('complicatedDemo',desc),
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

