class Config {
  static const String appName = "SSPS";
  static const String apiUrl = "10.0.2.2:5031";
  static const String apiUrlChat = "10.0.2.2:5000";
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
  static const String swapTodoCart = "/api/user/to-do-card/swap";
  static const String getCategories = "/api/user/category";
  static const String createAndUpdateCategories = "/api/user/update-category";
  static const String createNote = "/api/user/note";
  static const String deleteNote = "/api/user/note/delete";
  static const String updateNote = "/api/user/note";
  static const String getNote = "/api/user/note/get-in-range";
  static const String deleteCategory = "/api/user/delete-category";
  static const String getMoneyPlanById = "/api/user/money-plan";
  static const String createMoneyPlan = "/api/user/money-plan/create-list-money-plan";
  static const String updateUsageMoneyPlan = "/api/user/money-plan/update-usage-money-plan";
  static const String getMoneyPlan = "/api/user/money-plan/range-type";
  static const String deleteMoneyPlan = "/api/user/money-plan/delete-money-plan";
  static const String updateMoneyPlan = "/api/user/money-plan/update-money-plan";
  static const String dashboard = "/api/user/dashboard-user";
  static const String chatBox = "/chatbox";
  
}
