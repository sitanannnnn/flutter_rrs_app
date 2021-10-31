class DetailorderfoodModel {
  String? id;
  String? customerId;
  String? restaurantId;
  String? restaurantNameshop;
  String? foodmenuId;
  String? foodmenuName;
  String? foodmenuPrice;
  String? amount;
  String? netPrice;
  String? orderfoodDateTime;
  String? reservationId;
  String? orderfoodStatus;
  String? promotionId;
  String? promotionType;
  String? promotionDiscount;
  String? vat;
  String? rate_thb;
  String? rate_usd;
  String? rate_eur;

  DetailorderfoodModel({
    this.id,
    this.customerId,
    this.restaurantId,
    this.restaurantNameshop,
    this.foodmenuId,
    this.foodmenuName,
    this.foodmenuPrice,
    this.amount,
    this.netPrice,
    this.orderfoodDateTime,
    this.reservationId,
    this.orderfoodStatus,
    this.promotionId,
    this.promotionType,
    this.promotionDiscount,
    this.vat,
    this.rate_thb,
    this.rate_usd,
    this.rate_eur,
  });

  DetailorderfoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    restaurantId = json['restaurantId'];
    restaurantNameshop = json['restaurantNameshop'];
    foodmenuId = json['foodmenuId'];
    foodmenuName = json['foodmenuName'];
    foodmenuPrice = json['foodmenuPrice'];
    amount = json['amount'];
    netPrice = json['netPrice'];
    orderfoodDateTime = json['orderfoodDateTime'];
    reservationId = json['reservationId'];
    orderfoodStatus = json['orderfoodStatus'];
    promotionId = json['promotionId'];
    promotionType = json['promotion_type'];
    promotionDiscount = json['promotion_discount'];
    vat = json['vat'];
    rate_thb = json['rate_thb'];
    rate_usd = json['rate_usd'];
    rate_eur = json['rate_eur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['restaurantId'] = this.restaurantId;
    data['restaurantNameshop'] = this.restaurantNameshop;
    data['foodmenuId'] = this.foodmenuId;
    data['foodmenuName'] = this.foodmenuName;
    data['foodmenuPrice'] = this.foodmenuPrice;
    data['amount'] = this.amount;
    data['netPrice'] = this.netPrice;
    data['orderfoodDateTime'] = this.orderfoodDateTime;
    data['reservationId'] = this.reservationId;
    data['orderfoodStatus'] = this.orderfoodStatus;
    data['promotionId'] = this.promotionId;
    data['promotion_type'] = this.promotionType;
    data['promotion_discount'] = this.promotionDiscount;
    data['vat'] = this.vat;
    data['rate_thb'] = this.rate_thb;
    data['rate_usd'] = this.rate_usd;
    data['rate_eur'] = this.rate_eur;
    return data;
  }
}
