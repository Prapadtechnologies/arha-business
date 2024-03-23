class OtpLoginModels{

  bool? success;
  String? message;
  Data? data;

  OtpLoginModels({this.success, this.message, this.data});

  OtpLoginModels.fromJson(Map<String, dynamic> json) {
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
  String? mobile;
  String? userType;
  int? oUROTP;

  Data({this.mobile, this.userType, this.oUROTP});

  Data.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    userType = json['user_type'];
    oUROTP = json['OUR_OTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['user_type'] = this.userType;
    data['OUR_OTP'] = this.oUROTP;
    return data;
  }
}