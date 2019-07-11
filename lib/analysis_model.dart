class Analysis {
  String code;
  String name;
  num rate;
  List<AnalysisData> data;
  AnalysisNews news;

  Analysis({
    this.code,
    this.name,
    this.rate,
    this.data,
    this.news,
  });

  factory Analysis.fromJson(Map<String, dynamic> parsedJson) {
    // var dataFromJson = parsedJson['data'];
    // List<AnalysisData> dataList = dataFromJson.cast<AnalysisData>();
    //解决字典里面包含数组，数组里面包含字典的转换方式
    var list = parsedJson['data'] as List;
    List<AnalysisData> dataList = list.map((i) => AnalysisData.fromJson(i)).toList();

    return Analysis(
      code: parsedJson["code"],
      name: parsedJson["name"],
      rate: parsedJson["rate"],
      data: dataList, //parsedJson['data'],
      news: AnalysisNews.fromJson(parsedJson["news"]),
    );
  }
}

//data
class AnalysisData {
  String stockCode;
  String name;
  String type;

  AnalysisData({this.stockCode, this.name, this.type});

  factory AnalysisData.fromJson(Map<String, dynamic> parsedJson) {
    return AnalysisData(
      stockCode: parsedJson['id'],
      name: parsedJson["name"],
      type: parsedJson["type"],
    );
  }
}

//news
class AnalysisNews {
  String title;
  String summ;
  String url;
  String date;

  AnalysisNews({
    this.title,
    this.summ,
    this.url,
    this.date,
  });

  factory AnalysisNews.fromJson(Map<String, dynamic> parsedJson) {
    var summStr = parsedJson["summ"];
    var newSummStr = summStr.replaceAll(RegExp("\n"), ""); //字符串替换

    return AnalysisNews(
      title: parsedJson['title'],
      summ: newSummStr,
      url: parsedJson["url"],
      date: parsedJson["date"],
    );
  }
}

// "code": "002955",
// "name": "鸿合科技",
// "rate": 44,
// "data": [
//     {
//         "id": "885598",
//         "name": "新股与次新股",
//         "type": "concept",
//         "change": -1.89
//     },
//     {
//         "id": "881130",
//         "name": "计算机设备",
//         "type": "sector",
//         "change": -3.09
//     }
// ],
// "news": {
//     "title": "鸿合科技今日上市 发行价格52.41元/股",
//     "summ": "鸿合科技今日在深圳证券交易所中小企业板上市，公司证券代码：002955，发行价格52.41元/股，首次公开发行股票数量：34,310,000股。\n\n主营业务：智能交互显示产品及智能视听解决方案的设计、研发、生产与销售，自设立以来一直专注于多媒体电子产品文字、图像、音频、视频等信息交流和处理技术的研发与应用，在光电显示和成像、触控、信息传输和处理、电子电路、人机交互、云计算和大数据、智能视听解决方案等软硬件技术领域积累了丰富的成果和经验，形成了以智能交互平板、电子交互白板、投影机、视频展台等智能交互显示产品为基础，以智能视听解决方案为拓展和延伸的多媒体电子产品业务线，是行业的龙头企业之一。",
//     "url": "",
//     "content_title": "鸿合科技 2019-05-23涨停原因",
//     "date": ""
// }
