class ChangePasswordOtpRequestModel {
  ChangePasswordOtpRequestModel({
    required this.otp,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  late final String? otp;
  late final String? email;
  late final String? password;
  late final String? confirmPassword;
  
  ChangePasswordOtpRequestModel.fromJson(Map<String, dynamic> json){
    otp = json['otp'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['otp'] = otp;
    _data['email'] = email;
    _data['password'] = password;
    _data['confirmPassword'] = confirmPassword;
    return _data;
  }
}