class APIList {
  static String? mainUrl = "https://courier.prapadtechnologies.com/"; /*"your domain url";*/
  static String? apiUrl = "https://courier.prapadtechnologies.com/"; /*"your domain name";*/
  static String? mapGoogleApiKey = "AIzaSyA59LKmwVl-gP4U58kSKFTdu89I72bC1hM";

  static String? server = "${mainUrl}api/v10/";
  static String? apiCheckKey = "123456rx-ecourier123456";
  static String? apiEndPoint = "/api/v10/";
  static String? login = "${server!}signin";
  static String? hub = "${server!}hub";

  static String? filtershub = "${server!}hub/filter";
  static String? dashmain = "${server!}hub/parcel/index";

  static String? HubTrabsferRequest = "${server!}parcel/transfer-to-hub";

  static String? register = "${server!}register";
  static String? logout = "${server!}sign-out";
  static String? refreshToken = "${server!}refresh";
  static String? otpLogin = "${server!}otp-login";
  static String? otpResend = "${server!}resend-otp";
  static String? verifyOtp = "${server!}otp-verify";
  static String? profile = "${server!}profile";
  static String? device = "${server!}device";
  static String? fcmSubscribe = "${server!}fcm-subscribe";
  static String? fcmUnSubscribe = "${server!}fcm-unsubscribe";
  static String? generalSettings = "${server!}general-settings";
  static String? profileUpdate = "${server!}profile/update";
  static String? passwordUpdate = "${server!}update-password";
  static String? dashboard = "${server!}dashboard";
  static String? deliverycharges = "${server!}settings/delivery-charges";
  static String? codcharges = "${server!}settings/cod-charges";
  static String? fraudList = "${server!}fraud/index";
  static String? fraudPost = "${server!}fraud/store";
  static String? fraudEdit = "${server!}fraud/edit/";
  static String? fraudUpdate = "${server!}fraud/update/";
  static String? fraudDelete = "${server!}fraud/delete/";
  static String? shopList = "${server!}shops/index";
  static String? shopPost = "${server!}shops/store";
  static String? shopUpdate = "${server!}shops/update/";
  static String? shopDelete = "${server!}shops/delete/";
  static String? parcelList = "${server!}parcel/index";

  static String? Parcel_order_list = "${server!}parcel/index";

  static String? parcelFilter = "${server!}parcel/filter";
  static String? parcelCreate = "${server!}parcel/create";
  static String? parcelDetails = "${server!}parcel/details/";
  static String? parcelLogs = "${server!}parcel/logs/";
  static String? parcelStore = "${server!}parcel/store";
  static String? parcelEdit = "${server!}parcel/edit/";
  static String? parcelUpdate = "${server!}parcel/update/";
  static String? parcelDelete = "${server!}parcel/delete/";
  static String? parcelStatus = "${server!}parcel/";
  static String? parcelAllStatus = "${server!}parcel/all/status";
  static String? parcelListStatus = "${server!}status-wise/parcel/list/";
  static String? clearableParcels = "${server!}dashboard/available-parcels";
  static String? supportRemoveUrl = "${server!}support/delete/";
  static String? supportList = "${server!}support/index";
  static String? supportAdd = "${server!}support/store";
  static String? paymentAccountList = "${server!}payment-accounts/index";
  static String? paymentAccountAdd = "${server!}payment-account/store";
  static String? paymentRequestList = "${server!}payment-request/index";
  static String? paymentRequestAdd = "${server!}payment-request/store";
  static String? statementList = "${server!}statements/index";
  static String? accountTransactionList = "${server!}account-transaction/index";
  static String? offerList = "${server!}news-offer/index";
  static String? balanceDetails= "${server!}dashboard/balance-details";
  static String? invoiceList= "${server!}invoice-list/index";
  static String? invoiceDetails= "${server!}invoice-details/";
  static String? statementReport= "${server!}statement-reports";
  static String? analytics= "${server!}analytics";
}
