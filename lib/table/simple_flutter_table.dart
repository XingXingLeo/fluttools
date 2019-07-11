import 'package:flutter/material.dart';
import 'package:flutter_app/table/abstract_flutter_table.dart';

class SimpleFlutterTable extends FlutterTableAbstract {
  final String leftTopString;
  final String rightTopString;
  final bool hasHeader;
  final bool hasLeft;
  final bool hasRight;

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
  final AlignmentDirectional tableAlignment;
  final AlignmentDirectional headerAlignment;
  final AlignmentDirectional leftAlignment;
  final AlignmentDirectional rightAlignment;
  final AlignmentDirectional leftTopAlignment;
  final AlignmentDirectional rightTopAlignment;

  SimpleFlutterTable({
    Key key,
    this.hasHeader = false,
    this.hasLeft = false,
    this.hasRight = false,
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
    this.tableColor = Colors.white,
    this.headerColor = Colors.white,
    this.leftColor = Colors.white,
    this.leftTopColor = Colors.white,
    this.rightColor = Colors.white,
    this.rightTopColor = Colors.white,
    this.bodyBoxTap,
    this.headerBoxTap,
    this.leftBoxTap,
    this.rightBoxTap,
    this.rightTopBoxTap,
    this.leftTopBoxTap,
    this.leftAlignment = AlignmentDirectional.center,
    this.leftTopAlignment = AlignmentDirectional.center,
    this.rightAlignment = AlignmentDirectional.center,
    this.rightTopAlignment = AlignmentDirectional.center,
    this.headerAlignment = AlignmentDirectional.center,
    this.tableAlignment = AlignmentDirectional.center,
  });

  LanzuTablePage createState() => LanzuTablePage();
}

class LanzuTablePage extends FlutterTableState<SimpleFlutterTable> {
  @override
  Widget build(BuildContext context) {
    return lanzuTableWight(context);
  }

  @override
  Widget rightTopFixedChildContent(BuildContext context) {
    return Text(
      widget.rightTopString,
      style: TextStyle(fontSize: 10.0, color: Colors.green),
    );
  }

  @override
  Widget rightBoxChildContent(BuildContext context, yIndex) {
    return Text(
      widget.tableList[yIndex]['rightTitle'],
      style: TextStyle(fontSize: 10.0, color: Colors.green),
    );
  }

  @override
  Widget leftTopFixedChildContent(BuildContext context) {
    return Text(
      widget.leftTopString,
      style: TextStyle(fontSize: 10.0, color: Colors.green),
    );
  }

  @override
  Widget leftBoxChildContent(BuildContext context, int yIndex) {
    return Text(
      widget.tableList[yIndex]['leftTitle'],
      style: TextStyle(fontSize: 10.0, color: Colors.green),
    );
  }

  @override // 表格盒子里的内容
  Widget bodyBoxChildContent(BuildContext context, yIndex, xIndex) {
    return Text(
      widget.tableList[yIndex]['data'][xIndex]['title'],
      style: TextStyle(fontSize: 10.0, color: Colors.green),
    );
  }

  @override
  Widget headerBoxChildContent(BuildContext context, int xIndex) {
    return Text(
      widget.headerList[xIndex]['title'],
      style: TextStyle(fontSize: 10.0, color: Colors.green),
    );
  }
}
