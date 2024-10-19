import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karya_manager/models/user.dart';
import 'package:karya_manager/utils/util.dart';

class Userservice{

CollectionReference users=FirebaseFirestore.instance.collection("users");

 Future<AppUser?> getUserFromDatabase(String uid) async {
    DocumentSnapshot doc = await users.doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data() as Map<String, dynamic>);
    } 
    return null; // User not found
  }

addUserToDatabase(AppUser user, String uid) {
  final document = users.doc(uid);
  Util.uid = uid;
  document.set(user.toMap()).then((_) {
    print("User added to Firestore: $uid");
  }).catchError((error) {
    print("Error adding user: $error");
  });
}





}