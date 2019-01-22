import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //标题的颜色设置
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      //主体
      home: RandomWords(),
    );
  }

}



class RandomWordsState extends State<RandomWords> {
  /*
   *数组集合 
   */
  final _suggestions = <WordPair>[];
  ///组件textview
  var _biggerFont;
  ///保存的数组集合
  final _saved = Set<WordPair>();
  @override
  Widget build(BuildContext context) {
    //初始化textview
    _biggerFont = const TextStyle(fontSize: 18.0);

    return Scaffold(
      appBar: AppBar(
        //标题
        title: Text('Startup Name Generator',textAlign: TextAlign.center,),
        //添加右菜单栏
        actions: <Widget>[
          //菜单栏按钮(点击的图标,点击调用的方法)
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      //主体
      body: _buildSuggestions(),
    );
  }

/*
 *点击的方法 被调用的方法
 */
  void _pushSaved() {
    //建立新的页面
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        //itemview
        final tiles = _saved.map(
          (pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        //快速生成适配器
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          //设置
          body: ListView(children: divided),
        );
      },
    ));
  }

/**
 * listview主体
 */
  Widget _buildSuggestions() {
    return ListView.builder(
      //设置padding
      padding: const EdgeInsets.all(16.0),
      //item
      itemBuilder: (context, i) {
        //画间隔线
        if (i.isOdd) return Divider();
        //获取无限的添加的数量
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          //数据再次添加
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

/*
 *itemview单个 
 */
  Widget _buildRow(WordPair pair) {
    //保存的数组是否有 boolean
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        //文本
        pair.asPascalCase,
        //textview
        style: _biggerFont,
      ),
      //标题后显示的小部件。
      trailing: Icon(
        //是否在保存的数组中,红心组件
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        //颜色
        color: alreadySaved ? Colors.red : null,
      ),
      //当用户单击此列表块时调用。
      onTap: () {
        //通知框架这个对象的内部状态已经改变。
        setState(() {
          //判断是否存在保存的数组
          if (alreadySaved) {
            //移除
            _saved.remove(pair);
          } else {
            //添加
            _saved.add(pair);
          }
        });
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => RandomWordsState();
}
