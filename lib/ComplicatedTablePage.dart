import 'package:flutter/material.dart';
import 'package:flutter_app/table/custom_flutter_table.dart';
import 'package:flutter/cupertino.dart';

class ComplicatedTablePage extends StatefulWidget {
  Page createState() => Page();
}

class Page extends State<ComplicatedTablePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var headerList = [];
  var tableList = [];
  int countTap=0;
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
    return new AppBar(title: const Text('ComplicatedTableDemo'));
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
              countTap.toString() ,
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
    var obj=tableList[yIndex]['data'][xIndex];
    var status=obj['status'];
    if(status==1){
      obj['status']=2;
      obj['widget']=abnormalBodyBox(yIndex, xIndex);
      setState(() {
        tableList[yIndex]['data'][xIndex]=obj;
        countTap+=1;
      });
    }else{
      obj['status']=1;
      obj['widget']=normalBodyBox(yIndex, xIndex);
      setState(() {
        tableList[yIndex]['data'][xIndex]=obj;
        countTap-=1;
      });
    }

  }

  void rightBoxTap(yIndex) {
    print('right' + yIndex.toString());
  }

  void leftTopBoxTap() {
    print('y\\x');
  }

  void rightTopBoxTap() {
    print('setting');
    popDialog( 'alert', 'reset?',(){
      setState(() {
        countTap=0;
        tableList=[];
        headerList=[];
        initData();
      });

    });
  }

  //构造数据
  void initData() {
    int x = 30;
    int y = 50;
    setTableList(x,y);
    //设置头部数据，可使用title或widget，widget优先
    setHeader(x);
  }

  void setTableList(x,y){
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
        obj['status']=1;
        obj['widget'] = normalBodyBox(i,j);
        list.add(obj);
      }
      house['data'] = list;
      tableList.add(house);
    }
  }

  void setHeader(x){
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

  Widget normalBodyBox(i,j){
    return Container(
      alignment: AlignmentDirectional.center,
      color: Colors.grey[100],
      child: Text(
        'x' + (i + 1).toString()+'\\y'+(j+1).toString(),
        style: TextStyle(fontSize: 10.0, color: Colors.black87),
      ),
    );
  }

  Widget abnormalBodyBox(i,j){
    return Container(
      alignment: AlignmentDirectional.center,
      color: Colors.black87,
      child: Text(
        'x' + (i + 1).toString()+'\\y'+(j+1).toString(),
        style: TextStyle(fontSize: 10.0, color: Colors.grey[100]),
      ),
    );
  }

  //点击后的弹出，只是作为一个示例
  void popDialog(String title,String desc,Function() func){
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        //todo 这里做了主体风格切换
        return  CupertinoAlertDialog(
          title:  Text(title),
          content:  Text(desc),


          actions: <Widget>[
             FlatButton(
              child:  Text('confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                if(func!=null){
                  func();
                }
              },
            ),
             FlatButton(
              child:  Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }
}
