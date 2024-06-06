class ChangePasswordRequestModel {
  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
  late final String? currentPassword;
  late final String? newPassword;
  late final String? confirmPassword;
  
  ChangePasswordRequestModel.fromJson(Map<String, dynamic> json){
    currentPassword = json['currentPassword'];
    newPassword = json['newPassword'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['currentPassword'] = currentPassword;
    _data['newPassword'] = newPassword;
    _data['confirmPassword'] = confirmPassword;
    return _data;
  }
}