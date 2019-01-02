import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/**
 * 1. 在build方法中我们返回的是一个Scaffold组件，而不是像main.dart中那样返回一个MaterialApp组件，这是因为我们在使用Navigator从资讯列表页跳转到详情页时，会自动为详情页的AppBar左边添加返回按钮，如果你在详情页还是使用MaterialApp对象，则页面左上角不会自动添加返回按钮。
 * 2. 上面代码中的body部分返回的是一个Center组件，Center中装的是Column组件，如果你不为Column组件设置mainAxisAlignment: MainAxisAlignment.center，则页面上的组件只会在水平方向居中而不会在垂直方向上居中。
 * 3. 使用Navigator.of(context).pop()来使页面返回到上一级。
 *
 * 用了一个 webview 组件,将一个url交给webview处理
 */
class NewsDetailPage extends StatefulWidget {
  String id;

  NewsDetailPage({Key key, this.id}):super(key: key);

  @override
  State<StatefulWidget> createState() => new NewsDetailPageState(id: this.id);
}

class NewsDetailPageState extends State<NewsDetailPage> {

  String id;
  bool loaded = false;
  String detailDataStr;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  NewsDetailPageState({Key key, this.id});

  @override
  void initState() {
    super.initState();
    // 监听WebView的加载事件
    flutterWebViewPlugin.onStateChanged.listen((state) {
      print("state: ${state.type}");
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(new Text("资讯详情", style: new TextStyle(color: Colors.white),));
    if (!loaded) {
      titleContent.add(new CupertinoActivityIndicator());
    }
    titleContent.add(new Container(width: 50.0));
    return new WebviewScaffold(
      url: this.id,//加载具体数据
      appBar: new AppBar(
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}