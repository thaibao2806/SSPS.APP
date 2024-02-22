class Config {
  static const String appName="SSPS";
  static const String apiUrl= "10.0.2.2:5031";
  static const String loginApi = "/api/authenticate/login";
  static const String registerApi = "/api/authenticate/register";
  static const String forgotPasswordApi = "/api/authenticate/forgot-password";
  static const String getUser = "/api/user";
  static const String updateUser = "/api/user";
  static const String getAllTodo = "/api/user/to-do-note/get-all";
  static const String createTodoNote = "/api/user/to-do-note";
  static const String updateTodoNote = "/api/user/to-do-note";
  static const String deleteTodoNote = "/api/user/to-do-note/delete";
  static const String deleteTodoCart = "/api/user/to-do-card/delete";
  static const String createTodoCart = "/api/user/to-do-card";
  static const String updateTodoCart = "/api/user/to-do-card";
}