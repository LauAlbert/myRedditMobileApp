import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'redditList.dart';

void main() => runApp(new RedditApp());


class RedditApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Reddit",
      home: new Reddit(),
    );
  }
}

class Reddit extends StatefulWidget {
  @override
  createState() => new RedditState();
}

class RedditState extends State<Reddit> {

  var _redditPostList = new redditList();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRow(int i) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new ListTile(
          title: new Text("${i}. ${_redditPostList.postList[i]['data']['title']}", style: _biggerFont)),
    );
  }

  _loadData() async {
    var httpClient = new HttpClient();

    String dataURL = "https://api.reddit.com";
    var uri = new Uri.http('api.reddit.com', '/best');

    var request = await httpClient.getUrl(uri);

    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();

//    http.Response response = await http.get(dataURL);
    setState(() {
      var responseMap = json.decode(responseBody);

      List<dynamic> responseMapChildren = responseMap['data']['children'];
      responseMapChildren.forEach((children) => print(children['data']['title']));
      if(responseMapChildren != null)
      {
        _redditPostList.addPostList(responseMapChildren);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Reddit"),
      ),
      body: new ListView.builder(
          itemCount: _redditPostList.postList.length * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return new Divider();

            final index = position ~/ 2;

            return _buildRow(index);
          }),
    );
  }
}