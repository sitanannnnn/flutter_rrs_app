class PromotionModel {
  String? restaurantId;
  String? chooseType;
  String? name;
  String? user;
  String? email;
  String? phonenumber;
  String? password;
  String? confirmpassword;
  String? restaurantPicture;
  String? restaurantIdNumber;
  String? restaurantNameshop;
  String? restaurantBranch;
  String? restaurantAddress;
  String? typeOfFood;
  String? promotionId;
  String? promotionType;
  String? promotionStartDate;
  String? promotionStartTime;
  String? promotionFinishDate;
  String? promotionFinishTime;
  String? foodMenuIdDiscount;
  String? promotionDiscount;
  String? promotionOldPrice;
  String? promotionNewPrice;
  String? promotionBuyOne;
  String? foodMenuIdBuyOne;
  String? promotionGetOne;
  String? foodMenuIdGetOne;
  String? promotionStatus;

  PromotionModel(
      {this.restaurantId,
      this.chooseType,
      this.name,
      this.user,
      this.email,
      this.phonenumber,
      this.password,
      this.confirmpassword,
      this.restaurantPicture,
      this.restaurantIdNumber,
      this.restaurantNameshop,
      this.restaurantBranch,
      this.restaurantAddress,
      this.typeOfFood,
      this.promotionId,
      this.promotionType,
      this.promotionStartDate,
      this.promotionStartTime,
      this.promotionFinishDate,
      this.promotionFinishTime,
      this.foodMenuIdDiscount,
      this.promotionDiscount,
      this.promotionOldPrice,
      this.promotionNewPrice,
      this.promotionBuyOne,
      this.foodMenuIdBuyOne,
      this.promotionGetOne,
      this.foodMenuIdGetOne,
      this.promotionStatus});

  PromotionModel.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    chooseType = json['chooseType'];
    name = json['name'];
    user = json['user'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    password = json['password'];
    confirmpassword = json['confirmpassword'];
    restaurantPicture = json['restaurantPicture'];
    restaurantIdNumber = json['restaurantIdNumber'];
    restaurantNameshop = json['restaurantNameshop'];
    restaurantBranch = json['restaurantBranch'];
    restaurantAddress = json['restaurantAddress'];
    typeOfFood = json['typeOfFood'];
    promotionId = json['promotion_id'];
    promotionType = json['promotion_type'];
    promotionStartDate = json['promotion_start_date'];
    promotionStartTime = json['promotion_start_time'];
    promotionFinishDate = json['promotion_finish_date'];
    promotionFinishTime = json['promotion_finish_time'];
    foodMenuIdDiscount = json['foodMenuId_discount'];
    promotionDiscount = json['promotion_discount'];
    promotionOldPrice = json['promotion_old_price'];
    promotionNewPrice = json['promotion_new_price'];
    promotionBuyOne = json['promotion_buy_one'];
    foodMenuIdBuyOne = json['foodMenuId_buy_one'];
    promotionGetOne = json['promotion_get_one'];
    foodMenuIdGetOne = json['foodMenuId_get_one'];
    promotionStatus = json['promotion_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['chooseType'] = this.chooseType;
    data['name'] = this.name;
    data['user'] = this.user;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['password'] = this.password;
    data['confirmpassword'] = this.confirmpassword;
    data['restaurantPicture'] = this.restaurantPicture;
    data['restaurantIdNumber'] = this.restaurantIdNumber;
    data['restaurantNameshop'] = this.restaurantNameshop;
    data['restaurantBranch'] = this.restaurantBranch;
    data['restaurantAddress'] = this.restaurantAddress;
    data['typeOfFood'] = this.typeOfFood;
    data['promotion_id'] = this.promotionId;
    data['promotion_type'] = this.promotionType;
    data['promotion_start_date'] = this.promotionStartDate;
    data['promotion_start_time'] = this.promotionStartTime;
    data['promotion_finish_date'] = this.promotionFinishDate;
    data['promotion_finish_time'] = this.promotionFinishTime;
    data['foodMenuId_discount'] = this.foodMenuIdDiscount;
    data['promotion_discount'] = this.promotionDiscount;
    data['promotion_old_price'] = this.promotionOldPrice;
    data['promotion_new_price'] = this.promotionNewPrice;
    data['promotion_buy_one'] = this.promotionBuyOne;
    data['foodMenuId_buy_one'] = this.foodMenuIdBuyOne;
    data['promotion_get_one'] = this.promotionGetOne;
    data['foodMenuId_get_one'] = this.foodMenuIdGetOne;
    data['promotion_status'] = this.promotionStatus;
    return data;
  }
}
