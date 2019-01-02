import 'package:first_app/pages/NewsDetailPage.dart';
import 'package:first_app/widgets/SlideViewIndicator.dart';
import 'package:flutter/material.dart';

/**
 * 侧滑栏
 */
class SlideView extends StatefulWidget {

  var data;
  SlideViewIndicator slideViewIndicator;

  SlideView(data, indicator) {
    this.data = data;
    this.slideViewIndicator = indicator;
  }

  @override
  State<StatefulWidget> createState() {
    // 可以在构造方法中传参供SlideViewState使用
    // 或者也可以不传参数，直接在SlideViewState中通过this.widget.data访问SlideView中的data变量
    return new SlideViewState();
  }

}
//Tab页的切换搭配了动画，因此到State类上附加一个SingleTickerProviderStateMixin:
class SlideViewState extends State<SlideView>
    with SingleTickerProviderStateMixin {
  // TabController为TabBarView组件的控制器
  TabController tabController;

  List slideData;

  @override
  void initState() {
    super.initState();
    slideData = this.widget.data;
    // 初始化控制器
    tabController = new TabController(
        length: slideData == null ? 0 : slideData.length, vsync: this);
    tabController.addListener(() {
      //判断当前选中的state是哪个
      if (this.widget.slideViewIndicator.state.mounted) {
        this.widget.slideViewIndicator.state.setSelectedIndex(
            tabController.index);
      }
    });
  }

  @override
  void dispose() {
    // 销毁
    tabController.dispose();
    super.dispose();
  }

  Widget generateCard() {
    return new Card(
      color: Colors.blue,
      child: new Image.asset(
        "images/ic_avatar_default.png", width: 20.0, height: 20.0,),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> items = [];
    if (slideData != null && slideData.length > 0) {
      print(slideData.length);
      for (var i = 0; i < slideData.length; i++) {
        var item = slideData[i];
        var imgUrl = item['imgUrl'];
        var title = item['title'];
        var detailUrl = item['detailUrl'];
        items.add(new GestureDetector(
          //吃掉了父类的点击事件
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (ctx) => new NewsDetailPage(id: detailUrl))
            );
          },
          child: new Stack( // Stack组件用于将资讯标题文本放置到图片上面
            children: <Widget>[

              new Image.network(imgUrl, width: MediaQuery
                  .of(context)
                  .size
                  .width, fit: BoxFit.contain),
              new Container(
                // 标题容器宽度跟屏幕宽度一致
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  // 背景为黑色，加入透明度
                  color: const Color(0x50000000),
                  child: new Padding(
                    padding: const EdgeInsets.all(6.0),
                    // 字体大小为15，颜色为白色
                    child: new Text(title, style: new TextStyle(
                        color: Colors.white, fontSize: 15.0)),
                  )
              )
            ],
          ),
        ));
      }
    }
    return new TabBarView(
        controller: tabController,
        children: items);
  }
}