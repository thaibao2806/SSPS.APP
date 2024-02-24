class UpdateUserRequestModel {
  UpdateUserRequestModel({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.school,
    required this.location,
    // required this.status,
  });
  late final String phone;
  late final String firstName;
  late final String lastName;
  late final String school;
  late final String location;
  // late final String status;
  
  UpdateUserRequestModel.fromJson(Map<String, dynamic> json){
    phone = json['phone'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    school = json['school'];
    location = json['location'];
    // status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phone'] = phone;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['school'] = school;
    _data['location'] = location;
    // _data['status'] = status;
    return _data;
  }
}