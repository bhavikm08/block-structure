

import '../Api_Service/api_service.dart';
import 'package:http/http.dart' as http;

import '../Common/api_constant.dart';

class AuthRepository {
  final apiService = ApiService();

  Future<http.Response> callLogin({
    required String email,
    required String password,
})async{
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var formData = {
      'username': email,
      'password': password,
    };
    return await apiService.request(
      endPoint: ApiConstant.loginApi,
      method: Method.MULTIPART,
      reqBody: formData,
      headers: headers,
    );
  }

  Future<http.Response> fetchPosts()async{
    return await apiService.request(endPoint: ApiConstant.postsApi, method: Method.GET);
  }

}
