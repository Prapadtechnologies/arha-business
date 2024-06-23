class ParcelsModel {
  ParcelsModel({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  ParcelsModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;

  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({List<Parcels>? parcels,}){
    _parcels = parcels;
}

  Data.fromJson(dynamic json) {
    if (json['parcels'] != null) {
      _parcels = [];
      json['parcels'].forEach((v) {
        _parcels?.add(Parcels.fromJson(v));
      });
    }
  }
  List<Parcels>? _parcels;

  List<Parcels>? get parcels => _parcels;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_parcels != null) {
      map['parcels'] = _parcels?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Parcels {
  Parcels({
      int? id, 
      String? trackingId, 
      String? invoiceNO,
      String? merchantId,
      String? merchantName, 
      String? merchantMobile, 
      String? merchantUserName,
      String? merchantUserEmail,
      String? merchantAddress,
      String? customerName, 
      String? customerPhone, 
      String? customerAddress, 
      String? totalDeliveryAmount, 
      int? vat,
      String? codAmount,
      String? currentPayable,
      String? cashCollection, 
      int? deliveryTypeId, 
      String? deliveryType, 
      String? weight,
      int? status,
      String? statusName, 
      String? pickupDate, 
      String? deliveryDate, 
      String? createdAt, 
      int? updatedAt,
      String? parcelTime,
      String? parcelDate,
    String? packagingamount,
    String? vatAmount,
    int? pincode,
    String? customerfulladdress,
  }){
    _id = id;
    _trackingId = trackingId;
    _invoiceNO = invoiceNO;
    _merchantId = merchantId;
    _merchantName = merchantName;
    _merchantUserName = merchantUserName;
    _merchantUserEmail = merchantUserEmail;
    _merchantMobile = merchantMobile;
    _merchantAddress = merchantAddress;
    _customerName = customerName;
    _customerPhone = customerPhone;
    _customerAddress = customerAddress;
    _totalDeliveryAmount = totalDeliveryAmount;
    _vat = vat;
    _codAmount = codAmount;
    _currentPayable = currentPayable;
    _cashCollection = cashCollection;
    _deliveryTypeId = deliveryTypeId;
    _deliveryType = deliveryType;
    _weight = weight;
    _status = status;
    _statusName = statusName;
    _pickupDate = pickupDate;
    _deliveryDate = deliveryDate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _parcelTime = parcelTime;
    _parcelDate = parcelDate;
    _packagingamount = packagingamount;
    _vatamount = vatAmount;
    _pincode = pincode;
    _customer_full_address = customerfulladdress;
}

  Parcels.fromJson(dynamic json) {
    _id = json['id'];
    _trackingId = json['tracking_id'];
    _invoiceNO = json['invoice_no'];
    _merchantId = json['merchant_id'].toString();
    _merchantName = json['merchant_name'];
    _merchantUserName = json['user_name'];
    _merchantUserEmail = json['user_email'];
    _merchantMobile = json['mobile'];
    _merchantAddress = json['pickup_address'];
    _customerName = json['customer_name'];
    _customerPhone = json['customer_phone'];
    _customerAddress = json['customer_address'];
    _totalDeliveryAmount = json['total_delivery_amount'];
    _codAmount = json['cod_amount'];
    _vat = json['vat'];
    _currentPayable = json['current_payable'];
    _cashCollection = json['distance'];
    _deliveryTypeId = json['delivery_type_id'];
    _deliveryType = json['deliveryType'];
    _weight = json['weight'];
    _status = json['status'];
    _statusName = json['statusName'];
    _pickupDate = json['gst_number'];
    _deliveryDate = json['gst_type'];
    _createdAt = json['distance_amount'];
    _updatedAt = json['quantity'];
    _parcelTime = json['distance_total'];
    _parcelDate = json['parcel_date'];
    _packagingamount=   json['packaging_amount'];
    _vatamount = json['vat_amount'];
    _pincode = json['pin_code'];
    _customer_full_address = json['customer_fullAddress'];


  }
  int? _id;
  String? _trackingId;
  String? _invoiceNO;
  String? _merchantId;
  String? _merchantName;
  String? _merchantUserName;
  String? _merchantUserEmail;
  String? _merchantMobile;
  String? _merchantAddress;
  String? _customerName;
  String? _customerPhone;
  String? _customerAddress;
  String? _totalDeliveryAmount;
  int? _vat;
  String? _codAmount;
  String? _currentPayable;
  String? _cashCollection;
  int? _deliveryTypeId;
  String? _deliveryType;
  String? _weight;
  int? _status;
  String? _statusName;
  String? _pickupDate;
  String? _deliveryDate;
  String? _createdAt;
  int? _updatedAt;
  String? _parcelTime;
  String? _parcelDate;
  String? _packagingamount;
  String? _vatamount;
  int? _pincode;
  String? _customer_full_address;



  int? get id => _id;
  String? get trackingId => _trackingId;
  String? get invoiceNO => _invoiceNO;
  String? get merchantId => _merchantId;
  String? get merchantName => _merchantName;
  String? get merchantUserName => _merchantUserName;
  String? get merchantUserEmail => _merchantUserEmail;
  String? get merchantMobile => _merchantMobile;
  String? get merchantAddress => _merchantAddress;
  String? get customerName => _customerName;
  String? get customerPhone => _customerPhone;
  String? get customerAddress => _customerAddress;
  String? get totalDeliveryAmount => _totalDeliveryAmount;
  int? get vat => _vat;
  String? get codAmount => _codAmount;
  String? get currentPayable => _currentPayable;
  String? get cashCollection => _cashCollection;
  int? get deliveryTypeId => _deliveryTypeId;
  String? get weight => _weight;
  String? get deliveryType => _deliveryType;
  int? get status => _status;
  String? get statusName => _statusName;
  String? get pickupDate => _pickupDate;
  String? get deliveryDate => _deliveryDate;
  String? get createdAt => _createdAt;
  int? get updatedAt => _updatedAt;
  String? get parcelTime => _parcelTime;
  String? get parcelDate => _parcelDate;
  String? get packagingamount => _packagingamount;
  String? get vatAmount => _vatamount;
  int? get pinCode => _pincode;
  String? get customerfulladdress=> _customer_full_address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['tracking_id'] = _trackingId;
    map['invoice_no'] = _invoiceNO;
    map['merchant_id'] = _merchantId;
    map['merchant_name'] = _merchantName;
    map['user_name'] = _merchantUserName;
    map['user_email'] = _merchantUserEmail;
    map['mobile'] = _merchantMobile;
    map['pickup_address'] = _merchantAddress;
    map['customer_name'] = _customerName;
    map['customer_phone'] = _customerPhone;
    map['customer_address'] = _customerAddress;
    map['total_delivery_amount'] = _totalDeliveryAmount;
    map['vat'] = _vat;
    map['cod_amount'] = _codAmount;
    map['current_payable'] = _currentPayable;
    map['distance'] = _cashCollection;
    map['delivery_type_id'] = _deliveryTypeId;
    map['deliveryType'] = _deliveryType;
    map['weight'] = _weight;
    map['status'] = _status;
    map['statusName'] = _statusName;
    map['gst_number'] = _pickupDate;
    map['gst_type'] = _deliveryDate;
    map['distance_amount'] = _createdAt;
    map['quantity'] = _updatedAt;
    map['distance_total'] = _parcelTime;
    map['parcel_date'] = _parcelDate;
    map['packaging_amount'] = _packagingamount;
    map['vat_amount'] = _vatamount;
    map['pin_code'] = _pincode;
    map['customer_fullAddress'] = _customer_full_address;

    return map;
  }

}