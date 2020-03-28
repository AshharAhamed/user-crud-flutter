//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
//import '../Services/UserService.dart';
//
//Widget buildBody(){
//
//  final UserService userService = UserService();
//  return StreamBuilder<QuerySnapshot>(
//    stream: userService.getUsers(),
//    builder: (context, snapshot) {
//      if (snapshot.hasError) {
//        return Text('Error ${snapshot.error}');
//      }
//      if (snapshot.hasData) {
//        print('Documents ${snapshot.data.documents.length}');
//        return buildList(context, snapshot.data.documents);
//      }
//      return CircularProgressIndicator();
//    },
//  );
//}
//
//Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//  return ListView(
//    children: snapshot.map((data) => buildListItem(context, data)).toList(),
//  );
//}
//
//Widget buildListItem(BuildContext context, DocumentSnapshot data) {
//  final user = User.fromSnapshot(data);
//  return Padding(
//    key: ValueKey(user.name),
//    padding: EdgeInsets.symmetric(vertical: 8.0),
//    child: Container(
//      decoration: BoxDecoration(
//          border: Border.all(color: Colors.grey),
//          borderRadius: BorderRadius.circular(5.0)),
//      child: ListTile(
//        title: Text(user.name),
//        trailing: IconButton(
//          icon: Icon(Icons.delete),
//          onPressed: () {
//            _api.delete(user);
//          },
//        ),
//        onTap: () {
//          setUpdateUI(user);
//        },
//      ),
//    ),
//  );
//}