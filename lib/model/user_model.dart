class UserModel {
  String? customerId;
  String? chooseType;
  String? name;
  String? user;
  String? email;
  String? phonenumber;
  String? password;
  String? confirmpassword;
  String? urlPicture;

  UserModel(
      {this.customerId,
      this.chooseType,
      this.name,
      this.user,
      this.email,
      this.phonenumber,
      this.password,
      this.confirmpassword,
      this.urlPicture});

  UserModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    chooseType = json['chooseType'];
    name = json['name'];
    user = json['user'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    password = json['password'];
    confirmpassword = json['confirmpassword'];
    urlPicture = json['urlPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['chooseType'] = this.chooseType;
    data['name'] = this.name;
    data['user'] = this.user;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['password'] = this.password;
    data['confirmpassword'] = this.confirmpassword;
    data['urlPicture'] = this.urlPicture;
    return data;
  }
}
