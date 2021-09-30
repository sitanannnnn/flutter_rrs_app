class DetailReservationModel {
  String? reservationId;
  String? customerId;
  String? restaurantId;
  String? tableResId;
  String? restaurantNameshop;
  String? numberOfGueste;
  String? reservationDate;
  String? reservationTime;
  String? orderfoodId;
  String? reservationStatus;
  String? reservationReasonCancelStatus;
  String? promotionId;
  String? promotionType;
  String? reservationDateTime;
  String? tableId;
  String? tableName;
  String? tableNumseat;
  String? tableDescrip;
  String? tablePicture;
  String? tableStatus;

  DetailReservationModel(
      {this.reservationId,
      this.customerId,
      this.restaurantId,
      this.tableResId,
      this.restaurantNameshop,
      this.numberOfGueste,
      this.reservationDate,
      this.reservationTime,
      this.orderfoodId,
      this.reservationStatus,
      this.reservationReasonCancelStatus,
      this.promotionId,
      this.promotionType,
      this.reservationDateTime,
      this.tableId,
      this.tableName,
      this.tableNumseat,
      this.tableDescrip,
      this.tablePicture,
      this.tableStatus});

  DetailReservationModel.fromJson(Map<String, dynamic> json) {
    reservationId = json['reservationId'];
    customerId = json['customerId'];
    restaurantId = json['restaurantId'];
    tableResId = json['tableResId'];
    restaurantNameshop = json['restaurantNameshop'];
    numberOfGueste = json['numberOfGueste'];
    reservationDate = json['reservationDate'];
    reservationTime = json['reservationTime'];
    orderfoodId = json['orderfoodId'];
    reservationStatus = json['reservationStatus'];
    reservationReasonCancelStatus = json['reservationReasonCancelStatus'];
    promotionId = json['promotionId'];
    promotionType = json['promotionType'];
    reservationDateTime = json['reservationDateTime'];
    tableId = json['tableId'];
    tableName = json['tableName'];
    tableNumseat = json['tableNumseat'];
    tableDescrip = json['tableDescrip'];
    tablePicture = json['tablePicture'];
    tableStatus = json['tableStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reservationId'] = this.reservationId;
    data['customerId'] = this.customerId;
    data['restaurantId'] = this.restaurantId;
    data['tableResId'] = this.tableResId;
    data['restaurantNameshop'] = this.restaurantNameshop;
    data['numberOfGueste'] = this.numberOfGueste;
    data['reservationDate'] = this.reservationDate;
    data['reservationTime'] = this.reservationTime;
    data['orderfoodId'] = this.orderfoodId;
    data['reservationStatus'] = this.reservationStatus;
    data['reservationReasonCancelStatus'] = this.reservationReasonCancelStatus;
    data['promotionId'] = this.promotionId;
    data['promotionType'] = this.promotionType;
    data['reservationDateTime'] = this.reservationDateTime;
    data['tableId'] = this.tableId;
    data['tableName'] = this.tableName;
    data['tableNumseat'] = this.tableNumseat;
    data['tableDescrip'] = this.tableDescrip;
    data['tablePicture'] = this.tablePicture;
    data['tableStatus'] = this.tableStatus;
    return data;
  }
}
