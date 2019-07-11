import 'package:flutter/material.dart';

///用来设计一个日历
///类似于房态价格日历，每个格子可以展示状态、价格、甚至订单信息（参考airbnb）等
///同时点击之后应该能弹出相应的弹出框（可以传值），处理之后可以有回调之类的
///日历要可以传日期和相应的数据进去
const weeks_ch = ['日', '一', '二', '三', '四', '五', '六'];
const weeks_en = ['Sun', 'Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat'];

class FlutterCalender extends StatefulWidget {
  //要在这里设置，然后在State里面调用
  final bool hasMonthHeader;
  final bool isChinese;
  final bool hasCalenderHeader;

  final monthList;
  final boxStyleList;

  final Color monthColor;

  final Color dateContainerColor;
  final Color weekHeaderColor;

  final Color monthTextColor;

  final Color monthBorderColor;

  final double monthTextSize;
  final Function(int, int) onDateTaped;
  final double calenderWidth;
  final double boxMarginTop;
  final double boxMarginBottom;
  final double boxMarginLeft;
  final double boxMarginRight;
  final double dateContainerMarginTop;
  final double dateContainerMarginBottom;
  final double weekHeaderMarginTop;
  final double weekHeaderMarginBottom;

  final double boxRadius; //: BorderRadius.circular(3.0))

  const FlutterCalender({
    this.isChinese=true,
    this.hasCalenderHeader = true,
    this.hasMonthHeader = true,
    this.calenderWidth,
    this.onDateTaped,
    this.monthList,
    this.monthTextColor,
    this.monthTextSize,
    this.boxMarginTop = 3,
    this.boxMarginBottom = 3,
    this.boxMarginLeft = 3,
    this.boxMarginRight = 3,
    this.dateContainerMarginTop = 5,
    this.dateContainerMarginBottom = 5,
    this.weekHeaderMarginTop = 5,
    this.weekHeaderMarginBottom = 5,
    this.boxRadius,
    this.monthColor,
    this.monthBorderColor = Colors.white,
    this.dateContainerColor,
    this.weekHeaderColor,
    this.boxStyleList,
  });

  Page createState() => Page();
}

class Page extends State<FlutterCalender> {
  var width;

  @override
  void initState() {
    super.initState();
    print('initState');
  }

  @override
  Widget build(BuildContext context) {
    width = ((widget.calenderWidth != null
                ? widget.calenderWidth
                : MediaQuery.of(context).size.width) /
            7)
        .floorToDouble();
//    print(width);
    return lanzuCalenderWidget();
  }

  Widget lanzuCalenderWidget() {
    if (widget.hasCalenderHeader) {
      return Container(
          child: Column(
        children: <Widget>[
          weekHeader(),
          Flexible(child: lanzuCalenderContainer())
        ],
      ));
    } else {
      return lanzuCalenderContainer();
    }
  }

  ///日历整体框架，包括顶部的星期及向下的月份
  ///月份的展现必须是完成的月份
  ///数据的展现可以部分是完整的月份
  ///比如要展示3月15至4月8日的数据，需要展现三月和四月，但没有数据的部分要置为灰色、不可选择状态
  Widget lanzuCalenderContainer() {
    //首先是一个ListView，遍历了每个月
    var list = <Widget>[];
    for (var i = 0; i < widget.monthList.length; i++) {
      list.add(monthWidget(i));
    }
    return new ListView(children: list);
  }

  Widget monthWidget(monthIndex) {
    if (widget.hasMonthHeader) {
      return Column(
        children: <Widget>[
          monthHeaderWidget(monthIndex),
          monthBodyWidget(monthIndex)
        ],
      );
    } else {
      return monthBodyWidget(monthIndex);
    }
  }

  Widget monthHeaderWidget(monthIndex) {
    var monthData = widget.monthList[monthIndex];
    return Container(
//      color: Colors.red,
      height: 50,
      decoration: BoxDecoration(
          color: widget.monthColor,
          border: Border(
            top: widget.monthBorderColor != null
                ? BorderSide(color: widget.monthBorderColor, width: 1.0)
                : BorderSide.none,
            bottom: widget.monthBorderColor != null
                ? BorderSide(color: widget.monthBorderColor, width: 1.0)
                : BorderSide.none,
          )),

      alignment: Alignment.center,
      child: Text(monthData['month_header_title'],
          style: new TextStyle(
              fontSize:
                  widget.monthTextSize != null ? widget.monthTextSize : 20,
              color: widget.monthTextColor != null
                  ? widget.monthTextColor
                  : Colors.grey)),
    );
  }

