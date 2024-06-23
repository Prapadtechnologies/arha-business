class DistanceChargesModel {
  bool? success;
  String? message;
  Data? data;

  DistanceChargesModel({this.success, this.message, this.data});

  DistanceChargesModel.fromJson(Map<String, dynamic> json) {
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
  DistanceCharges? distanceCharges;

  Data({this.distanceCharges});

  Data.fromJson(Map<String, dynamic> json) {
    distanceCharges = json['distanceCharges'] != null
        ? new DistanceCharges.fromJson(json['distanceCharges'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distanceCharges != null) {
      data['distanceCharges'] = this.distanceCharges!.toJson();
    }
    return data;
  }
}

class DistanceCharges {
  int? id;
  int? weightId;
  String? fromDistance;
  String? toDistance;
  String? deliveryAmount;
  int? userType;
  int? position;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? distanceAmount;
  String? vat;
  String? vatAmount;
  String? distanceTotal;
  String? packingCharges;
  String? razorpayKey;
  String? razorpaySecret;

  DistanceCharges(
      {this.id,
        this.weightId,
        this.fromDistance,
        this.toDistance,
        this.deliveryAmount,
        this.userType,
        this.position,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.distanceAmount,
        this.vat,
        this.vatAmount,
        this.distanceTotal,
        this.packingCharges,
        this.razorpayKey,
        this.razorpaySecret});

  DistanceCharges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weightId = json['weight_id'];
    fromDistance = json['from_distance'];
    toDistance = json['to_distance'];
    deliveryAmount = json['delivery_amount'];
    userType = json['user_type'];
    position = json['position'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distanceAmount = json['distance_amount'];
    vat = json['vat'];
    vatAmount = json['vat_amount'];
    distanceTotal = json['distance_total'];
    packingCharges = json['packing_charges'];
    razorpayKey = json['razorpay_key'];
    razorpaySecret = json['razorpay_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weight_id'] = this.weightId;
    data['from_distance'] = this.fromDistance;
    data['to_distance'] = this.toDistance;
    data['delivery_amount'] = this.deliveryAmount;
    data['user_type'] = this.userType;
    data['position'] = this.position;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance_amount'] = this.distanceAmount;
    data['vat'] = this.vat;
    data['vat_amount'] = this.vatAmount;
    data['distance_total'] = this.distanceTotal;
    data['packing_charges'] = this.packingCharges;
    data['razorpay_key'] = this.razorpayKey;
    data['razorpay_secret'] = this.razorpaySecret;
    return data;
  }
}