class ReviewModel {
  String? reviewId;
  String? restaurantId;
  String? restaurantNameshop;
  String? customerId;
  String? reservationId;
  String? orderfoodId;
  String? rate;
  String? opinion;
  String? review_date_time;
  String? chooseType;
  String? name;
  String? user;
  String? email;
  String? phonenumber;
  String? password;
  String? confirmpassword;
  String? urlPicture;

  ReviewModel(
      {this.reviewId,
      this.restaurantId,
      this.restaurantNameshop,
      this.customerId,
      this.reservationId,
      this.orderfoodId,
      this.rate,
      this.opinion,
      this.review_date_time,
      this.chooseType,
      this.name,
      this.user,
      this.email,
      this.phonenumber,
      this.password,
      this.confirmpassword,
      this.urlPicture});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    restaurantId = json['restaurantId'];
    restaurantNameshop = json['restaurantNameshop'];
    customerId = json['customerId'];
    reservationId = json['reservationId'];
    orderfoodId = json['orderfoodId'];
    rate = json['rate'];
    opinion = json['opinion'];
    review_date_time = json['review_date_time'];
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
    data['reviewId'] = this.reviewId;
    data['restaurantId'] = this.restaurantId;
    data['restaurantNameshop'] = this.restaurantNameshop;
    data['customerId'] = this.customerId;
    data['reservationId'] = this.reservationId;
    data['orderfoodId'] = this.orderfoodId;
    data['rate'] = this.rate;
    data['opinion'] = this.opinion;
    data['review_date_time'] = this.review_date_time;
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
