import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Model/User.dart';
import './Services/UserService.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: FirebaseFireStoreDemo(),
    );
  }
}

class FirebaseFireStoreDemo extends StatefulWidget {

  FirebaseFireStoreDemo() : super();
  final String title = 'CloudFireStore Demo';

  @override
  _FirebaseFireStoreDemoState createState() => _FirebaseFireStoreDemoState();
}

class _FirebaseFireStoreDemoState extends State<FirebaseFireStoreDemo> {
  bool _showTextField = false;
  TextEditingController _controller = TextEditingController();
  final String _collectionName = 'Users';
  bool _isEditing = false;
  User _user, _curUser;
  UserService userService;

  add() {
    if (_isEditing) {
      userService.update(_curUser, _controller.text);
      setState(() {
        _isEditing = false;
      });
    } else {
      userService.addUser(_controller.text);
    }
    _controller.text = '';
  }

  @override
  void initState() {
    super.initState();
    _user = new User();
    userService = new UserService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _showTextField = !_showTextField;
              });
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _showTextField
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: 'Name', hintText: 'Enter Name'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  button(),
                ],
              )
                  : Container(),
              Text(
                "USERS",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: buildBody(context),
              )
            ],
          )),
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: userService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print('Documents ${snapshot.data.documents.length}');
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final user = User.fromSnapshot(data);
    return Padding(
      key: ValueKey(user.name),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
          title: Text(user.name),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              userService.delete(user);
            },
          ),
          onTap: () {
            setUpdateUI(user);
          },
        ),
      ),
    );
  }

  void setUpdateUI(User user) {
    _controller.text = user.name;
    setState(() {
      _showTextField = true;
      _isEditing = true;
      _curUser = user;
    });
  }

  button() {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        child: Text(_isEditing ? "UPDATE" : "ADD"),
        onPressed: () {
          add();
          setState(() {
            _showTextField = false;
          });
        },
      ),
    );
  }
}
