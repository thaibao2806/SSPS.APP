class ChatbotRequestModel {
  String? message;
  String? userId;
  bool isAdmin;

  ChatbotRequestModel({
    required this.message,
    required this.userId,
    required this.isAdmin,
  });

  // Method to create a ChatbotRequestModel from a JSON object
  factory ChatbotRequestModel.fromJson(Map<String, dynamic> json) {
    return ChatbotRequestModel(
      message: json['message'] as String,
      userId: json['userId'] as String,
      isAdmin: json['isAdmin'] as bool,
    );
  }

  // Method to convert a ChatbotRequestModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'isAdmin': isAdmin,
    };
  }
}
