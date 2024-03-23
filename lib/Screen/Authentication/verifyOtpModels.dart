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
  Null? email;
  String? phone;
  String? userType;
  String? hubId;
  Hub? hub;
  Merchant? merchant;
  int? merchantTotalParcel;
  String? merchantTotalCashAmount;
  String? merchantCurrentPayable;
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
    hub = json['hub'] != null ? new Hub.fromJson(json['hub']) : null;
    merchant = json['merchant'] != null
        ? new Merchant.fromJson(json['merchant'])
        : null;
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
    if (this.hub != null) {
      data['hub'] = this.hub!.toJson();
    }
    if (this.merchant != null) {
      data['merchant'] = this.merchant!.toJson();
    }
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

class Hub {
  int? id;
  String? name;
  String? phone;
  String? address;
  String? hubLat;
  String? hubLong;
  Null? currentBalance;
  int? status;
  String? createdAt;
  String? updatedAt;

  Hub(
      {this.id,
        this.name,
        this.phone,
        this.address,
        this.hubLat,
        this.hubLong,
        this.currentBalance,
        this.status,
        this.createdAt,
        this.updatedAt});

  Hub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    hubLat = json['hub_lat'];
    hubLong = json['hub_long'];
    currentBalance = json['current_balance'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['hub_lat'] = this.hubLat;
    data['hub_long'] = this.hubLong;
    data['current_balance'] = this.currentBalance;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Merchant {
  int? id;
  int? userId;
  String? businessName;
  String? merchantUniqueId;
  String? currentBalance;
  String? openingBalance;
  String? walletBalance;
  String? vat;
  CodCharges? codCharges;
  Null? nidId;
  Null? tradeLicense;
  String? paymentPeriod;
  int? status;
  String? address;
  int? walletUseActivation;
  String? returnCharges;
  Null? referenceName;
  Null? referencePhone;
  String? createdAt;
  String? updatedAt;

  Merchant(
      {this.id,
        this.userId,
        this.businessName,
        this.merchantUniqueId,
        this.currentBalance,
        this.openingBalance,
        this.walletBalance,
        this.vat,
        this.codCharges,
        this.nidId,
        this.tradeLicense,
        this.paymentPeriod,
        this.status,
        this.address,
        this.walletUseActivation,
        this.returnCharges,
        this.referenceName,
        this.referencePhone,
        this.createdAt,
        this.updatedAt});

  Merchant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    businessName = json['business_name'];
    merchantUniqueId = json['merchant_unique_id'];
    currentBalance = json['current_balance'];
    openingBalance = json['opening_balance'];
    walletBalance = json['wallet_balance'];
    vat = json['vat'];
    codCharges = json['cod_charges'] != null
        ? new CodCharges.fromJson(json['cod_charges'])
        : null;
    nidId = json['nid_id'];
    tradeLicense = json['trade_license'];
    paymentPeriod = json['payment_period'];
    status = json['status'];
    address = json['address'];
    walletUseActivation = json['wallet_use_activation'];
    returnCharges = json['return_charges'];
    referenceName = json['reference_name'];
    referencePhone = json['reference_phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['business_name'] = this.businessName;
    data['merchant_unique_id'] = this.merchantUniqueId;
    data['current_balance'] = this.currentBalance;
    data['opening_balance'] = this.openingBalance;
    data['wallet_balance'] = this.walletBalance;
    data['vat'] = this.vat;
    if (this.codCharges != null) {
      data['cod_charges'] = this.codCharges!.toJson();
    }
    data['nid_id'] = this.nidId;
    data['trade_license'] = this.tradeLicense;
    data['payment_period'] = this.paymentPeriod;
    data['status'] = this.status;
    data['address'] = this.address;
    data['wallet_use_activation'] = this.walletUseActivation;
    data['return_charges'] = this.returnCharges;
    data['reference_name'] = this.referenceName;
    data['reference_phone'] = this.referencePhone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CodCharges {
  String? insideCity;
  String? subCity;
  String? outsideCity;

  CodCharges({this.insideCity, this.subCity, this.outsideCity});

  CodCharges.fromJson(Map<String, dynamic> json) {
    insideCity = json['inside_city'];
    subCity = json['sub_city'];
    outsideCity = json['outside_city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inside_city'] = this.insideCity;
    data['sub_city'] = this.subCity;
    data['outside_city'] = this.outsideCity;
    return data;
  }
}