  Widget monthBodyWidget(monthIndex) {
    var monthData = widget.monthList[monthIndex];
    var list = <Widget>[];
    /**
     * 计算空格数量
     */
    var year = monthData['year'];
    var month = monthData['month'];
    int emptyCount = calculateEmptyGrids(year, month);
    /**
     * 填充空格，因为用的是WRAP
     */
    for (var i = 0; i < emptyCount; i++) {
      list.add(invisibleBox());
    }

    /**
     * 设置数据格子
     */
    for (var i = 0; i < monthData['days'].length; i++) {
      list.add(tapableDateBox(monthIndex, i));
    }

    return Container(
      color:
          widget.dateContainerColor != null ? widget.dateContainerColor : null,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, widget.dateContainerMarginTop, 0,
          widget.dateContainerMarginBottom),
      child: Wrap(
        direction: Axis.horizontal,
        children: list,
      ),
    );
  }

//  /**
//   *  包装 数据格子，可点击
//   */

  Widget tapableDateBox(monthIndex, dayIndex) {
    return new GestureDetector(
        onTap: () {
          print(widget.monthList[monthIndex]['days'][dayIndex]['status']);
          tapDate(monthIndex, dayIndex);
        },
        child: dateBox(monthIndex, dayIndex));
  }

//  /**
//   * 点击回调
//   */
  void tapDate(monthIndex, dayIndex) {
    if (widget.onDateTaped != null) {
      widget.onDateTaped(monthIndex, dayIndex);
    }
  }

  // 这里必须有背景色color或者decoration，否则导致手势直接落到TEXT的文字上，由于面积太小而失灵
//  /**
//   * 日历格子的最小单位
//   */
  Widget dateBox(monthIndex, dayIndex) {
    var monthData = widget.monthList[monthIndex];
    var day = monthData['days'][dayIndex]['day'];
    var desc = monthData['days'][dayIndex]['desc'];

    var status = monthData['days'][dayIndex]['status'];

//     * 格子内部氛围日期内容与描述内容
//     * 日期内容day
//     * 描述内容desc

    var boxTextList = <Widget>[];
    if (day != null) {
      boxTextList.add(Text(day.toString(),
          style: widget.boxStyleList[status]['text_style']));
    }
    if (desc != null) {
      boxTextList.add(Text(desc.toString(),
          style: widget.boxStyleList[status]['desc_style']));
    }

    return Container(
        width: width - widget.boxMarginLeft - widget.boxMarginRight,
        height: width - widget.boxMarginLeft - widget.boxMarginRight,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(widget.boxMarginLeft, widget.boxMarginTop,
            widget.boxMarginRight, widget.boxMarginBottom),
        decoration: widget.boxStyleList[status]['decoration'],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: boxTextList,
        ));
  }

  ///占位格子的样式
  Widget invisibleBox() {
    return Container(
      width: width - widget.boxMarginLeft - widget.boxMarginRight,
      height: width - widget.boxMarginLeft - widget.boxMarginRight,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(widget.boxMarginLeft, widget.boxMarginTop,
          widget.boxMarginRight, widget.boxMarginBottom),
    );
  }

  // 计算月初在日历上空的天数，但需要考虑这样做的话，性能是否下降，是否应该在initState的时候处理
  int calculateEmptyGrids(year, month) {
    var firstDayOfWeek = getFirstDayOfWeekOfMonth(year, month);
    int count = 0;
    if (firstDayOfWeek < 7) {
      for (var i = 0; i < firstDayOfWeek; i++) {
        count++;
      }
    }
    return count;
  }

  ///星期的头部
  Widget weekHeader() {
    var list = <Widget>[];

    if(widget.isChinese){
      for (var i = 0; i < weeks_ch.length; i++) {
        list.add(weekBox(weeks_ch[i]));
      }
    }else{
      for (var i = 0; i < weeks_en.length; i++) {
        list.add(weekBox(weeks_en[i]));
      }
    }


    return Container(
      color: widget.weekHeaderColor != null ? widget.weekHeaderColor : null,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
          0, widget.weekHeaderMarginTop, 0, widget.weekHeaderMarginBottom),
      child: Wrap(
        direction: Axis.horizontal,
        children: list,
      ),
    );
  }

  ///星期格子，尺寸与日历格子相同
  Widget weekBox(String str) {
    return Container(
      width: width - widget.boxMarginLeft - widget.boxMarginRight,
      height: width - widget.boxMarginLeft - widget.boxMarginRight,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(widget.boxMarginLeft, widget.boxMarginTop,
          widget.boxMarginRight, widget.boxMarginBottom),
      child: Text(str, style: null),
    );
  }

  //获取当月第一天是周几
  int getFirstDayOfWeekOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday;
  }
}
