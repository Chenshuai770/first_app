import 'package:flutter/material.dart';

/**
 * build方法中的ConstraintedBox组件和Material组件都是直接参考的Drawer类的源码，
 * constraints参数指定了侧滑菜单的宽度，elevation参数控制的是Drawer后面的阴影的大小，默认值就是16（所以这里可以不指定elevation参数），
 * 最主要的是ListView的命名构造方法build，itemCount参数代表item的个数，
 * 这里之所以是menuTitles.length * 2 + 1，其中的*2是将分割线算入到item中了，+1则是把顶部的封面图算入到item中了。
 * 下面是关键的renderRow方法：
 */
class MyDrawer extends StatelessWidget {
  // 菜单文本前面的图标大小
  static const double IMAGE_ICON_WIDTH = 30.0;

  // 菜单后面的箭头的图标大小
  static const double ARROW_ICON_WIDTH = 16.0;

  // 菜单后面的箭头图片
  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  // 菜单的文本
  List menuTitles = ['发布动弹', '动弹小黑屋', '关于', '设置'];

  // 菜单文本前面的图标
  List menuIcons = [
    './images/leftmenu/ic_fabu.png',
    './images/leftmenu/ic_xiaoheiwu.png',
    './images/leftmenu/ic_about.png',
    './images/leftmenu/ic_settings.png'
  ];

  // 菜单文本的样式
  TextStyle menuStyle = new TextStyle(
    fontSize: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: const BoxConstraints.expand(width: 304.0),
      child: new Material(
        elevation: 16,
        child: new Container(
          //drawer的背景颜色
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: new ListView.builder(

            itemCount: menuTitles.length * 2 + 1,
            itemBuilder: renderRow,
          ),

        ),
      ),
    );
  }


  Widget renderRow(BuildContext context, int index) {
    if (index == 0) {
      var img = new Image.asset(
        'images/cover_img.jpg',
        width: 304.0,
        height: 304.0,
      );
      return new Container(
        width: 304,
        height: 304,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: img,
      );
    }
    // 舍去之前的封面图
    index -= 1;
    if (index.isOdd) {
      return new Divider();
    }
    // 偶数，就除2取整，然后渲染菜单item
    index = index ~/ 2;
    // 菜单item组件
    var listItemContent = new Padding(
      // 设置item的外边距
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      // Row组件构成item的一行
      child: new Row(
      // 菜单item的图标
        children: <Widget>[
          // 菜单item的图标
          getIconImage(menuIcons[index]),
          // 菜单item的文本，需要
          new Expanded(
              child: new Text(
                menuTitles[index],
                style: menuStyle,
              )
          ),
          rightArrowIcon
        ],
      ),
    );
    return new InkWell(
      child: listItemContent,
      onTap: (){
       /* switch (index) {
          case 0:
          // 发布动弹
            Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
              return new PublishTweetPage();
            }));
            break;
          case 1:
          // 小黑屋
            Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
              return new BlackHousePage();
            }));
            break;
          case 2:
          // 关于
            Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
              return new AboutPage();
            }));
            break;
          case 3:
          // 设置
            Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
              return new SettingsPage();
            }));
            break;
        }*/
      },
    );
  }

  Widget getIconImage(String path) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 6, 0),
      child: new Image.asset(path,width: 28,height: 28),
    );

  }
}