
class ParcelHubFilterModel{
  bool? success;
  String? message;
  Data? data;

  ParcelHubFilterModel({this.success, this.message, this.data});

  ParcelHubFilterModel.fromJson(Map<String, dynamic> json) {
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
  List<Parcels>? parcels;

  Data({this.parcels});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['parcels'] != null) {
      parcels = <Parcels>[];
      json['parcels'].forEach((v) {
        parcels!.add(new Parcels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parcels != null) {
      data['parcels'] = this.parcels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parcels {
  int? id;
  int? merchantId;
  int? merchantShopId;
  String? pickupAddress;
  String? pickupPhone;
  Null? pickupLat;
  Null? pickupLong;
  String? customerLat;
  String? customerLong;
  Null? priorityTypeId;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? invoiceNo;
  int? categoryId;
  int? weight;
  int? deliveryTypeId;
  int? packagingId;
  int? firstHubId;
  int? hubId;
  int? transferHubId;
  String? cashCollection;
  Null? oldCashCollection;
  String? sellingPrice;
  String? liquidFragileAmount;
  String? packagingAmount;
  String? deliveryCharge;
  int? codCharge;
  String? codAmount;
  int? vat;
  String? vatAmount;
  String? totalDeliveryAmount;
  String? currentPayable;
  String? trackingId;
  Null? note;
  int? partialDelivered;
  int? status;
  Null? parcelBank;
  String? pickupDate;
  String? deliveryDate;
  Null? returnCharges;
  String? createdAt;
  String? updatedAt;
  int? adminViewStatus;

  Parcels(
      {this.id,
        this.merchantId,
        this.merchantShopId,
        this.pickupAddress,
        this.pickupPhone,
        this.pickupLat,
        this.pickupLong,
        this.customerLat,
        this.customerLong,
        this.priorityTypeId,
        this.customerName,
        this.customerPhone,
        this.customerAddress,
        this.invoiceNo,
        this.categoryId,
        this.weight,
        this.deliveryTypeId,
        this.packagingId,
        this.firstHubId,
        this.hubId,
        this.transferHubId,
        this.cashCollection,
        this.oldCashCollection,
        this.sellingPrice,
        this.liquidFragileAmount,
        this.packagingAmount,
        this.deliveryCharge,
        this.codCharge,
        this.codAmount,
        this.vat,
        this.vatAmount,
        this.totalDeliveryAmount,
        this.currentPayable,
        this.trackingId,
        this.note,
        this.partialDelivered,
        this.status,
        this.parcelBank,
        this.pickupDate,
        this.deliveryDate,
        this.returnCharges,
        this.createdAt,
        this.updatedAt,
        this.adminViewStatus});

  Parcels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    merchantShopId = json['merchant_shop_id'];
    pickupAddress = json['pickup_address'];
    pickupPhone = json['pickup_phone'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    customerLat = json['customer_lat'];
    customerLong = json['customer_long'];
    priorityTypeId = json['priority_type_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerAddress = json['customer_address'];
    invoiceNo = json['invoice_no'];
    categoryId = json['category_id'];
    weight = json['weight'];
    deliveryTypeId = json['delivery_type_id'];
    packagingId = json['packaging_id'];
    firstHubId = json['first_hub_id'];
    hubId = json['hub_id'];
    transferHubId = json['transfer_hub_id'];
    cashCollection = json['cash_collection'];
    oldCashCollection = json['old_cash_collection'];
    sellingPrice = json['selling_price'];
    liquidFragileAmount = json['liquid_fragile_amount'];
    packagingAmount = json['packaging_amount'];
    deliveryCharge = json['delivery_charge'];
    codCharge = json['cod_charge'];
    codAmount = json['cod_amount'];
    vat = json['vat'];
    vatAmount = json['vat_amount'];
    totalDeliveryAmount = json['total_delivery_amount'];
    currentPayable = json['current_payable'];
    trackingId = json['tracking_id'];
    note = json['note'];
    partialDelivered = json['partial_delivered'];
    status = json['status'];
    parcelBank = json['parcel_bank'];
    pickupDate = json['pickup_date'];
    deliveryDate = json['delivery_date'];
    returnCharges = json['return_charges'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminViewStatus = json['admin_viewStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_id'] = this.merchantId;
    data['merchant_shop_id'] = this.merchantShopId;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_phone'] = this.pickupPhone;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['customer_lat'] = this.customerLat;
    data['customer_long'] = this.customerLong;
    data['priority_type_id'] = this.priorityTypeId;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_address'] = this.customerAddress;
    data['invoice_no'] = this.invoiceNo;
    data['category_id'] = this.categoryId;
    data['weight'] = this.weight;
    data['delivery_type_id'] = this.deliveryTypeId;
    data['packaging_id'] = this.packagingId;
    data['first_hub_id'] = this.firstHubId;
    data['hub_id'] = this.hubId;
    data['transfer_hub_id'] = this.transferHubId;
    data['cash_collection'] = this.cashCollection;
    data['old_cash_collection'] = this.oldCashCollection;
    data['selling_price'] = this.sellingPrice;
    data['liquid_fragile_amount'] = this.liquidFragileAmount;
    data['packaging_amount'] = this.packagingAmount;
    data['delivery_charge'] = this.deliveryCharge;
    data['cod_charge'] = this.codCharge;
    data['cod_amount'] = this.codAmount;
    data['vat'] = this.vat;
    data['vat_amount'] = this.vatAmount;
    data['total_delivery_amount'] = this.totalDeliveryAmount;
    data['current_payable'] = this.currentPayable;
    data['tracking_id'] = this.trackingId;
    data['note'] = this.note;
    data['partial_delivered'] = this.partialDelivered;
    data['status'] = this.status;
    data['parcel_bank'] = this.parcelBank;
    data['pickup_date'] = this.pickupDate;
    data['delivery_date'] = this.deliveryDate;
    data['return_charges'] = this.returnCharges;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['admin_viewStatus'] = this.adminViewStatus;
    return data;
  }
}