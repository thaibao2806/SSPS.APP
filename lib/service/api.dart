import 'package:dio/dio.dart';
import 'package:ssps_app/service/api_service.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:ssps_app/models/login_response_model.dart';

class API {
  // static Dio dio = Dio();
  // static Dio refreshTokenDio = Dio();
  // static var isRefreshing = false;
  // static late Completer<void> onRefresh;

  // static void init() {
  //   dio.interceptors.add(InterceptorsWrapper(
  //     onError: (DioError error, ErrorInterceptorHandler handler) async {
  //       if (error.response?.statusCode == 401) {
  //         try {
  //           dio.lock();
  //           if (!isRefreshing) {
  //             isRefreshing = true;
  //             onRefresh = Completer<void>();

  //             var token = await SharedService.loginDetails();
  //             var response = await refreshTokenDio.post(
  //               Config.refreshTokenURL,
  //               data: {"refreshToken": token?.data?.refreshToken},
  //             );

  //             // Check if refreshToken expired
  //             if (response.statusCode == 401) {
  //               SharedService.logout();
  //               return error;
  //             }

  //             // Save new access token
  //             token?.data?.accessToken = response.data["accessToken"];
  //             token?.data?.refreshToken = response.data["refreshToken"];
  //             await SharedService.setLoginDetails(token);

  //             isRefreshing = false;
  //             onRefresh.complete();
  //           } else {
  //             await onRefresh.future;
  //           }

  //           // Repeat failed request
  //           return dio.request(
  //             error.requestOptions.path,
  //             options: error.requestOptions,
  //             data: error.requestOptions.data,
  //             onReceiveProgress: error.requestOptions.onReceiveProgress,
  //             onSendProgress: error.requestOptions.onSendProgress,
  //             cancelToken: error.requestOptions.cancelToken,
  //           );
  //         } catch (e) {
  //           return e;
  //         } finally {
  //           dio.unlock();
  //         }
  //       }
  //       return error;
  //     },
  //   ));
  // }
}