
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/user_model.dart';

class FirestoreService {

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');

  Future<dynamic> createProfile({ UserModel userModel }) async{
    try {
      return await userCollection.doc(userModel.uID).set(userModel.toMap());
    } catch(error){
      if(!AppConfig.isPublished){
        return error;
      }
    }
  }

  Future<dynamic> getUserData({ @required String uID }) async{
    try{
      dynamic result;
      await userCollection.doc(uID).get().then((document){
        if(document.data().isNotEmpty){
          result = UserModel(
            uID:          uID,
            firstName:    document.data()['first_name'],
            lastName:     document.data()['last_name'],
            email:        document.data()['email'],
            tel:          document.data()['tel'],
            mobile:       document.data()['mobile'],
            address:      document.data()['address'],
            platform:     document.data()['platform'],
            registererID: document.data()['registerer_id'],
            regCode:      document.data()['reg_code'],
            createdAt:    document.data()['created_at'],
            imageURL:     document.data()['image_url'],
            roleID:       document.data()['role_id'],
            tags:         document.data()['tags'],
            status:       document.data()['status'],
            verified:     document.data()['verified'],
            hasPassword:  document.data()['has_password']
          );
        }
      });
      return result;
    }catch(error){
      if(!AppConfig.isPublished){
        return error;
      }
    }
  }

  Future<dynamic> updateVerified({ @required String uID }) async{
    try{
      await userCollection.doc(uID).update({
        'verified' : true
      });
      return true;
    }catch(error){
      if(!AppConfig.isPublished){
        return error;
      }
    }
  }

  Future<dynamic> getCompanies({ String uID }) async{
    try{
      dynamic result;
      await userCollection
          .where("role_id", isEqualTo: AppConfig.employerUserRole)
          .where("registerer_id", isEqualTo: uID)
          .where("status", isEqualTo: true)
          .orderBy("created_at", descending: true)
          .get()
          .then((querySnapshot){
              if(querySnapshot.docs.isNotEmpty){
                result = querySnapshot.docs;
              }
            }
          );
      return result;
    }catch(error){
      if(!AppConfig.isPublished){
        return error;
      }
    }
  }
}