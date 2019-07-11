import 'package:flutter/material.dart';

class FlutterTable extends StatefulWidget {
  final bool hasHeader;
  final bool hasLeft;
  final bool hasRight;
  final String leftTopString;
  final String rightTopString;
  final Widget leftTopWidget;
  final Widget rightTopWidget;
  final List headerList;
  final List tableList;
  final double boxWidth;
  final double boxHeight;
  final double boxMargin;
  final double leftWidth;
  final double headerHeight;
  final double rightWidth;

  final Color tableColor;
  final Color headerColor;
  final Color leftColor;
  final Color rightColor;
  final Color leftTopColor;
  final Color rightTopColor;

  final Function(int, int) bodyBoxTap;
  final Function(int) leftBoxTap;
  final Function(int) headerBoxTap;
  final Function(int) rightBoxTap;
  final Function() rightTopBoxTap;
  final Function() leftTopBoxTap;

  const FlutterTable(
      {this.hasHeader = false,
      this.hasLeft = false,
      this.hasRight = false,
      this.leftTopWidget,
      this.rightTopWidget,
      this.leftTopString,
      this.rightTopString,
      this.headerList,
      this.tableList,
      this.boxWidth,
      this.boxHeight,
      this.boxMargin,
      this.leftWidth,
      this.headerHeight,
      this.rightWidth,
      this.tableColor,
      this.headerColor,
      this.leftColor,
      this.leftTopColor,
      this.rightColor,
      this.rightTopColor,
      this.bodyBoxTap,
      this.headerBoxTap,
      this.leftBoxTap,
      this.rightBoxTap,
      this.rightTopBoxTap,
      this.leftTopBoxTap});

  LanzuTablePage createState() => LanzuTablePage();
}

class LanzuTablePage extends State<FlutterTable> {
  ScrollController _bodyController =
      new ScrollController(); //设置一个滑动的空置期，用来控制房态那一列的滑动
  ScrollController _xController =
      new ScrollController(); //设置一个滑动的空置期，用来控制房源那一列的滑动

