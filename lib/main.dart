import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());
String url = '';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        "/": (_) => HomePage(),
        "/wv": (_) => WebviewScaffold(
              initialChild: Container(
                child: const Center(
                  child: Text('Waiting.....'),
                ),
              ),
              url: url,
              appBar: AppBar(
                title: Text('Parts Online Chatbot'),
              ),
            )
      },
      title: 'Flutter Demo',
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username;
  String _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createHomeScreen(context),
    );
  }

  createHomeScreen(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF777EF7), Color(0xFF280077)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Stack(
        children: <Widget>[backgroundCard(context), foregroundCard(context)],
      ),
    );
  }

  backgroundCard(BuildContext context) {
    double marginLeft = MediaQuery.of(context).size.width / 0.25;
    double marginTop = MediaQuery.of(context).size.height / 0.25;
    return new Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      padding: new EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.1,
        horizontal: 20.0,
      ),
      child: new Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white70,
        ),
      ),
    );
  }

  foregroundCard(BuildContext context) {
    double marginLeft = MediaQuery.of(context).size.width / 0.25;
    double marginTop = MediaQuery.of(context).size.height / 0.25;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: new Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        padding: new EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1,
          horizontal: 40.0,
        ),
        child: new Container(
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.white,
            child: buildForm(context),
          ),
        ),
      ),
    );
  }

  buildForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildIcon(),
        buildTitle(),
        buildText(),
        buildFields(),
        buildLogin()
      ],
    );
  }

  buildIcon() {
    return Image.asset('assets/volvo.jpeg',);
  }

  buildTitle() {
    return Text(
      'Parts Online Chatbot',
      style: TextStyle(fontSize: 25.0, color: Colors.grey),
    );
  }

  buildText() {
    return Text(
      'Please enter your credentials\nto access your\npersonalized chatbot',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15.0, color: Colors.grey),
    );
  }

  buildFields() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (String s) {
              setState(() {
                _username = s;
              });
            },
            decoration: InputDecoration(
              icon: Icon(CupertinoIcons.profile_circled),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (String s) {
              _password = s;
            },
            decoration: InputDecoration(
              icon: Icon(CupertinoIcons.pencil),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  buildLogin() {
    return RaisedButton(
      shape: StadiumBorder(),
      child: Text(_isLoading? 'LOADING': 'LOGIN'),
      onPressed: _isLoading ? null : () => _login(context),
    );
  }

  _login(context) async {
    setState(() {
      _isLoading = true;
    });
    http.Response res = await http.get(
        'https://partsonlinelogin.azurewebsites.net/api/login/$_username?password=$_password');
    setState(() {
      _isLoading = false;
    });
    if (res.body.contains('true')) {
      url =
          'https://partonline.azurewebsites.net/chat.html?userid=$_username';
      Navigator.of(context).pushNamed('/wv');
    }
  }
}
