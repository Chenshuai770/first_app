import 'package:first_app/pages/TweetDetailPage.dart';
import 'package:flutter/material.dart';

/**
 * 推文列表
 */
class TweetsListPage extends StatelessWidget{
  // 热门动弹数据
  List hotTweetsList = [];
  // 普通动弹数据
  List normalTweetsList = [];
  // 动弹作者文本样式
  TextStyle authorTextStyle;
  // 动弹时间文本样式
  TextStyle subtitleStyle;
  // 屏幕宽度
  double screenWidth;

  RegExp regExp1 = new RegExp("</.*>");
  RegExp regExp2 = new RegExp("<.*>");

  // 构造方法中做数据初始化
  TweetsListPage() {
    authorTextStyle = new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
    subtitleStyle = new TextStyle(fontSize: 12.0, color: const Color(0xFFB5BDC0));
    // 添加测试数据
    for (int i = 0; i < 20; i++) {
      Map<String, dynamic> map = new Map();
      // 动弹发布时间
      map['pubDate'] = '2018-7-30';
      // 动弹文字内容
      map['body'] = '早上七点十分起床，四十出门，花二十多分钟到公司，必须在八点半之前打卡；下午一点上班到六点，然后加班两个小时；八点左右离开公司，呼呼登自行车到健身房锻炼一个多小时。到家已经十点多，然后准备第二天的午饭，接着收拾厨房，然后洗澡，吹头发，等能坐下来吹头发时已经快十二点了。感觉很累。';
      // 动弹作者昵称
      map['author'] = '红薯';
      // 动弹评论数
      map['commentCount'] = 10;
      // 动弹作者头像URL
      map['portrait'] = 'https://static.oschina.net/uploads/user/0/12_50.jpg?t=1421200584000';
      // 动弹中的图片，多张图片用英文逗号隔开
      map['imgSmall'] = 'https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg';
      hotTweetsList.add(map);
      normalTweetsList.add(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth=MediaQuery.of(context).size.width;

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new TabBar(
           tabs: <Widget>[
             new Tab(text: "动弹列表"),
             new Tab(text: "热门动弹"),
           ],
        ),
        body: new TabBarView(
            children: <Widget>[getHotListView(),getHotListView()],
        ),
      ),

    );
  }

  // 获取普通动弹列表
  Widget getNormalListView() {
    return new ListView.builder(
        itemCount: normalTweetsList.length * 2 - 1,
        itemBuilder: (context, i) => renderNormalRow(context,i)
    );
  }

  // 获取热门动弹列表
  Widget getHotListView() {
    return new ListView.builder(
      itemCount: hotTweetsList.length * 2 - 1,
      itemBuilder: (context, i) => renderHotRow(context,i),
    );
  }

