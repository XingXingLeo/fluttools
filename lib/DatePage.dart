import 'package:flutter/material.dart';
import 'package:flutter_app/calender/flutter_calender.dart';
import 'package:flutter/cupertino.dart';

///用来设计一个日历
///类似于房态价格日历，每个格子可以展示状态、价格、甚至订单信息（参考airbnb）等
///同时点击之后应该能弹出相应的弹出框（可以传值），处理之后可以有回调之类的
///日历要可以传日期和相应的数据进去
const num_month = 12; //设置为12个月

class DatePage extends StatefulWidget {


  DatePage();

  Page createState() => Page();
}

class Page extends State<DatePage> {
  var monthList = [];
  var boxStyleList = [];
  var boxWidth;
  var startChoosen;
  var endChoosen;

  var width;

  @override
  void initState() {
    super.initState();
    //第一步是进行数据准备
    initalMonthList();
    //第一步，准备好样式，必须与status配套使用
    initStyleList();
  }

  void initalMonthList() {
    var cur_year = DateTime.now().year;
    var cur_month = DateTime.now().month;
    for (var i = 0; i < num_month; i++) {
      var mObject0 = this.calculateDays(cur_year, cur_month);

      monthList.add(mObject0);
      if (cur_month + 1 > 12) {
        cur_year = cur_year + 1;
        cur_month = 1;
      } else {
        cur_month = cur_month + 1;
      }
    }
  }

