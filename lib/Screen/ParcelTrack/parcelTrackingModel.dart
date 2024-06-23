class ParcelTrackingModel {
  bool? success;
  String? message;
  Data? data;

  ParcelTrackingModel({this.success, this.message, this.data});

  ParcelTrackingModel.fromJson(Map<String, dynamic> json) {
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
  List<Events>? events;
  Data({this.events});
  Data.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int? id;
  int? parcelId;
  Null? deliveryManId;
  Null? pickupManId;
  int? hubId;
  Null? transferDeliveryManId;
  String? note;
  int? parcelStatus;
  Null? deliveryLat;
  Null? deliveryLong;
  Null? signatureImage;
  Null? deliveredImage;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  Null? deliveryMan;
  Null? pickupman;
  Null? transferDeliveryman;
  Hub? hub;
  User? user;

  Events({this.id,
        this.parcelId,
        this.deliveryManId,
        this.pickupManId,
        this.hubId,
        this.transferDeliveryManId,
        this.note,
        this.parcelStatus,
        this.deliveryLat,
        this.deliveryLong,
        this.signatureImage,
        this.deliveredImage,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.deliveryMan,
        this.pickupman,
        this.transferDeliveryman,
        this.hub,
        this.user});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parcelId = json['parcel_id'];
    deliveryManId = json['delivery_man_id'];
    pickupManId = json['pickup_man_id'];
    hubId = json['hub_id'];
    transferDeliveryManId = json['transfer_delivery_man_id'];
    note = json['note'];
    parcelStatus = json['parcel_status'];
    deliveryLat = json['delivery_lat'];
    deliveryLong = json['delivery_long'];
    signatureImage = json['signature_image'];
    deliveredImage = json['delivered_image'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryMan = json['delivery_man'];
    pickupman = json['pickupman'];
    transferDeliveryman = json['transfer_deliveryman'];
    hub = json['hub'] != null ? new Hub.fromJson(json['hub']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parcel_id'] = this.parcelId;
    data['delivery_man_id'] = this.deliveryManId;
    data['pickup_man_id'] = this.pickupManId;
    data['hub_id'] = this.hubId;
    data['transfer_delivery_man_id'] = this.transferDeliveryManId;
    data['note'] = this.note;
    data['parcel_status'] = this.parcelStatus;
    data['delivery_lat'] = this.deliveryLat;
    data['delivery_long'] = this.deliveryLong;
    data['signature_image'] = this.signatureImage;
    data['delivered_image'] = this.deliveredImage;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_man'] = this.deliveryMan;
    data['pickupman'] = this.pickupman;
    data['transfer_deliveryman'] = this.transferDeliveryman;
    if (this.hub != null) {
      data['hub'] = this.hub!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Hub {
  int? id;
  String? branchId;
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
        this.branchId,
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
    branchId = json['branch_id'];
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
    data['branch_id'] = this.branchId;
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

class User {
  int? id;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  String? mobile;
  String? nidNumber;
  Null? designationId;
  Null? departmentId;
  int? hubId;
  int? userType;
  int? imageId;
  String? joiningDate;
  String? address;
  int? roleId;
  int? otp;
  String? salary;
  Null? deviceToken;
  Null? webToken;
  int? status;
  int? verificationStatus;
  Null? googleId;
  Null? facebookId;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.mobile,
        this.nidNumber,
        this.designationId,
        this.departmentId,
        this.hubId,
        this.userType,
        this.imageId,
        this.joiningDate,
        this.address,
        this.roleId,
        this.otp,
        this.salary,
        this.deviceToken,
        this.webToken,
        this.status,
        this.verificationStatus,
        this.googleId,
        this.facebookId,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    mobile = json['mobile'];
    nidNumber = json['nid_number'];
    designationId = json['designation_id'];
    departmentId = json['department_id'];
    hubId = json['hub_id'];
    userType = json['user_type'];
    imageId = json['image_id'];
    joiningDate = json['joining_date'];
    address = json['address'];
    roleId = json['role_id'];
    otp = json['otp'];
    salary = json['salary'];
    deviceToken = json['device_token'];
    webToken = json['web_token'];
    status = json['status'];
    verificationStatus = json['verification_status'];
    googleId = json['google_id'];
    facebookId = json['facebook_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['mobile'] = this.mobile;
    data['nid_number'] = this.nidNumber;
    data['designation_id'] = this.designationId;
    data['department_id'] = this.departmentId;
    data['hub_id'] = this.hubId;
    data['user_type'] = this.userType;
    data['image_id'] = this.imageId;
    data['joining_date'] = this.joiningDate;
    data['address'] = this.address;
    data['role_id'] = this.roleId;
    data['otp'] = this.otp;
    data['salary'] = this.salary;
    data['device_token'] = this.deviceToken;
    data['web_token'] = this.webToken;
    data['status'] = this.status;
    data['verification_status'] = this.verificationStatus;
    data['google_id'] = this.googleId;
    data['facebook_id'] = this.facebookId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}