class FoodmenuPromotionModel {
  String? foodmenuId;
  String? restaurantId;
  String? foodmenuName;
  String? foodmenuPrice;
  String? foodmenuPicture;
  String? foodmenuDescrip;
  String? promotionId;
  String? restaurantNameshop;
  String? promotionType;
  String? promotionStartDate;
  String? promotionStartTime;
  String? promotionFinishDate;
  String? promotionFinishTime;
  String? foodMenuIdDiscount;
  String? promotionDiscount;
  String? promotionOldPrice;
  String? promotionNewPrice;
  String? foodMenuIdBuyOne;
  String? foodMenuIdGetOne;
  String? promotionStatus;

  FoodmenuPromotionModel(
      {this.foodmenuId,
      this.restaurantId,
      this.foodmenuName,
      this.foodmenuPrice,
      this.foodmenuPicture,
      this.foodmenuDescrip,
      this.promotionId,
      this.restaurantNameshop,
      this.promotionType,
      this.promotionStartDate,
      this.promotionStartTime,
      this.promotionFinishDate,
      this.promotionFinishTime,
      this.foodMenuIdDiscount,
      this.promotionDiscount,
      this.promotionOldPrice,
      this.promotionNewPrice,
      this.foodMenuIdBuyOne,
      this.foodMenuIdGetOne,
      this.promotionStatus});

  FoodmenuPromotionModel.fromJson(Map<String, dynamic> json) {
    foodmenuId = json['foodmenuId'];
    restaurantId = json['restaurantId'];
    foodmenuName = json['foodmenuName'];
    foodmenuPrice = json['foodmenuPrice'];
    foodmenuPicture = json['foodmenuPicture'];
    foodmenuDescrip = json['foodmenuDescrip'];
    promotionId = json['promotionId'];
    restaurantNameshop = json['restaurantNameshop'];
    promotionType = json['promotion_type'];
    promotionStartDate = json['promotion_start_date'];
    promotionStartTime = json['promotion_start_time'];
    promotionFinishDate = json['promotion_finish_date'];
    promotionFinishTime = json['promotion_finish_time'];
    foodMenuIdDiscount = json['foodMenuId_discount'];
    promotionDiscount = json['promotion_discount'];
    promotionOldPrice = json['promotion_old_price'];
    promotionNewPrice = json['promotion_new_price'];
    foodMenuIdBuyOne = json['foodMenuId_buy_one'];
    foodMenuIdGetOne = json['foodMenuId_get_one'];
    promotionStatus = json['promotion_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodmenuId'] = this.foodmenuId;
    data['restaurantId'] = this.restaurantId;
    data['foodmenuName'] = this.foodmenuName;
    data['foodmenuPrice'] = this.foodmenuPrice;
    data['foodmenuPicture'] = this.foodmenuPicture;
    data['foodmenuDescrip'] = this.foodmenuDescrip;
    data['promotionId'] = this.promotionId;
    data['restaurantNameshop'] = this.restaurantNameshop;
    data['promotion_type'] = this.promotionType;
    data['promotion_start_date'] = this.promotionStartDate;
    data['promotion_start_time'] = this.promotionStartTime;
    data['promotion_finish_date'] = this.promotionFinishDate;
    data['promotion_finish_time'] = this.promotionFinishTime;
    data['foodMenuId_discount'] = this.foodMenuIdDiscount;
    data['promotion_discount'] = this.promotionDiscount;
    data['promotion_old_price'] = this.promotionOldPrice;
    data['promotion_new_price'] = this.promotionNewPrice;
    data['foodMenuId_buy_one'] = this.foodMenuIdBuyOne;
    data['foodMenuId_get_one'] = this.foodMenuIdGetOne;
    data['promotion_status'] = this.promotionStatus;
    return data;
  }
}
