import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/main.dart';
import 'package:ssps_app/models/active_account_request_model.dart';
import 'package:ssps_app/models/active_account_response_model.dart';
import 'package:ssps_app/models/categories/delete_category_request_model.dart';
import 'package:ssps_app/models/categories/delete_category_response_model.dart';
import 'package:ssps_app/models/categories/get_category_response_model.dart';
import 'package:ssps_app/models/categories/update_category_request_model.dart';
import 'package:ssps_app/models/categories/update_category_response_model.dart';
import 'package:ssps_app/models/changePasswordOTP_request_model.dart';
import 'package:ssps_app/models/changePasswordOTP_response_model.dart';
import 'package:ssps_app/models/changePassword_request_model.dart';
import 'package:ssps_app/models/changePassword_response_model.dart';
import 'package:ssps_app/models/chatbox/chatbox_response_model.dart';
import 'package:ssps_app/models/get_user_response_model.dart';
import 'package:ssps_app/models/login_request_model.dart';
import 'package:ssps_app/models/login_response_model.dart';
import 'package:ssps_app/models/login_response_model.dart' as LoginData;
import 'package:ssps_app/models/moneyPlans/create_moneyPlan_request_model.dart';
import 'package:ssps_app/models/moneyPlans/create_moneyPlan_response_model.dart';
import 'package:ssps_app/models/moneyPlans/delete_moneyPlan_response_model.dart';
import 'package:ssps_app/models/moneyPlans/get_moneyPlan_byId_response_model.dart';
import 'package:ssps_app/models/moneyPlans/get_moneyPlan_response_model.dart';
import 'package:ssps_app/models/moneyPlans/update_moneyPlan_request_model.dart';
import 'package:ssps_app/models/moneyPlans/update_moneyPlan_response_model.dart';
import 'package:ssps_app/models/moneyPlans/update_usageMoney_request_model.dart';
import 'package:ssps_app/models/moneyPlans/update_usageMoney_response_model.dart';
import 'package:ssps_app/models/notes/create_note_request_model.dart';
import 'package:ssps_app/models/notes/create_note_response_model.dart';
import 'package:ssps_app/models/notes/delete_note_response_model.dart';
import 'package:ssps_app/models/notes/get_note_response_model.dart';
import 'package:ssps_app/models/notes/update_note_request_model.dart';
import 'package:ssps_app/models/notes/update_note_response_model.dart';
import 'package:ssps_app/models/refresh_token_response_model.dart';
import 'package:ssps_app/models/register_request_model.dart';
import 'package:ssps_app/models/register_response_model.dart';
import 'package:ssps_app/models/forgotPassword_request_model.dart';
import 'package:ssps_app/models/forgotPassword_response_model.dart';
import 'package:ssps_app/models/report/report_response_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_response_model.dart';
import 'package:ssps_app/models/todolist/create_todo_note_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_note_response_model.dart';
import 'package:ssps_app/models/todolist/delete_todo_card_response_model.dart';
import 'package:ssps_app/models/todolist/delete_todo_note_resquest_model.dart';
import 'package:ssps_app/models/todolist/get_all_todo_response_model.dart';
import 'package:ssps_app/models/todolist/swap_response_model.dart';
import 'package:ssps_app/models/todolist/update_todo_card_response_model.dart';
import 'package:ssps_app/models/todolist/update_todo_cart_request_model.dart';
import 'package:ssps_app/models/todolist/update_todo_note_request_model.dart';
import 'package:ssps_app/models/todolist/update_todo_note_response_model.dart';
import 'package:ssps_app/models/update_user_request_model.dart';
import 'package:ssps_app/models/update_user_response_model.dart';
import 'package:ssps_app/pages/loginPage.dart';
import 'package:ssps_app/service/shared_service.dart';

class ApiService {
  static var client = http.Client();

