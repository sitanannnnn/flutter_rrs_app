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
  String? tableResId;
  String? numberOfGueste;
  String? reservationDate;
  String? reservationTime;
  String? reservationStatus;

  DetailorderfoodModel(
      {this.id,
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
      this.tableResId,
      this.numberOfGueste,
      this.reservationDate,
      this.reservationTime,
      this.reservationStatus});

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
    tableResId = json['tableResId'];
    numberOfGueste = json['numberOfGueste'];
    reservationDate = json['reservationDate'];
    reservationTime = json['reservationTime'];
    reservationStatus = json['reservationStatus'];
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
    data['tableResId'] = this.tableResId;
    data['numberOfGueste'] = this.numberOfGueste;
    data['reservationDate'] = this.reservationDate;
    data['reservationTime'] = this.reservationTime;
    data['reservationStatus'] = this.reservationStatus;
    return data;
  }
}
