
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class InternsViewModel extends ChangeNotifier{

  List<UserModel> _internList = [];
  List<UserModel> get internList => this._internList;

  Future<dynamic> fetchData({ bool refresh, String uID }) async {

    try{
      final result =  await FirestoreService().getInternsByCompanyID(uID: uID);

      if(refresh != null && refresh){
        this._internList.clear();
      }

      this._internList = result.map<UserModel>((model) => UserModel.fromJson(model.id, model.data())).toList();

      notifyListeners();
      return true;
    }catch(error){
      print('error: $error');
      return error.toString();
    }
  }

  bool removeFromList({ UserModel model }){
    try{
      _internList.remove(model);
      notifyListeners();
      return true;
    }catch(error){
      if(!AppConfig.isPublished){
        print('Error: $error');
      }
      return false;
    }
  }
}