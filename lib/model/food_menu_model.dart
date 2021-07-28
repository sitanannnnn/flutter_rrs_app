class FoodMenuModel {
  String? foodmenuId;
  String? restaurantId;
  String? foodmenuName;
  String? foodmenuPrice;
  String? foodmenuPicture;
  String? foodmenuDescrip;

  FoodMenuModel(
      {this.foodmenuId,
      this.restaurantId,
      this.foodmenuName,
      this.foodmenuPrice,
      this.foodmenuPicture,
      this.foodmenuDescrip});

  FoodMenuModel.fromJson(Map<String, dynamic> json) {
    foodmenuId = json['foodmenuId'];
    restaurantId = json['restaurantId'];
    foodmenuName = json['foodmenuName'];
    foodmenuPrice = json['foodmenuPrice'];
    foodmenuPicture = json['foodmenuPicture'];
    foodmenuDescrip = json['foodmenuDescrip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodmenuId'] = this.foodmenuId;
    data['restaurantId'] = this.restaurantId;
    data['foodmenuName'] = this.foodmenuName;
    data['foodmenuPrice'] = this.foodmenuPrice;
    data['foodmenuPicture'] = this.foodmenuPicture;
    data['foodmenuDescrip'] = this.foodmenuDescrip;
    return data;
  }
}
