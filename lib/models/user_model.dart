class UserModel{
  String    uID;
  String    firstName;
  String    lastName;
  String    email;
  String    tel;
  String    mobile;
  String    platform;
  DateTime  createdAt;
  String    imageURL;
  double    roleID;
  String    tags;
  bool      status;
  bool      verified;

  UserModel({ this.uID, this.firstName, this.lastName, this.email, this.tel, this.mobile, this.platform, this.status,
              this.createdAt, this.imageURL, this.roleID, this.tags, this.verified});

  @override
  String toString() {
    return 'UserModel(uID: $uID, firstName: $firstName, lastName: $lastName, email: $email, tel: $tel, mobile: $mobile, platform: $platform, createdAt: $createdAt, imageURL: $imageURL, roleID: $roleID, tags: $tags, status: $status, verified: $verified )';
  }

}