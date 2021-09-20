class PaymentModel {
  String? paymentmethodId;
  String? restaurantId;
  String? accountNumber;
  String? accountName;
  String? bankCategoriesId;
  String? nameBank;
  String? accountPicture;

  PaymentModel(
      {this.paymentmethodId,
      this.restaurantId,
      this.accountNumber,
      this.accountName,
      this.bankCategoriesId,
      this.nameBank,
      this.accountPicture});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    paymentmethodId = json['paymentmethodId'];
    restaurantId = json['restaurantId'];
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    bankCategoriesId = json['bank_categories_id'];
    nameBank = json['nameBank'];
    accountPicture = json['accountPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentmethodId'] = this.paymentmethodId;
    data['restaurantId'] = this.restaurantId;
    data['accountNumber'] = this.accountNumber;
    data['accountName'] = this.accountName;
    data['bank_categories_id'] = this.bankCategoriesId;
    data['nameBank'] = this.nameBank;
    data['accountPicture'] = this.accountPicture;
    return data;
  }
}