  void initStyleList() {
    var status0 = {
      'name': '空房且未选中',
      'decoration': BoxDecoration(
          color: Colors.white,
          border: null,
          borderRadius: BorderRadius.circular(3.0)),
      'text_style': TextStyle(fontSize: 12.0, color: Colors.black54),
      'desc_style': TextStyle(fontSize: 10.0, color: Colors.pink)
    };

    var status1 = {
      'name': '空房且选中',
      'decoration': BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.pink),
          borderRadius: BorderRadius.circular(3.0)),
      'text_style': TextStyle(fontSize: 12.0, color: Colors.black54),
      'desc_style': TextStyle(fontSize: 10.0, color: Colors.pink)
    };
    var status2 = {
      'name': '占用且未选中',
      'decoration': BoxDecoration(
          color: Colors.grey,
          border: null,
          borderRadius: BorderRadius.circular(3.0)),
      'text_style': TextStyle(fontSize: 12.0, color: Colors.black54),
      'desc_style': TextStyle(fontSize: 10.0, color: Colors.black54)
    };
    var status3 = {
      'name': '占用且选中',
      'decoration': BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.pink),
          borderRadius: BorderRadius.circular(3.0)),
      'text_style': TextStyle(fontSize: 12.0, color: Colors.black54),
      'desc_style': TextStyle(fontSize: 10.0, color: Colors.black54)
    };
    var status4 = {
      'name': '不可选中',
      'decoration': BoxDecoration(
          color: Colors.grey[200],
          border: null,
          borderRadius: BorderRadius.circular(3.0)),
      'text_style': TextStyle(fontSize: 12.0, color: Colors.grey),
      'desc_style': TextStyle(fontSize: 10.0, color: Colors.grey)
    };
    var status5 = {
      'name': '',
      'decoration': BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.pink),
          borderRadius: BorderRadius.circular(3.0)),
      'text_style': TextStyle(fontSize: 12.0, color: Colors.pink),
      'desc_style': TextStyle(fontSize: 10.0, color: Colors.pink)
    };
    boxStyleList
      ..add(status0)
      ..add(status1)
      ..add(status2)
      ..add(status3)
      ..add(status4)
      ..add(status5);
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    print('month length' + monthList.length.toString());
    return new Scaffold(
      appBar: buildAppBar(context),
      body: Container(
//        width: 300,
//        height: 400,
        child: buildContent(context),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        title:
            Text('verticalCalender' )
    );
  }

  Widget buildContent(BuildContext context) {
    return FlutterCalender(
//        calenderWidth: 300.0,
//    hasCalenderHeader: false,
//        hasMonthHeader: false,
    isChinese: false,
        monthList: monthList,
        boxMarginTop: 10,
        boxMarginBottom: 10,
        boxMarginLeft: 2,
        boxMarginRight: 2,
        dateContainerMarginTop: 10,
        dateContainerMarginBottom: 10,
        boxStyleList: boxStyleList,
        monthColor: Colors.white,
        monthBorderColor: Colors.black45,
        monthTextColor: Colors.black45,
        monthTextSize: 16,
        boxRadius: 3,
//          boxDecoration: BoxDecoration(
//           // border: Border.all(color: Colors.grey, width: 1.0),
//            borderRadius: BorderRadius.circular(3.0)
//          ),
        onDateTaped: (month_index, day_index) {
          tapDate(month_index, day_index);
        });
  }

  /**日历整体框架，包括顶部的星期及向下的月份
   * 月份的展现必须是完成的月份
   * 数据的展现可以部分是完整的月份
   * 比如要展示3月15至4月8日的数据，需要展现三月和四月，但没有数据的部分要置为灰色、不可选择状态
   */

  void tapDate(month_index, day_index) {
    if (monthList[month_index]['days'][day_index]['status'] <
        boxStyleList.length - 1) {
      setState(() {
        monthList[month_index]['days'][day_index]['status'] += 1;
      });
    } else {
      alertInfo();
      setState(() {
        monthList[month_index]['days'][day_index]['status'] = 0;
      });
    }
  }
  void alertInfo(){
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Text('alert'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('do some thing'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
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


  calculateDays(year, month) {
    var mObject = {}; //月对象
    mObject["year"] = year;
    mObject["month"] = month;
    mObject['month_header_title']=year.toString()+' · '+month.toString();

    var days = [];
    var thisMonthDays = this.getLastDayOfMonth(year, month); //这个月有多少天

    for (var i = 1; i <= thisMonthDays; i++) {
      /** 需要设计一个day对象
       * int day：本月第几号
       * DateTime date：，可以考虑
       * int status 交互状态  这个应该是在本页面处理的交互逻辑，但是需要根据这个状态，给予相应的样式数组
       * string desc 描述， 文字展现
       */

      var day = {};
      //加入的时间
      var date = new DateTime(year, month, i);
      //status 0-不可选择 1-当前时间 2-可选择 3-被选中
      day["day"] = i;
      //todo 增加今日的显示，但不重要
      if (year == DateTime.now().year &&
          month == DateTime.now().month &&
          i == DateTime.now().day) {
        day["day"] = 'Today';
      }

      var status = i % 6;
      day["status"] = status;
      if (status == 2 || status == 3) {
        day["desc"] = 'using';
      } else if (status == 0 || status == 1) {
        day["desc"] = "\$198";
      } else {
        day["desc"] = 'other';
      }

      //比现在的时间比较是大于还是小于，小于则不可点击
//      var time = parseInt(DateTime.calculateTime(date,cusDate));
//      if(time<0) {
//        day["status"] = 0;
//      }else if(time==0) {
//        day["status"] = 1;
//      }else {
//        day["status"] = 2;
//      }
//      if(this.data.startDate&&this.data.endDate) {
//        var stime = parseInt(Data.calculateTime(date,startDate));
//        var etime = parseInt(Data.calculateTime(date,endDate));
//        if(stime>=0&&etime<=0) {
//          day["status"] = 3;
//        }
//      }else if(this.data.startDate){
//        var stime = parseInt(Data.calculateTime(date,startDate));
//        if(stime==0) {
//          day["status"] = 3;
//        }
//      }
//
//      for (var j = 0; j < this.data.datePrices.length; j++) {
//        var ctime = parseInt(Data.calculateTime(date, Data.stringToDate(this.data.datePrices[j].date)));
//        if (ctime == 0) {
//          day["available"] = this.data.datePrices[j].available
//          day["price"] = this.data.datePrices[j].price
//          day["date"] = this.data.datePrices[j].date
//
//        }
//      }
      days.add(day);
    }
    mObject["days"] = days;
    return mObject;
  }

  //获取某年某月的天数，方法是先获取下个月1号，回退一天后，获取day
  int getLastDayOfMonth(int year, int month) {
    return DateTime(year, month + 1, 1).add(Duration(days: -1)).day;
  }
}