  @override
  Widget build(BuildContext context) {
    return lanzuTableWight(context);
  }

  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    if (widget.hasLeft || widget.hasRight) {
      _bodyController.addListener(() {
//        print(_bodyController.offset); //打印滚动位置
        if (widget.hasLeft) {
          _xController.jumpTo(_bodyController.offset);
        }
      });
    }
  }

  @override
  void dispose() {
    print('dispose');
    //为了避免内存泄露，需要调用_controller.dispose
    _bodyController.dispose();
    super.dispose();
  }

  Widget lanzuTableWight(BuildContext context) {
    var list = <Widget>[];
    if (widget.hasLeft) {
      list.add(leftListAndFixed(context));
    }
    list.add(Flexible(child: middleTableBox(context)));
    if (widget.hasRight) {
      list.add(rightListAndFixed(context));
    }

    return Row(children: list);
  }

  //组合日历表和房态表
  Widget middleTableBox(BuildContext context) {
    var list = <Widget>[];
    if (widget.hasHeader) {
      list.add(headerListView(context));
    }
    list.add(Flexible(child: bodyContainerView(context)));

    return ListView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: widget.boxWidth * (widget.headerList.length).toDouble(),
          //这里是内容的宽度 60*11
          color: widget.tableColor,
          child: Column(children: list),
        )
      ],
    );
  }

  //日历格子
  Widget headerBox(BuildContext context, int xIndex) {
    if (widget.headerBoxTap != null) {
      return new GestureDetector(
          onTap: () {
            //处理点击事件
            widget.headerBoxTap(xIndex);
          },
          child: headerBoxChild(context, xIndex));
    } else {
      return headerBoxChild(context, xIndex);
    }
  }

  Widget headerBoxChild(BuildContext context, int xIndex) {
    return new Container(
      width: widget.boxWidth - 2 * widget.boxMargin,
      height: widget.headerHeight - 2 * widget.boxMargin,
      margin: EdgeInsets.all(widget.boxMargin),
      color: Colors.greenAccent,
      child: widget.headerList[xIndex]['widget'] != null
          ? widget.headerList[xIndex]['widget']
          : Text(
              widget.headerList[xIndex]['title'],
              style: TextStyle(fontSize: 10.0, color: Colors.green),
            ),
    );
  }

  //日历横向数组整行
  Widget headerListView(BuildContext context) {
    var list = <Widget>[];
    for (var i = 0; i < widget.headerList.length; i++) {
      list.add(headerBox(context, i));
    }

    return Container(
        height: widget.headerHeight,
        color: widget.headerColor,
        child: Row(
          children: list,
        ));
  }

  //表格盒子里的内容
  Widget bodyBoxContent(BuildContext context, yIndex, xIndex) {
    return widget.tableList[yIndex]['data'][xIndex]['widget'] != null
        ? widget.tableList[yIndex]['data'][xIndex]['widget']
        : Text(
            widget.tableList[yIndex]['data'][xIndex]['title'],
            style: TextStyle(fontSize: 10.0, color: Colors.green),
          );
  }

  ///表格数据格子，后面应该设计成可以放入订单信息
  Widget bodyBox(BuildContext context, yIndex, xIndex) {
    if (widget.bodyBoxTap != null) {
      return new GestureDetector(
          onTap: () {
            //处理点击事件
            widget.bodyBoxTap(yIndex, xIndex);
          },
          child: bodyBoxChild(context, yIndex, xIndex));
    } else {
      return bodyBoxChild(context, yIndex, xIndex);
    }
  }

  Widget bodyBoxChild(BuildContext context, yIndex, xIndex) {
    return new Container(
      width: widget.boxWidth - 2 * widget.boxMargin,
      height: widget.boxHeight - 2 * widget.boxMargin,
      margin: EdgeInsets.all(widget.boxMargin),
      child: bodyBoxContent(context, yIndex, xIndex),
    );
  }

  //表格横向数组整行
  Widget bodyListView(BuildContext context, int yIndex) {
    var list = <Widget>[];
    for (var i = 0; i < widget.headerList.length; i++) {
      list.add(bodyBox(context, yIndex, i));
    }

    return Container(
        height: widget.boxHeight,
        child: Row(
          children: list,
        ));
  }

  //房态数据表，不包括侧边的房源信息和顶部的日期信息
  Widget bodyContainerView(BuildContext context) {
    //为了让同一行的滚动是同步的，因此，把一整行的房态都绘制了出来，虽然导致后面速度较快，但前面加载时间会比较长
    return Container(
        width: widget.boxWidth * (widget.headerList.length).toDouble(),
        // height: 5000, //由于父容器是横向滚动的、无约束的，所以高度不受限，会自动扩充到最大，当前上级设置了Flexible
        color: widget.tableColor,
        child: new ListView.builder(
          itemCount: widget.tableList.length,
          physics: ClampingScrollPhysics(),
          //划到尽头，没有回弹
          shrinkWrap: true,
          primary: false,
          //内容不足时不滚动
          controller: _bodyController,
          itemBuilder: (context, index) {
            return bodyListView(context, index);
          },
        ));
  }

  //左侧列表格子
  Widget leftBox(BuildContext context, int yIndex) {
    if (widget.leftBoxTap != null) {
      return new GestureDetector(
          onTap: () {
            //处理点击事件
            widget.leftBoxTap(yIndex);
          },
          child: leftBoxChild(context, yIndex));
    } else {
      return leftBoxChild(context, yIndex);
    }
  }

  Widget leftBoxChild(BuildContext context, int yIndex) {
    return new Container(
        width: widget.leftWidth - 2 * widget.boxMargin,
        height: widget.boxHeight - 2 * widget.boxMargin,
        margin: EdgeInsets.all(widget.boxMargin),
        child: widget.tableList[yIndex]['leftWidget'] != null
            ? widget.tableList[yIndex]['leftWidget']
            : Text(
                widget.tableList[yIndex]['leftTitle'],
                style: TextStyle(fontSize: 10.0, color: Colors.green),
              ));
  }

  //左侧列表
  Widget leftListView(BuildContext context) {
    return Container(
        width: widget.leftWidth,
        color: widget.leftColor,
        child: ListView.builder(
          itemCount: widget.tableList.length,
          physics: NeverScrollableScrollPhysics(),
          //禁用手动滑动，以免不同步，也不进行双向监听
          scrollDirection: Axis.vertical,
          //水平报错'constraints.hasBoundedHeight': is not true.
          shrinkWrap: true,
          controller: _xController,
          //设置监听，根绝房态部分进行滑动
          itemBuilder: (context, index) {
            return leftBox(context, index);
          },
        ));
    //children: list));
  }

  //左侧顶部固定格子
  Widget leftTopFixed(BuildContext context) {
    if (widget.leftTopBoxTap != null) {
      return new GestureDetector(
          onTap: () {
            //处理点击事件
            widget.leftTopBoxTap();
          },
          child: leftTopFixedChild(context));
    } else {
      return leftTopFixedChild(context);
    }
  }

  Widget leftTopFixedChild(BuildContext context) {
    return new Container(
      width: widget.leftWidth - 2 * widget.boxMargin,
      height: widget.headerHeight - 2 * widget.boxMargin,
      margin: EdgeInsets.all(widget.boxMargin),
      color: widget.leftTopColor,
      child: widget.leftTopWidget != null
          ? widget.leftTopWidget
          : Text(
              widget.leftTopString,
              style: TextStyle(fontSize: 10.0, color: Colors.green),
            ),
    );
  }

