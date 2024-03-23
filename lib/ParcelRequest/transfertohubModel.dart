
class TransferToHub {
  bool? success;
  String? message;
  Data? data;

  TransferToHub({this.success, this.message, this.data});

  TransferToHub.fromJson(Map<String, dynamic> json) {
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
  bool? request;

  Data({this.request});

  Data.fromJson(Map<String, dynamic> json) {
    request = json['Request'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Request'] = this.request;
    return data;
  }
}