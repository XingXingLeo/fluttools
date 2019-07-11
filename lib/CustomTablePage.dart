import 'package:flutter/material.dart';
import 'package:flutter_app/table/custom_flutter_table.dart';

class CustomTablePage extends StatefulWidget {
  Page createState() => Page();
}

class Page extends State<CustomTablePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var headerList = [];
  var tableList = [];

  @override
  void initState() {
    // 必须有这一句，否则页面离开时会自动调用dispose导致回来的时候会重载，因为wantKeepAlive等父级方法没有被调用
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
    return new AppBar(title: const Text('CustomTableDemo'));
  }

  Widget body(BuildContext context) {
    return Container(
//      width: 200,
//      height:400,
      child: CustomFlutterTable(
          hasHeader: true,
          hasLeft: true,
          hasRight: true,
          rightTopWidget: Container(
            alignment: AlignmentDirectional.center,
            color: Colors.lightBlue[200],
            child: Text(
              'setting' ,
              style: TextStyle(fontSize: 10.0, color: Colors.white),
            ),
          ),
          leftTopWidget: Container(
            alignment: AlignmentDirectional.center,
            color: Colors.lightBlue,
            child: Text(
              'y\\x' ,
              style: TextStyle(fontSize: 10.0, color: Colors.white),
            ),
          ),
          headerList: headerList,
          tableList: tableList,
          boxWidth: 60,
          boxHeight: 50,
          boxMargin: 2,
          leftWidth: 50,
          rightWidth: 55,
          headerHeight: 40,
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
    print('header' + xIndex.toString());
  }

  void leftBoxTap(yIndex) {
    print('left' + yIndex.toString());
  }

  void bodyBoxTap(yIndex, xIndex) {
    print(yIndex.toString() + '-' + xIndex.toString());
  }

  void rightBoxTap(yIndex) {
    print('right' + yIndex.toString());
  }

  void leftTopBoxTap() {
    print('y\\x');
  }

  void rightTopBoxTap() {
    print('setting');
  }

  //构造数据
  void initData() {
    int x = 30;
    int y = 50;
    for (var i = 0; i < y; i++) {
      var house = {};

      ///设置左侧内容，可使用LeftTitle或leftWidget，leftWidget优先
      house['leftWidget'] = Container(
        alignment: AlignmentDirectional.center,
        color: Colors.grey[200],
        child: Text(
          'left' + (i + 1).toString(),
          style: TextStyle(fontSize: 10.0, color: Colors.black45),
        ),
      );


      ///设置右侧内容，可使用rightTitle或rightWidget，rightWidget优先
      house['rightWidget'] = Container(
        alignment: AlignmentDirectional.center,
        color: Colors.grey[200],
        child: Text(
          'right' + (i + 1).toString(),
          style: TextStyle(fontSize: 10.0, color: Colors.black87),
        ),
      );


      ///设置中间横向数据，可使用title或widget，widget优先
      var list = [];
      for (var j = 0; j < x; j++) {
        var obj={};
        obj['widget'] = Container(
          alignment: AlignmentDirectional.center,
          color: Colors.grey[100],
          child: Text(
            'x' + (i + 1).toString()+'\\y'+(j+1).toString(),
            style: TextStyle(fontSize: 10.0, color: Colors.black87),
          ),
        );
        list.add(obj);
      }
      house['data'] = list;
      tableList.add(house);
    }
    //设置头部数据，可使用title或widget，widget优先
    for (var j = 0; j < x; j++) {
      var obj={};
      obj['widget'] = Container(
        alignment: AlignmentDirectional.center,
        color: Colors.orange,
        child: Text(
          'x'+(j+1).toString(),
          style: TextStyle(fontSize: 10.0, color: Colors.black45),
        ),
      );
      headerList.add(obj);
    }
  }
}
