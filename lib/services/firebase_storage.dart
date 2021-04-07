
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:path/path.dart' as Path;

class FirebaseStorage {

  final firebaseStorage.Reference storageRef = firebaseStorage.FirebaseStorage.instance.ref();

  Future<dynamic> uploadLogo({ String imagePath }) async{

    dynamic result;

    try {
      var logoRef = storageRef.child('logos/${Path.basename(imagePath)}');
      await logoRef.putFile(File(imagePath)).whenComplete(() async {
        await logoRef.getDownloadURL().then((value) => {
          if(value != null){
            result = value
          }
        });
      });
      return result;
    } catch(error){
      return error;
    }
  }
}