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
      this.reservationReasonCancelStatus});

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
    return data;
  }
}
