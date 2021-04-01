import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String                uID;
  String                firstName;
  String                lastName;
  String                email;
  String                tel;
  String                mobile;
  String                address;
  String                platform;
  String                registererID;
  String                regCode;
  Timestamp             createdAt;
  String                imageURL;
  double                roleID;
  List<dynamic>         tags;
  Map<String, dynamic>  checks;
  bool                  status;
  bool                  verified;
  bool                  hasPassword;

  UserModel({ this.uID, this.firstName, this.lastName, this.email, this.tel, this.mobile, this.address, this.platform, this.registererID,
              this.regCode, this.status, this.createdAt, this.imageURL, this.roleID, this.tags, this.checks, this.verified, this.hasPassword});

  Map<String, dynamic> toMap(){
    return{
      'first_name':       this.firstName,
      'last_name':        this.lastName,
      'email':            this.email,
      'tel':              this.tel,
      'mobile':           this.mobile,
      'address':          this.address,
      'platform':         this.platform,
      'registerer_id':    this.registererID,
      'reg_code':         this.regCode,
      'created_at':       this.createdAt,
      'image_url':        this.imageURL,
      'role_id':          this.roleID,
      'tags':             this.tags,
      'checks':           this.checks,
      'status':           this.status,
      'verified':         this.verified,
      'has_password':     this.hasPassword,
    };
  }

  @override
  String toString() {
    return 'UserModel(uID: $uID, firstName: $firstName, lastName: $lastName, email: $email, tel: $tel, mobile: $mobile, address: $address, platform: $platform, registererID: $registererID, regCode: $regCode, createdAt: $createdAt, imageURL: $imageURL, roleID: $roleID, tags: $tags, status: $status, verified: $verified, hasPassword: $hasPassword )';
  }

}