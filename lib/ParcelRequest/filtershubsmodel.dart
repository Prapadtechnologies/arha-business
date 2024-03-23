
import '../Models/account_transaction_model.dart';

class FiltersHubsModel {
  bool? success;
  String? message;
  Data? data;

  FiltersHubsModel({this.success, this.message, this.data});

  FiltersHubsModel.fromJson(dynamic json) {
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
  List<HubInc>? hubInc;
  Data({List<HubInc>? hubIncs,}){
    _HubInc = hubIncs;
  }

 // Data({this.hubInc});

  Data.fromJson(dynamic json) {
    if (json['hub_inc'] != null) {
      hubInc = <HubInc>[];
      json['hub_inc'].forEach((v) {
        hubInc!.add(new HubInc.fromJson(v));
      });
    }
  }

  List<HubInc>? _HubInc;

  List<HubInc>? get hubparcels => _HubInc;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hubInc != null) {
      data['hub_inc'] = this.hubInc!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HubInc {
  int? id;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  String? mobile;
  String? nidNumber;
  int? designationId;
  int? departmentId;
  int? hubId;
  int? userType;
  int? imageId;
  String? joiningDate;
  String? address;
  int? roleId;
  List<String>? permissions;
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

  HubInc(
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
        this.permissions,
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

  HubInc.fromJson( dynamic json) {
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
    permissions = json['permissions'].cast<String>();
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
    data['permissions'] = this.permissions;
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