  // 渲染普通动弹列表Item
  renderHotRow(context,i) {
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      i = i ~/ 2;
      return getRowWidget(context,hotTweetsList[i]);
    }
  }

  // 渲染热门动弹列表Item
  renderNormalRow(context,i) {
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      i = i ~/ 2;
      return getRowWidget(context,normalTweetsList[i]);
    }
  }

  /**
   * 绘制具体的item
   */
  Widget getRowWidget(context,Map<String, dynamic> listItem) {
    // 列表item的第一行，显示动弹作者头像、昵称、评论数
    var authorRow = new Row(
      // 用户头像
      children: <Widget>[
        new Container(
          width: 35.0,
          height: 35.0,
          // 头像显示为圆形
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            image: new DecorationImage(
                image: new NetworkImage(listItem['portrait']),
                fit: BoxFit.cover),
            // 头像边框
            border: new Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        // 动弹作者的昵称
        new Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            child: new Text(
                listItem['author'],
                style: new TextStyle(fontSize: 16.0)
            )
        ),
        // 动弹评论数，显示在最右边
        new Expanded(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(
                '${listItem['commentCount']}',
                style: subtitleStyle,
              ),
              new Image.asset(
                './images/ic_comment.png',
                width: 16.0,
                height: 16.0,
              )
            ],
          ),
        )
      ],
    );
    // 动弹内容，纯文本展示
    var _body = listItem['body'];
    _body = clearHtmlContent(_body);
    var contentRow = new Row(
      children: <Widget>[
        new Expanded(child: new Text(_body))
      ],
    );

    //第三行，显示动弹中的图片，没有图片则不展示这一行
    var timeRow = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Text(
          listItem['pubDate'],
          style: subtitleStyle,
        )
      ],
    );
    /**
     * 以九宫格的形式显示图片稍微麻烦些，
     * 这也是为什么之前我们要在build方法中获取屏幕的宽度，
     * 因为要根据这个宽度来计算九宫格中图片的宽度。
     * 另外，九宫格中的图片URL是以字符串形式给出的，以英文逗号隔开的，所以需要对图片URL做分割处理。
     * 如果动弹中有图片，可能有1～9张，

     */
    var columns = <Widget>[
      new Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 2.0),
        child: authorRow,
      ),
      new Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 0.0, 10.0, 0.0),
        child: contentRow,
      ),
    ];
    String imgSmall = listItem['imgSmall'];
    if (imgSmall != null && imgSmall.length > 0) {
      // 动弹中有图片
      List<String> list = imgSmall.split(",");
      List<String> imgUrlList = new List<String>();
      for (String s in list) {
        if (s.startsWith("http")) {
          imgUrlList.add(s);
        } else {
          imgUrlList.add("https://static.oschina.net/uploads/space/" + s);
        }
      }
      List<Widget> imgList = [];
      List<List<Widget>> rows = [];
      num len = imgUrlList.length;
      for (var row = 0; row < getRow(len); row++) {
        List<Widget> rowArr = [];
        for (var col = 0; col < 3; col++) {
          num index = row * 3 + col;
          num screenWidth = MediaQuery.of(context).size.width;
          double cellWidth = (screenWidth - 100) / 3;
          if (index < len) {
            rowArr.add(new Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Image.network(imgUrlList[index],
                  width: cellWidth, height: cellWidth),
            ));
          }
        }
        rows.add(rowArr);
      }
      for (var row in rows) {
        imgList.add(new Row(
          children: row,
        ));
      }
      columns.add(new Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 5.0, 10.0, 0.0),
        child: new Column(
          children: imgList,
        ),
      ));
    }
    columns.add(new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 6.0),
      child: timeRow,
    ));
    return new InkWell(
      child: new Column(
        children: columns,
      ),
      onTap: () {
        // 跳转到动弹详情
        /*Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
          return new TweetDetailPage(
            tweetData: listItem,
          );
        }));*/
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return new AlertDialog(
                title: new Text('提示'),
                content: new Text('要把\"${listItem['author']}\"关进小黑屋吗？'),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      '取消',
                      style: new TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text(
                      '确定',
                      style: new TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      //putIntoBlackHouse(listItem);
                    },
                  )
                ],
              );
            });
      },
    );
  }

  /**
   *  获取行数，n表示图片的张数
   *  如果n取余不为0，则行数为n取整+1，否则n取整就是行数
   *  比如一共有9张图片，9 % 3为0，则一共有9 ~/3 = 3行，如果一共有5张图片，5 % 3 != 0，则行数为5 ~/ 3再+1即两行。
   */
  int getRow(int n) {
    int a = n % 3;
    int b = n ~/ 3;
    if (a != 0) {
      return b + 1;
    }
    return b;
  }

  // 去掉文本中的html代码
  String clearHtmlContent(String str) {
    if (str.startsWith("<emoji")) {
      return "[emoji]";
    }
    var s = str.replaceAll(regExp1, "");
    s = s.replaceAll(regExp2, "");
    s = s.replaceAll("\n", "");
    return s;
  }




}