  static bool isAccessTokenExpired(String accessToken) {
    var expirationTime;
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      expirationTime = decodedToken['exp'] as int;
    }
    var currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expirationTime < currentTime;
  }

  static Future<LoginResponseModel> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.loginApi);
    print(url);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body);
    if (response.statusCode == 200) {
      //SHARED
      // print(response.body);
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return loginResponseJson(response.body);
    } else {
      return loginResponseJson(response.body);
    }
  }

  static Future<RefreshTokenResponseModel> refreshToken(
      String? refreshToken) async {
    var token = (await SharedService.loginDetails());
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(
        Config.apiUrl, Config.refreshTokenAPI, {'refreshToken': refreshToken});

    var response = await client.get(url, headers: requestHeaders);
    return refreshResponseModel(response.body);
  }

  static Future<RegisterResponseModel> register(
      RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.registerOTP);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body);

    return registerResponseModel(response.body);
  }

  static Future<ActiveAccountResponseModel> activeAccountOTP(
      ActiveAccountRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.activeAccount);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body);

    return activeAccountResponseModel(response.body);
  }

  static Future<ForgotPasswordResponseModel> fotgotPassword(
      ForgotPasswordRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.forgotPasswordApi);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    return forgotPasswordResponseJson(response.body);
  }

  static Future<ForgotPasswordResponseModel> fotgotPasswordOTP(
      ForgotPasswordRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.forgotPasswordOtp);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    return forgotPasswordResponseJson(response.body);
  }

  static Future<GetUserResponseModel> getUserProfile() async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };
    var url = Uri.http(Config.apiUrl, Config.getUser + id);

    var response = await client.get(url, headers: requestHeaders);
    // print(response.body);
    // if(response.statusCode == 200) {

    // }
    return getUserResponseJson(response.body);
  }

  static Future<UpdateUserResponseModel> updateUserProfile(
      UpdateUserRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.updateUser + id);
    print(url);

    var response = await client.put(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print("response: ${response.body}");
    // print(response.body);
    return updateUserResponseJson(response.body);
  }

  static Future<GetAllTodoResponseModel> getAllTodo() async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.getAllTodo);
    print(url);
    var response = await client.get(url, headers: requestHeaders);
    return getAllTodoResponseJson(response.body);
  }

  static Future<DeleteTodoNoteResponseModel> deleteTodoNote(String? id) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.deleteTodoNote, {'id': id});
    print(url);

    var response = await client.post(url, headers: requestHeaders);
    // if(response.statusCode == 200) {

    // }
    return deleteTodoNoteResponseJson(response.body);
  }

  static Future<DeleteTodoCardResponseModel> deleteTodoCard(
      String? ToDoNoteId, String? CardId) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.deleteTodoCart,
        {'ToDoNoteId': ToDoNoteId, 'CardId': CardId});
    print(url);

    var response = await client.post(url, headers: requestHeaders);
    return deleteTodoCardResponseJson(response.body);
  }

  static Future<CreateTodoCardResponseModel> createTodoCard(
      CreateTodoCardRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.createTodoCart);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    return createTodoCardResponseJson(response.body);
  }

  static Future<CreateTodoNoteResponseModel> createTodoNote(
      CreateTodoNoteRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.createTodoNote);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(jsonEncode(model.toJson()));
    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không phải là null
      if (response.body != null) {
        return createTodoNoteResponseJson(response.body);
      } else {
        // Xử lý trường hợp response.body là null
        throw Exception('Response body is null');
      }
    } else {
      // Xử lý trường hợp status code không phải là 200
      throw Exception('Failed to create todo note: ${response.statusCode}');
    }
  }

  static Future<UpdateTodoCartResponseModel> updateTodoCard(
      UpdateTodoCartRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.updateTodoCart);
    print(url);

    var response = await client.put(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(jsonEncode(response.body));
    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không phải là null
      if (response.body != null) {
        return updateTodoCardResponseJson(response.body);
      } else {
        // Xử lý trường hợp response.body là null
        throw Exception('Response body is null');
      }
    } else {
      // Xử lý trường hợp status code không phải là 200
      throw Exception('Failed to create todo note: ${response.statusCode}');
    }
  }

  static Future<UpdateTodoNoteResponseModel> updateTodoNote(
      UpdateTodoNoteRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.updateTodoNote);
    print(url);

    var response = await client.put(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body);
    print(jsonEncode(model.toJson()));
    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không phải là null
      if (response.body != null) {
        return updateTodoNoteResponseJson(response.body);
      } else {
        // Xử lý trường hợp response.body là null
        throw Exception('Response body is null');
      }
    } else {
      // Xử lý trường hợp status code không phải là 200
      throw Exception('Failed to create todo note: ${response.statusCode}');
    }
  }

  static Future<SwapResponseModel> swapCart(
      String? CardId, String? FromToDoNoteId, String? ToToDoNoteId) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.swapTodoCart, {
      'CardId': CardId,
      'FromToDoNoteId': FromToDoNoteId,
      'ToToDoNoteId': ToToDoNoteId
    });
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    return swapResponseJson(response.body);
  }

  static Future<GetCategoryResponseModel> getCategories() async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.getCategories);
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    print(jsonEncode(response.body));
    return getCategoryResponseJson(response.body);
  }

  static Future<UpdateCategoryResponseModel> createCategories(
      UpdateCategoryRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.createAndUpdateCategories);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return updateCategoryResponseJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<CreateNoteResponseModel> createNote(
      CreateNoteRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.createNote);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return createNoteResponseJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<UpdateNoteResponseModel> updateNote(
      UpdateNoteRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.updateNote);
    print(url);

    var response = await client.put(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return updateNoteResponseJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<DeleteNoteResponseModel> deleteNote(String? id) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.deleteNote, {'Id': id});
    print(url);

    var response = await client.post(url, headers: requestHeaders);
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return deleteNoteResponseJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<GetNoteResponseModel> getNote(
      String? fromDate, String? toDate) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.getNote,
        {'FromDate': fromDate, 'ToDate': toDate});
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return getNoteResponseJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<DeleteCategoryResponseModel> deleteCategory(
      DeleteCategoryRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.deleteCategory);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return deleteCategoryResponseJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<CreateMoneyPlanResponseModel> createMoneyPlan(
      CreateMoneyPlanRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.createMoneyPlan);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response);
    print(jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return createMoneyPlanResponseJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<UpdateMoneyPlanResponseModel> updateMoneyPlan(
      UpdateMoneyPlanRequestModel model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.updateUsageMoneyPlan);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return updateMoneyPlanResponseModelJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<GetMoneyPlanResponseModel> getMoneyPlan(
      String? FromDate, String? ToDate) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.getMoneyPlan,
        {"FromDate": FromDate, "ToDate": ToDate});
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return getMoneyPlanJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<DeleteMoneyPlanResponseModel> deleteMoneyPlan(
      String? MoneyPlanId) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(
        Config.apiUrl, Config.deleteMoneyPlan, {"MoneyPlanId": MoneyPlanId});
    print(url);

    var response = await client.post(url, headers: requestHeaders);
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body.isNotEmpty) {
        return deleteMoneyPlanResponseModelJson(response.body);
      } else {
        throw Exception('Empty response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<GetMoneyPlanByIdResponseModel> getMoneyPlanById(
      String? id) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.getMoneyPlanById + "/${id}");
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    print(jsonEncode(response.body));

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body != null && response.body.isNotEmpty) {
        return getMoneyPlanIdResponseModelJson(response.body);
      } else {
        throw Exception('Empty or null response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<UpdateMoneyPlanResponseModels> updateMoneyPlans(
      UpdateMoneyPlanRequestModels model) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.updateMoneyPlan);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response);
    print(jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body != null && response.body.isNotEmpty) {
        return updateMoneyPlanResponseJson(response.body);
      } else {
        throw Exception('Empty or null response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<ReportResponseModel> report(
      String? Type, String? FromDate, String? ToDate) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.dashboard,
        {"Type": Type, "FromDate": FromDate, "ToDate": ToDate});
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body != null && response.body.isNotEmpty) {
        return reportResponseJson(response.body);
      } else {
        throw Exception('Empty or null response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<ChangePasswordResponseModel> changePassword(
      ChangePasswordRequestModel model, String? id) async {
    var token = (await SharedService.loginDetails());
    var accessToken = token!.data!.accessToken;
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);
    if (token != null) {
      if (isAccessTokenExpired(token.data!.accessToken)) {
        var refreshedToken = await refreshToken(token.data!.refreshToken);
        if (refreshedToken != null) {
          accessToken = refreshedToken.data!.accessToken;

          var newTokenData = LoginData.Data(
            accessToken: refreshedToken.data!.accessToken,
            refreshToken: token.data!.refreshToken,
          );

          var newToken = LoginResponseModel(
            result: token.result,
            msgCode: token.msgCode,
            msgDesc: token.msgDesc,
            data: newTokenData,
          );
          await SharedService.setLoginDetails(newToken);
        } else {
          Navigator.of(naviatorKey.currentContext!).pushReplacement(
              MaterialPageRoute(builder: (context) => loginPage()));
        }
      }
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.changePasswords + "${id}");
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response);

    if (response.statusCode == 200) {
      // Kiểm tra nếu response.body không rỗng
      if (response.body != null && response.body.isNotEmpty) {
        return changePasswordResponseJson(response.body);
      } else {
        throw Exception('Empty or null response body');
      }
    } else {
      // Xử lý lỗi HTTP tại đây
      throw Exception('Failed to create categories: ${response.statusCode}');
    }
  }

  static Future<ChangePasswordOtpResponseModel> changePasswordOTP(
      ChangePasswordOtpRequestModel model) async {
    var token = (await SharedService.loginDetails());
    // Map<String, dynamic> decodedToken =
    //     JwtDecoder.decode(token!.data!.accessToken);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${token?.data?.accessToken}',
      "ngrok-skip-browser-warning": "69420"
    };

    var url = Uri.http(Config.apiUrl, Config.resetPasswordOtp);
    print(url);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(jsonEncode(model.toJson()));
    return changePasswordOTPResponseJson(response.body);

    // if (response.statusCode == 200) {
    //   // Kiểm tra nếu response.body không rỗng
    //   if (response.body != null && response.body.isNotEmpty) {
    //     return changePasswordOTPResponseJson(response.body);
    //   } else {
    //     throw Exception('Empty or null response body');
    //   }
    // } else {
    //   // Xử lý lỗi HTTP tại đây
    //   throw Exception('Failed to create categories: ${response.statusCode}');
    // }
  }

  static Future<ChatboxResponseModel> chatBox(
      String? message, String? username) async {
    var token = (await SharedService.loginDetails());
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(token!.data!.accessToken);

    var url = Uri.http(Config.apiUrlChat, Config.chatBox);
    print(url);

    // Tạo một yêu cầu POST multipart
    var request = http.MultipartRequest('POST', url);

    // Thêm headers vào yêu cầu
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${token?.data?.accessToken}',
      "ngrok-skip-browser-warning": "69420"
    });

    // Thêm trường form 'message' vào yêu cầu
    request.fields['message'] = message!;
    request.fields['username'] = username!;

    // Gửi yêu cầu và nhận phản hồi
    var response = await request.send();
    print(response);
    // Chuyển đổi phản hồi thành http.Response
    var httpResponse = await http.Response.fromStream(response);
    print(httpResponse.body);

    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
      // Kiểm tra nếu httpResponse.body không rỗng
      if (httpResponse.body != null && httpResponse.body.isNotEmpty) {
        return chatboxResponseModelJson(httpResponse.body);
      } else {
        throw Exception('Empty or null response body');
      }
    }
    if (httpResponse.statusCode == 500) {
      throw Exception('Internal Server Error');
    } else {
      throw Exception(
          'Failed to create categories: ${httpResponse.statusCode}');
    }
  }
}