//左侧整体列表
  Widget leftListAndFixed(BuildContext context) {
    var list = <Widget>[];
    if (widget.hasHeader) {
      list.add(leftTopFixed(context));
    }
    list.add(Flexible(child: leftListView(context)));

    return Container(
      width: widget.leftWidth,
      child: Column(children: list),
    );
  }

  //右侧列表格子
  Widget rightBox(BuildContext context, yIndex) {
    if (widget.rightBoxTap != null) {
      return new GestureDetector(
          onTap: () {
            //处理点击事件
            widget.rightBoxTap(yIndex);
          },
          child: rightBoxChild(context, yIndex));
    } else {
      return rightBoxChild(context, yIndex);
    }
  }

  Widget rightBoxChild(BuildContext context, yIndex) {
    return new Container(
      width: widget.rightWidth - 2 * widget.boxMargin,
      height: widget.boxHeight - 2 * widget.boxMargin,
      margin: EdgeInsets.all(widget.boxMargin),
      color: Colors.lightGreen,
      child: widget.tableList[yIndex]['rightWidget'] != null
          ? widget.tableList[yIndex]['rightWidget']
          : Text(
              widget.tableList[yIndex]['rightTitle'],
              style: TextStyle(fontSize: 10.0, color: Colors.green),
            ),
    );
  }

  //右侧列表
  Widget rightListView(BuildContext context) {
    return Container(
        width: widget.rightWidth,
        color: widget.rightColor,
        child: ListView.builder(
          itemCount: widget.tableList.length,
          physics: NeverScrollableScrollPhysics(),
          //禁用手动滑动，以免不同步，也不进行双向监听
          scrollDirection: Axis.vertical,
          //水平报错'constraints.hasBoundedHeight': is not true.
          shrinkWrap: true,
          controller: _xController,
          //设置监听，根绝房态部分进行滑动
          itemBuilder: (context, index) {
            return rightBox(context, index);
          },
        ));
    //children: list));
  }

  //右侧顶部固定格子
  Widget rightTopFixed(BuildContext context) {
    if (widget.rightTopBoxTap != null) {
      return new GestureDetector(
          onTap: () {
            //处理点击事件
            widget.rightTopBoxTap();
          },
          child: rightTopFixedChild(context));
    } else {
      return rightTopFixedChild(context);
    }
  }

  Widget rightTopFixedChild(BuildContext context) {
    return new Container(
      width: widget.rightWidth - 2 * widget.boxMargin,
      height: widget.headerHeight - 2 * widget.boxMargin,
      margin: EdgeInsets.all(widget.boxMargin),
      color: widget.rightTopColor,
      child: widget.rightTopWidget != null
          ? widget.rightTopWidget
          : Text(
              widget.rightTopString,
              style: TextStyle(fontSize: 10.0, color: Colors.green),
            ),
    );
  }

  //右侧整体列表
  Widget rightListAndFixed(BuildContext context) {
    var list = <Widget>[];
    if (widget.hasHeader) {
      list.add(rightTopFixed(context));
    }
    list.add(Flexible(child: rightListView(context)));

    return Container(
      width: widget.rightWidth,
      child: Column(children: list),
    );
  }
}
