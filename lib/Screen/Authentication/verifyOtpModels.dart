class VerifyOtpModels{
  bool? success;
  String? message;
  Data? data;

  VerifyOtpModels({this.success, this.message, this.data});

  VerifyOtpModels.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  User? user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? userType;
  String? hubId;
  Null? hub;
  Null? merchant;
  Null? merchantTotalParcel;
  Null? merchantTotalCashAmount;
  Null? merchantCurrentPayable;
  Null? joiningDate;
  Null? address;
  String? salary;
  String? status;
  String? statusName;
  String? image;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.userType,
        this.hubId,
        this.hub,
        this.merchant,
        this.merchantTotalParcel,
        this.merchantTotalCashAmount,
        this.merchantCurrentPayable,
        this.joiningDate,
        this.address,
        this.salary,
        this.status,
        this.statusName,
        this.image,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    userType = json['user_type'];
    hubId = json['hub_id'];
    hub = json['hub'];
    merchant = json['merchant'];
    merchantTotalParcel = json['merchant_total_parcel'];
    merchantTotalCashAmount = json['merchant_total_cash_amount'];
    merchantCurrentPayable = json['merchant_current_payable'];
    joiningDate = json['joining_date'];
    address = json['address'];
    salary = json['salary'];
    status = json['status'];
    statusName = json['statusName'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['user_type'] = this.userType;
    data['hub_id'] = this.hubId;
    data['hub'] = this.hub;
    data['merchant'] = this.merchant;
    data['merchant_total_parcel'] = this.merchantTotalParcel;
    data['merchant_total_cash_amount'] = this.merchantTotalCashAmount;
    data['merchant_current_payable'] = this.merchantCurrentPayable;
    data['joining_date'] = this.joiningDate;
    data['address'] = this.address;
    data['salary'] = this.salary;
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}