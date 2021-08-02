class TableModel {
  String? tableId;
  String? tableResId;
  String? restaurantId;
  String? tableName;
  String? tableNumseat;
  String? tableDescrip;
  String? tablePicture;

  TableModel(
      {this.tableId,
      this.tableResId,
      this.restaurantId,
      this.tableName,
      this.tableNumseat,
      this.tableDescrip,
      this.tablePicture});

  TableModel.fromJson(Map<String, dynamic> json) {
    tableId = json['tableId'];
    tableResId = json['tableResId'];
    restaurantId = json['restaurantId'];
    tableName = json['tableName'];
    tableNumseat = json['tableNumseat'];
    tableDescrip = json['tableDescrip'];
    tablePicture = json['tablePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableId'] = this.tableId;
    data['tableResId'] = this.tableResId;
    data['restaurantId'] = this.restaurantId;
    data['tableName'] = this.tableName;
    data['tableNumseat'] = this.tableNumseat;
    data['tableDescrip'] = this.tableDescrip;
    data['tablePicture'] = this.tablePicture;
    return data;
  }
}
