import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/User.dart';

class UserService{
  final String collectionName = 'users';
  getUsers(){
    return Firestore.instance.collection(collectionName).snapshots();
  }

  addUser(String newName){
    User user =  User(name: newName);
    try{
      Firestore.instance.runTransaction(
          (Transaction transection) async{
            await Firestore.instance
                .collection(collectionName)
                .document()
                .setData(user.toJson());
          },
      );
    }catch (e){
      print(e.toString());
    }
  }

  update(User user, String newName){
    try{
      Firestore.instance.runTransaction((transection) async {
        await transection.update(user.reference, {'name':newName});
      });
    }catch (e){
      print(e.toString());
    }
  }

  delete(User user){
    Firestore.instance.runTransaction(
        (Transaction transection) async {
          await transection.delete(user.reference);
        },
    );
  }


}