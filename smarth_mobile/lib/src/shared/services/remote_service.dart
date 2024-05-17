import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:stmart_home_elte/src/core/api/endpoints.dart';
import 'package:stmart_home_elte/src/core/api/failure_or_ok.dart';

final remoteServiceProvider = Provider<RemoteService>((ref) {
  final client = http.Client();
  return RemoteService(baseUrl: apiBaseUrl, client: client);
});

class RemoteService {
  final String baseUrl;
  final http.Client client;
  static final Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
    'Content-Type': 'application/json',
  };

  RemoteService({required this.baseUrl, required this.client});

  FailureOrOk<T> get<T>(String path, {required T Function(Map<String, dynamic>) transformer}) async {
    final response = await client.get(Uri.parse('$baseUrl$path'), headers: headers);
    if (response.statusCode == 200) {
      return right(transformer(json.decode(response.body)));
    }
    return left(Failure('Failed to load data', response.statusCode));
  }

  FailureOrOk<T?> put<T>(String path, {required Map<String, dynamic> body, T Function(Map<String, dynamic>)? transformer}) async {
    final fullUrl = '$baseUrl$path';
    log("fullUrl, $fullUrl, body, $body");
    final response = await client.put(Uri.parse(fullUrl), headers: headers, body: json.encode(body));
    log("response.statusCode, ${response.statusCode}, response.body, ${response.body}");
    if (response.statusCode == 200) {
      if (transformer != null) {
        return right(transformer(json.decode(response.body)));
      }
      return right(null);
    }
    return left(Failure('Failed to load data', response.statusCode));
  }

  // post
  FailureOrOk<T?> post<T>(String path,
      {required Map<String, dynamic> body, T Function(Map<String, dynamic>)? transformer}) async {
    final response = await client.post(
      Uri.parse('$baseUrl$path'),
      body: json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      if (transformer != null) {
        return right(transformer(json.decode(response.body)));
      }
      return right(null);
    }
    return left(Failure('Failed to load data', response.statusCode));
  }

  FailureOrOk<bool> delete<T>(
    String path,
  ) async {
    final response = await client.delete(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return right(true);
    }
    return left(Failure('Failed to load data', response.statusCode));
  }

  void close() {
    client.close();
  }
}
