import 'package:flutter/material.dart';
import 'package:flutter_app/table/simple_flutter_table.dart';

class SimpleTablePage extends StatefulWidget {
  Page createState() => Page();
}

class Page extends State<SimpleTablePage> {
  var headerList = [];
  var tableList = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

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
    return new Scaffold(appBar: buildAppBar(context), body: body(context));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('SimpleTableDemo'));
  }

  Widget body(BuildContext context) {
    return Container(
//      width: 200,
//      height:400,
      child: SimpleFlutterTable(
          hasHeader: true,
          hasLeft: true,
          hasRight: true,
          leftTopString: 'fixed',
          rightTopString: 'fixed',
          headerList: headerList,
          tableList: tableList,
          boxWidth: 70,
          boxHeight: 50,
          boxMargin: 2,
          leftWidth: 50,
          rightWidth: 60,
          headerHeight: 40,
          headerColor: Colors.grey[100],
          leftTopColor: Colors.grey[100],
          rightTopColor: Colors.grey[100],
          leftColor: Colors.lightBlue[50],
          rightColor: Colors.orange[300],
          bodyBoxTap: (yIndex, xIndex) {
            bodyBoxTap(yIndex, xIndex);
          },
          headerBoxTap: (xIndex) {
            headerBoxTap(xIndex);
          },
          leftBoxTap: (yIndex) {
            leftBoxTap(yIndex);
          },
          rightBoxTap: (yIndex) {
            rightBoxTap(yIndex);
          },
          leftTopBoxTap: () {
            leftTopBoxTap();
          },
          rightTopBoxTap: () {
            rightTopBoxTap();
          }),
    );
  }

  void headerBoxTap(xIndex) {
    print('头部' + xIndex.toString());
  }

  void leftBoxTap(yIndex) {
    print('左边' + yIndex.toString());
  }

  void bodyBoxTap(yIndex, xIndex) {
    print(yIndex.toString() + '-' + xIndex.toString());
  }

  void rightBoxTap(yIndex) {
    print('右边' + yIndex.toString());
  }

  void leftTopBoxTap() {
    print('左上角');
  }

  void rightTopBoxTap() {
    print('右上角');
  }

  //构造数据
  void initData() {
    int x = 30;
    int y = 50;
    for (var i = 0; i < y; i++) {
      var house = {};
      house['leftTitle'] = 'left' + (i + 1).toString();
      house['rightTitle'] = 'R' + (i + 1).toString();
      var list = [];
      for (var j = 0; j < x; j++) {
        var obj = {};
        obj['title'] = 'data' + j.toString();
        list.add(obj);
      }
      house['data'] = list;
      tableList.add(house);
    }
    for (var j = 0; j < x; j++) {
      var obj = {};
      obj['title'] = 'date' + (j + 1).toString();
      headerList.add(obj);
    }
  }
}
