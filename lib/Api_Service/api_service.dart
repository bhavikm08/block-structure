import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Common/api_constant.dart';
import '../Utils/logger.dart';


enum Method { POST, GET, DELETE, PUT, PATCH, MULTIPART }

class ApiService {
  Future<http.Response> request({
    required String endPoint,
    required Method method,
    var reqBody,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    http.Response? response;
    try {
      Uri uri = Uri.parse(endPoint);
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      _logRequest('$uri', method, reqBody, headers);

      if (method == Method.POST) {
        response = await http.post(uri, body: reqBody, headers: headers);
      } else if (method == Method.DELETE) {
        response = await http.delete(uri, headers: headers, body: reqBody);
      } else if (method == Method.PATCH) {
        response = await http.patch(uri, headers: headers, body: reqBody);
      } else if (method == Method.MULTIPART) {
        if (reqBody != null && reqBody is Map<String, dynamic>) {
          var request = http.MultipartRequest('POST', uri);
          reqBody.forEach((key, value) {
            request.fields[key] = value.toString();
          });

          if (headers != null) {
            request.headers.addAll(headers);
          }
          response = await http.Response.fromStream(await request.send());
        } else {
          throw Exception("Invalid multipart request body");
        }
      } else {
        response = await http.get(uri, headers: headers);
      }

      _logResponse(response);

      if (response.statusCode == 200) {
        return response;
        // return json.decode(response);
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something Went Wrong");
      }
    } on SocketException catch (e) {
      _logError(response);
      throw Exception("No Internet Connection $e");
    } on FormatException {
      _logError(response);
      throw Exception("Bad Response Format!");
    } catch (e) {
      _logError(response);
      throw Exception("Something Went Wrong $e");
    }
  }
}

void _logRequest(
    String url, Method method, dynamic params, Map<String, String>? headers) {
  logger.log(
      "\n\n--------------------------------------------------------------------------------------------------------");
  if (method == Method.GET) {
    logger.log(
        "✈️ REQUEST[$method] => PATH: $url \n Headers: ${headers ?? {}} \n DATA: ${jsonEncode(params)}");
  } else {
    try {
      logger.log(
          "✈️ REQUEST[$method] => PATH: $url \n Headers: ${headers ?? {}} \n DATA: $params",
          printFullText: true);
    } catch (e) {
      logger.log(
          "✈️ REQUEST[$method] => PATH: $url \n Headers: ${headers ?? {}} \n DATA: $params",
          printFullText: true);
    }
  }
}

void _logResponse(http.Response response) {
  final statusCode = response.statusCode;
  final uri = response.request!.url;
  final data = jsonDecode(response.body);
  logger.log("✅ RESPONSE[$statusCode] => PATH: $uri \n DATA: $data",
      printFullText: true);
}

void _logError(dynamic error) {
  if (error is http.Response) {
    final statusCode = error.statusCode;
    final uri = error.request!.url;
    final data = jsonDecode(error.body);
    logger.log("⚠️ ERROR[$statusCode] => PATH: $uri\n DATA: $data",
        printFullText: true);
  } else {
    logger.log("⚠️ ERROR: $error", printFullText: true);
  }
}
