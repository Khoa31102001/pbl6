import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:base_code/src/manager/user_manager.dart';
import 'package:base_code/src/struct/api_services/domain_url.dart';

class BaseApi {
  BaseApi() {
    domain = DomainUrl.domain;
  }

  late String _domain;

  set domain(String newDomain) => _domain = newDomain;

  Future<dynamic> getMethod(url,
      {Map<String, String>? headers, Map<String, dynamic>? param}) async {
    headers ??= <String, String>{};

    headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserManager.globalToken}'
    });
    _logRequest(url, 'GET', param, {}, headers);
    Uri uri = Uri.parse('$_domain$url').replace(queryParameters: param);
    http.Response response = await http.get(uri, headers: headers);
    int statusCode = response.statusCode;
    _logResponse(url, statusCode, jsonDecode(utf8.decode(response.bodyBytes)));
    return _handleResponse(statusCode, response);
  }

  Future<dynamic> postMethod(url,
      {param,
      body = const {},
      Map<String, String>? headers,
      noJsonEncode = false}) async {
    headers ??= <String, String>{};

    headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserManager.globalToken}'
    });
    if (noJsonEncode) {
      body = body;
    } else {
      body = json.encoder.convert(body);
    }

    _logRequest(url, 'POST', param, body, headers);
    Uri uri = Uri.parse('$_domain$url').replace(queryParameters: param);
    http.Response response = await http.post(uri, headers: headers, body: body);
    int statusCode = response.statusCode;
    _logResponse(url, statusCode, jsonDecode(utf8.decode(response.bodyBytes)));
    return _handleResponse(statusCode, response);
  }

  Future<dynamic> putMethod(url,
      {param,
      body = const {},
      Map<String, String>? headers,
      noJsonEncode = false}) async {
    headers ??= <String, String>{};

    headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserManager.globalToken}'
    });

    if (noJsonEncode) {
      body = body;
    } else {
      body = json.encoder.convert(body);
    }

    _logRequest(url, 'PUT', param, body, headers);
    Uri uri = Uri.parse('$_domain$url').replace(queryParameters: param);
    http.Response response = await http.put(uri, headers: headers, body: body);
    int statusCode = response.statusCode;
    return _handleResponse(statusCode, response);
  }

  Future<dynamic> deleteMethod(url,
      {param,
      body = const {},
      Map<String, String>? headers,
      noJsonEncode = false}) async {
    headers ??= <String, String>{};

    headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${UserManager.globalToken}'
    });

    if (noJsonEncode) {
      body = body;
    } else {
      body = json.encoder.convert(body);
    }

    _logRequest(url, 'DELETE', param, body, headers);
    Uri uri = Uri.parse('$_domain$url').replace(queryParameters: param);
    http.Response response =
        await http.delete(uri, headers: headers, body: body);
    int statusCode = response.statusCode;
    _logResponse(url, statusCode, jsonDecode(utf8.decode(response.bodyBytes)));
    return _handleResponse(statusCode, response);
  }

  dynamic _handleResponse(int statusCode, http.Response response) {
    if (200 <= statusCode && statusCode <= 299) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    if (statusCode == 401 || statusCode == 403) {
      throw Exception('Token expired');
    }
    if (400 <= statusCode && statusCode <= 499) {
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    } else if (500 <= response.statusCode && response.statusCode <= 599) {
      throw Exception('Server Error');
    }
    throw Exception('Unhandled error');
  }

  void _logRequest(String url, String method, dynamic param, dynamic body,
      Map<String, String> headers) {
    debugPrint(
        '====================================================================================');
    debugPrint('[${method.toUpperCase()}]');
    debugPrint('REQUEST TO API: $_domain$url With: ');
    debugPrint('HEADER: ' + headers.toString() + '\n');
    debugPrint('PARAMS: ' + param.toString() + '\n');
    debugPrint('BODY: ' + body.toString() + '\n');
    debugPrint(
        '====================================================================================');
  }

  void _logResponse(String url, int statusCode, dynamic body) {
    debugPrint(
        '====================================================================================');
    debugPrint('RESPONSE API: $_domain$url With:');
    debugPrint('STATUS CODE: $statusCode');
    debugPrint('BODY: $body ');
    debugPrint(
        '====================================================================================');
  }

  Map<String, dynamic> failedRespond(Exception error) {
    return {
      'success': false,
      'message': error.toString().split('Exception: ')[0]
    };
  }
}
