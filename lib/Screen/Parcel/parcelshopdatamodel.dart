class ParcelShopDataModel{
  bool? success;
  String? message;
  Data? data;

  ParcelShopDataModel({this.success, this.message, this.data});

  ParcelShopDataModel.fromJson(Map<String, dynamic> json) {
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
  ParcelLogInvoice? parcelLogInvoice;
  List<Null>? parcelEvents;

  Data({this.parcelLogInvoice, this.parcelEvents});

  Data.fromJson(Map<String, dynamic> json) {
    parcelLogInvoice = json['parcel_log_invoice'] != null
        ? new ParcelLogInvoice.fromJson(json['parcel_log_invoice'])
        : null;
    /*if (json['parcelEvents'] != null) {
      parcelEvents = <Null>[];
      json['parcelEvents'].forEach((v) {
        parcelEvents!.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parcelLogInvoice != null) {
      data['parcel_log_invoice'] = this.parcelLogInvoice!.toJson();
    }
    /*if (this.parcelEvents != null) {
      data['parcelEvents'] = this.parcelEvents!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class ParcelLogInvoice {
  int? id;
  String? trackingId;
  int? userId;
  String? userName;
  String? userEmail;
  String? mobile;
  String? pickupPhone;
  String? pickupAddress;
  String? pickupLat;
  String? pickupLong;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? customerLat;
  String? customerLong;
  String? invoiceNo;
  String? totalDeliveryAmount;
  String? codAmount;
  int? vat;
  String? vatAmount;
  String? currentPayable;
  String? cashCollection;
  int? deliveryTypeId;
  String? deliveryType;
  int? status;
  String? weight;
  String? distance;
  String? gstNumber;
  String? gstType;
  String? customerFullAddress;
  int? pinCode;
  int? quantity;
 // Null? distanceTotal;
  String? deliveryCharge;
  String? distanceAmount;
  String? packagingAmount;
  String? note;
  int? distanceId;
  String? statusName;
  String? pickupDate;
  String? deliveryDate;
  String? createdAt;
  String? updatedAt;
  String? parcelDate;
  String? parcelTime;

  ParcelLogInvoice(
      {this.id,
        this.trackingId,
        this.userId,
        this.userName,
        this.userEmail,
        this.mobile,
        this.pickupPhone,
        this.pickupAddress,
        this.pickupLat,
        this.pickupLong,
        this.customerName,
        this.customerPhone,
        this.customerAddress,
        this.customerLat,
        this.customerLong,
        this.invoiceNo,
        this.totalDeliveryAmount,
        this.codAmount,
        this.vat,
        this.vatAmount,
        this.currentPayable,
        this.cashCollection,
        this.deliveryTypeId,
        this.deliveryType,
        this.status,
        this.weight,
        this.distance,
        this.gstNumber,
        this.gstType,
        this.customerFullAddress,
        this.pinCode,
        this.quantity,
      //  this.distanceTotal,
        this.deliveryCharge,
        this.distanceAmount,
        this.packagingAmount,
        this.note,
        this.distanceId,
        this.statusName,
        this.pickupDate,
        this.deliveryDate,
        this.createdAt,
        this.updatedAt,
        this.parcelDate,
        this.parcelTime});

  ParcelLogInvoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingId = json['tracking_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    mobile = json['mobile'];
    pickupPhone = json['pickup_phone'];
    pickupAddress = json['pickup_address'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerAddress = json['customer_address'];
    customerLat = json['customer_lat'];
    customerLong = json['customer_long'];
    invoiceNo = json['invoice_no'];
    totalDeliveryAmount = json['total_delivery_amount'];
    codAmount = json['cod_amount'];
    vat = json['vat'];
    vatAmount = json['vat_amount'];
    currentPayable = json['current_payable'];
    cashCollection = json['cash_collection'];
    deliveryTypeId = json['delivery_type_id'];
    deliveryType = json['deliveryType'];
    status = json['status'];
    weight = json['weight'];
    distance = json['distance'];
    gstNumber = json['gst_number'];
    gstType = json['gst_type'];
    customerFullAddress = json['customer_fullAddress'];
    pinCode = json['pin_code'];
    quantity = json['quantity'];
    //distanceTotal = json['distance_total'];
    deliveryCharge = json['delivery_charge'];
    distanceAmount = json['distance_amount'];
    packagingAmount = json['packaging_amount'];
    note = json['note'];
    distanceId = json['distance_id'];
    statusName = json['statusName'];
    pickupDate = json['pickup_date'];
    deliveryDate = json['delivery_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    parcelDate = json['parcel_date'];
    parcelTime = json['parcel_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tracking_id'] = this.trackingId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['mobile'] = this.mobile;
    data['pickup_phone'] = this.pickupPhone;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_address'] = this.customerAddress;
    data['customer_lat'] = this.customerLat;
    data['customer_long'] = this.customerLong;
    data['invoice_no'] = this.invoiceNo;
    data['total_delivery_amount'] = this.totalDeliveryAmount;
    data['cod_amount'] = this.codAmount;
    data['vat'] = this.vat;
    data['vat_amount'] = this.vatAmount;
    data['current_payable'] = this.currentPayable;
    data['cash_collection'] = this.cashCollection;
    data['delivery_type_id'] = this.deliveryTypeId;
    data['deliveryType'] = this.deliveryType;
    data['status'] = this.status;
    data['weight'] = this.weight;
    data['distance'] = this.distance;
    data['gst_number'] = this.gstNumber;
    data['gst_type'] = this.gstType;
    data['customer_fullAddress'] = this.customerFullAddress;
    data['pin_code'] = this.pinCode;
    data['quantity'] = this.quantity;
    //data['distance_total'] = this.distanceTotal;
    data['delivery_charge'] = this.deliveryCharge;
    data['distance_amount'] = this.distanceAmount;
    data['packaging_amount'] = this.packagingAmount;
    data['note'] = this.note;
    data['distance_id'] = this.distanceId;
    data['statusName'] = this.statusName;
    data['pickup_date'] = this.pickupDate;
    data['delivery_date'] = this.deliveryDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['parcel_date'] = this.parcelDate;
    data['parcel_time'] = this.parcelTime;
    return data;
  }
}