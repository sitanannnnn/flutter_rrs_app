class PaymentModel {
  String? paymentmethodId;
  String? restaurantId;
  String? nameBank;
  String? accountNumber;
  String? accountName;
  String? accountPicture;

  PaymentModel(
      {this.paymentmethodId,
      this.restaurantId,
      this.nameBank,
      this.accountNumber,
      this.accountName,
      this.accountPicture});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    paymentmethodId = json['paymentmethodId'];
    restaurantId = json['restaurantId'];
    nameBank = json['nameBank'];
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    accountPicture = json['accountPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentmethodId'] = this.paymentmethodId;
    data['restaurantId'] = this.restaurantId;
    data['nameBank'] = this.nameBank;
    data['accountNumber'] = this.accountNumber;
    data['accountName'] = this.accountName;
    data['accountPicture'] = this.accountPicture;
    return data;
  }
}
