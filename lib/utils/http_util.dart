import 'package:code/constants/constants.dart';
import 'package:code/utils/toast.dart';
import 'package:dio/dio.dart';

class ApiResponse<T> {
  final T? data;
  final bool success;
  final String? errorMessage;

  ApiResponse({this.data, required this.success, this.errorMessage});
}

final dio = Dio();

class HttpUtil {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: kBaseUrl_Dev, // 设置请求的基础域名
    connectTimeout: Duration(seconds: 15), // 连接超时时间，单位是毫秒
    receiveTimeout: Duration(seconds: 15), // 接收超时时间，单位是毫秒
  ));

  static Future<ApiResponse> get(
      String path, Map<String, dynamic>? query,
      {bool showLoading = false,Map<String, dynamic> data = const {}}) async {
    // 显示蒙板
    if (showLoading) {
      TTToast.showLoading();
    }
    try {
      if (query != null) {
        Uri uri = Uri.parse(path).replace(queryParameters: query);
        path = uri.toString();
      }
      print('get数据请求data:${path}');
      print('get数据请求data:${data}');
      final response = await _dio.get(path, data: data);
      print('get数据请求返回data:${response}');
      if (showLoading) {
        TTToast.hideLoading();
      }
      if ( response.data!= null && response.data['code'] == '0' ) {
        return ApiResponse(
            success: true, data: response.data, errorMessage: 'success');
      } else {
        if (showLoading) {
          TTToast.showErrorInfo(response.data['msg']);
        }
        return ApiResponse(
            success: false, data: response.data, errorMessage: 'false');
      }
    } catch (e) {
      if (showLoading) {
        TTToast.showErrorInfo('unknow error');
      }
      _handleError(e);
      rethrow;
    }
  }

  static Future<ApiResponse> post(String path, dynamic data,
      {bool showLoading = false}) async {
    // 显示蒙板
    if (showLoading) {
      TTToast.showLoading();
    }
    try {
      print('post数据请求data:${path}');
      print('post数据请求data:${data}');
      final response = await _dio.post(path, data: data);
      print('post数据请求返回data:${response}');
      if (showLoading) {
        TTToast.hideLoading();
      }
      if ( response.data != null && response.data['code'] == '0') {
        return ApiResponse(
            success: true, data: response.data, errorMessage: 'success');
      } else {
        if (showLoading) {
          TTToast.showErrorInfo(response.data['msg']);
        }
        return ApiResponse(
            success: false, data: response.data, errorMessage: 'false');
      }
    } catch (e) {
      if (showLoading) {
        TTToast.showErrorInfo('unknow error');
      }
      _handleError(e);
      rethrow;
    }
  }

  static void _handleError(dynamic error) {
    if (error is DioError) {
      switch (error.type) {
        case DioExceptionType.cancel:
          // 请求取消
          break;
        case DioExceptionType.connectionTimeout:
          // 连接超时
          break;
        case DioExceptionType.sendTimeout:
          // 发送超时
          break;
        case DioExceptionType.receiveTimeout:
          // 接收超时
          break;
        case DioExceptionType.badResponse:
          // 响应错误
          if (error.response!.statusCode == 401) {
            // 处理401错误，例如跳转到登录页
          } else if (error.response!.statusCode == 500) {
            // 处理500错误，例如显示服务器错误信息
          }
          break;
        case DioExceptionType.badCertificate:
          // 其他错误
          break;
        case DioExceptionType.unknown:
          // 其他错误
          break;
        case DioExceptionType.connectionError:
        // TODO: Handle this case.
      }
    } else {
      // 其他类型的错误
    }
  }
}
