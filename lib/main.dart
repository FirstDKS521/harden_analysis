import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:convert';
import 'analysis_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HardenState();
  }
}

List<Analysis> contentData = [];
double screenH = 0;

class HardenState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _sendHardenAnalysisRequest();
  }

  /// 网络请求
  void _sendHardenAnalysisRequest() async {
    String strUrl = 'https://eq.10jqka.com.cn/wencai/index.php';
    var client = http.Client();
    http.Response response = await client.get(strUrl);
    setState(() {
      String jsonStr = response.body;
      Map testMap = jsonDecode(jsonStr);
      for (var tempMap in testMap["data"]["data"]) {
        Analysis analysis = new Analysis.fromJson(tempMap);
        contentData.add(analysis);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, //隐藏导航栏右上角图标
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  void _pushSaved() {
    print('点击搜索框');
  }

  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: new AppBar(
        backgroundColor: Color(0xFFF44848),
        title: new Text(
          '涨停分析',
          style: TextStyle(
            fontSize: 19,
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search, color: Colors.white),
            onPressed: _pushSaved,
          ),
        ],
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    if (contentData.length == 0) {
      return _loadingView();
    }
    return new ListView.builder(
      itemBuilder: (content, i) {
        if (i >= contentData.length) {
          return null;
        }
        return buildOneRow(i);
      },
    );
  }

  ///创建单行Row
  Widget buildOneRow(int index) {
    Analysis analysis = contentData[index];
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      child: new Column(
        children: <Widget>[
          buildStockRow(analysis.name, analysis.code),
          buildPropertyGrid(index),
          buildContentView(index),
        ],
      ),
    );
  }

  ///创建股票信息行
  Widget buildStockRow(String nameStr, String codeStr) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: GestureDetector(
        // behavior: HitTestBehavior.translucent, //可以使整行可点击
        onTap: () {
          print('点击了股票：' + nameStr + ' ' + codeStr);
        },
        child: Row(
          children: [
            Text(
              nameStr + ' ' + codeStr,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7098C5),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///创建属性列表
  Widget buildPropertyGrid(int idx) {
    Analysis analysis = contentData[idx];
    return new GridView.custom(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 3,
      ),
      primary: false,
      shrinkWrap: true, //解决无限高度问题
      physics: NeverScrollableScrollPhysics(), //禁用滑动事件
      padding: const EdgeInsets.all(8.0),
      childrenDelegate: new SliverChildBuilderDelegate(
        (context, index) {
          AnalysisData data = analysis.data[index];
          return GestureDetector(
            onTap: () {
              print(data.name + ' ' + data.stockCode);
            },
            child: Container(
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.black38, width: 0.5),
                borderRadius: new BorderRadius.circular(4.0),
              ),
              alignment: Alignment.center,
              child: new Text(
                data.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF333333),
                ),
              )
            )
          );
        },
        childCount: analysis.data.length, //控制显示item的个数
      ),
    );
  }

  ///创建涨停内容信息
  Widget buildContentView(int index) {
    Analysis analysis = contentData[index];
    AnalysisNews news = analysis.news;
    String titleStr = news.title;
    String contentStr = news.summ;
    String timeStr = news.date;

    return GestureDetector(
      onTap: () {
        print('点击查看详情：' + analysis.code);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '涨停原因:' + titleStr,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.left,
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: Text(
                contentStr,
                maxLines: 3, //最大行数
                overflow: TextOverflow.ellipsis, //显示省略号
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            new Offstage(
              offstage: timeStr.length > 0 ? false : true,
              child: new Container(
                child: Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  ///预加载布局
  Widget _loadingView() {
    return new Container(
      height: screenH,
      child: new Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new CircularProgressIndicator(
            strokeWidth: 1.0,
          ),
          new Text("加载中..."),
        ],
      )),
    );
  }
}
