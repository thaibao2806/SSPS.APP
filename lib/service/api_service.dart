import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ssps_app/config.dart';
import 'package:ssps_app/models/get_user_response_model.dart';
import 'package:ssps_app/models/login_request_model.dart';
import 'package:ssps_app/models/login_response_model.dart';
import 'package:ssps_app/models/register_request_model.dart';
import 'package:ssps_app/models/register_response_model.dart';
import 'package:ssps_app/models/forgotPassword_request_model.dart';
import 'package:ssps_app/models/forgotPassword_response_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_card_response_model.dart';
import 'package:ssps_app/models/todolist/create_todo_note_request_model.dart';
import 'package:ssps_app/models/todolist/create_todo_note_response_model.dart';
import 'package:ssps_app/models/todolist/delete_todo_card_response_model.dart';
import 'package:ssps_app/models/todolist/delete_todo_note_resquest_model.dart';
import 'package:ssps_app/models/todolist/get_all_todo_response_model.dart';
import 'package:ssps_app/models/todolist/update_todo_card_response_model.dart';
import 'package:ssps_app/models/todolist/update_todo_cart_request_model.dart';
import 'package:ssps_app/models/update_user_request_model.dart';
import 'package:ssps_app/models/update_user_response_model.dart';
import 'package:ssps_app/service/shared_service.dart';

class ApiService {
  static var client = http.Client();
  
  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.loginApi);

    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    // print(response.body);
    if(response.statusCode == 200) {
      //SHARED
      // print(response.body);
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return true;
    }else {
      return false;
    }
  }

  static Future<RegisterResponseModel> register(RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.registerApi);

    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body);

    return registerResponseModel(response.body);
  }

  static Future<ForgotPasswordResponseModel> fotgotPassword(ForgotPasswordRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(Config.apiUrl, Config.forgotPasswordApi);

    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));

    return forgotPasswordResponseJson(response.body);
  }

  static Future<GetUserResponseModel> getUserProfile() async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.getUser + id);

    var response = await client.get(url, headers: requestHeaders);
    // print(response.body);
    // if(response.statusCode == 200) {
      
    // }
    return getUserResponseJson(response.body);
  }

  static Future<UpdateUserResponseModel> updateUserProfile(UpdateUserRequestModel model) async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.updateUser + id);
    print(url);

    var response = await client.put(url, headers: requestHeaders,  body: jsonEncode(model.toJson()));
    print("response: ${response.body}");
    // print(response.body);
    return updateUserResponseJson(response.body);
  }

  static Future<GetAllTodoResponseModel> getAllTodo() async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);
    String? id = '/${decodedToken['id']}';

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.getAllTodo);

    var response = await client.get(url, headers: requestHeaders);
    return getAllTodoResponseJson(response.body);
  }

  static Future<DeleteTodoNoteResponseModel> deleteTodoNote( String? id) async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.deleteTodoNote, {'id': id});
    print(url);

    var response = await client.post(url, headers: requestHeaders);
    // if(response.statusCode == 200) {
      
    // }
    return deleteTodoNoteResponseJson(response.body);
  }

  static Future<DeleteTodoCardResponseModel> deleteTodoCard( String? ToDoNoteId, String? CardId) async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.deleteTodoCart, {'ToDoNoteId': ToDoNoteId, 'CardId': CardId});
    print(url);

    var response = await client.post(url, headers: requestHeaders);
    return deleteTodoCardResponseJson(response.body);
  }

  static Future<CreateTodoCardResponseModel> createTodoCard( CreateTodoCardRequestModel model) async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.createTodoCart);
    print(url);

    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    
    return createTodoCardResponseJson(response.body);
  }

  static Future<CreateTodoNoteResponseModel> createTodoNote( CreateTodoNoteRequestModel model) async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.createTodoNote);
    print(url);

    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body);
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

  static Future<UpdateTodoCartResponseModel> updateTodoCard( UpdateTodoCartRequestModel model) async {
    var token = (await SharedService.loginDetails()); 
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!.data!.accessToken);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token?.data?.accessToken}'
    };

    var url = Uri.http(Config.apiUrl, Config.updateTodoCart);
    print(url);

    var response = await client.put(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    print(response.body);
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
}