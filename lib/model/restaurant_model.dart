class RestaurantModel {
  String? restaurantId;
  String? picture;
  String? nameowner;
  String? identification;
  String? nameshop;
  String? branch;
  String? category;
  String? phonenumber;
  String? address;
  String? openingdate;
  String? openingtime;

  RestaurantModel(
      {this.restaurantId,
      this.picture,
      this.nameowner,
      this.identification,
      this.nameshop,
      this.branch,
      this.category,
      this.phonenumber,
      this.address,
      this.openingdate,
      this.openingtime});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    picture = json['picture'];
    nameowner = json['nameowner'];
    identification = json['identification'];
    nameshop = json['nameshop'];
    branch = json['branch'];
    category = json['category'];
    phonenumber = json['phonenumber'];
    address = json['address'];
    openingdate = json['openingdate'];
    openingtime = json['openingtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['picture'] = this.picture;
    data['nameowner'] = this.nameowner;
    data['identification'] = this.identification;
    data['nameshop'] = this.nameshop;
    data['branch'] = this.branch;
    data['category'] = this.category;
    data['phonenumber'] = this.phonenumber;
    data['address'] = this.address;
    data['openingdate'] = this.openingdate;
    data['openingtime'] = this.openingtime;
    return data;
  }
}
