import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karya_manager/models/user.dart';
import 'package:karya_manager/utils/util.dart';

class Userservice{

CollectionReference users=FirebaseFirestore.instance.collection("users");

addUserToDatabase(AppUser user , String uid){
  final document=users.doc(uid);
  Util.uid= uid;
  document.set(user.toMap());
  }




}