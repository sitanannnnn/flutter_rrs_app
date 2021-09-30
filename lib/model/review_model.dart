class ReviewModel {
  String? reviewId;
  String? restaurantId;
  String? restaurantNameshop;
  String? customerId;
  String? reservationId;
  String? orderfoodId;
  String? rate;
  String? opinion;

  ReviewModel(
      {this.reviewId,
      this.restaurantId,
      this.restaurantNameshop,
      this.customerId,
      this.reservationId,
      this.orderfoodId,
      this.rate,
      this.opinion});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    restaurantId = json['restaurantId'];
    restaurantNameshop = json['restaurantNameshop'];
    customerId = json['customerId'];
    reservationId = json['reservationId'];
    orderfoodId = json['orderfoodId'];
    rate = json['rate'];
    opinion = json['opinion'];
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
    return data;
  }
}
