import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:t_assignment/model/productData_model.dart';

class ApiOperationService {
  final String baseUrl =
      "https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData";

  static const _timeout = Duration(seconds: 15);
  static const _delayBetweenRequests = Duration(milliseconds: 600);
  static const _maxRetries = 3;

  bool _isOk(int code) => code >= 200 && code < 300;

  /// Runs a request with timeout + retry (handles 429 and network hiccups).
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    Object? lastError;

    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final res = await request().timeout(_timeout);

        if (_isOk(res.statusCode)) return res;

        // Rate limited or server error -> retry after backoff
        if (res.statusCode == 429 || res.statusCode >= 500) {
          lastError = Exception("HTTP ${res.statusCode}: ${res.body}");
        } else {
          // Other 4xx errors won't be fixed by retrying
          throw Exception("HTTP ${res.statusCode}: ${res.body}");
        }
      } on TimeoutException catch (e) {
        lastError = e;
      } on http.ClientException catch (e) {
        lastError = e;
      }

      if (attempt < _maxRetries) {
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }

    throw Exception("Request failed after $_maxRetries attempts: $lastError");
  }

  Future<void> seedDatabase() async {
    try {
      final response = await _send(() => http.get(Uri.parse(baseUrl)));
      final data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty) {
        debugPrint("Database already contains data. Skipping seeding.");
        return;
      }

      debugPrint("Database is empty. Starting product upload...");
      await uploadProduct();
    } catch (e) {
      debugPrint("Error seeding database: $e");
      rethrow;
    }
  }

  Future<List<ProductdataModel>> loadProduct() async {
    try {
      final jsonString = await rootBundle.loadString("assets/products.json");
      final dynamic decodedData = jsonDecode(jsonString);

      if (decodedData is! List) {
        throw Exception("Invalid local JSON format: Expected a List");
      }

      return decodedData
          .map((p) => ProductdataModel.fromJson(Map<String, dynamic>.from(p)))
          .toList();
    } catch (e) {
      debugPrint("Error loading local products: $e");
      rethrow;
    }
  }

  // Sequential upload: avoids rate limiting and partial-burst failures
  Future<void> uploadProduct() async {
    try {
      final products = await loadProduct();

      for (final product in products) {
        await _send(
          () => http.post(
            Uri.parse(baseUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(product.toJson()),
          ),
        );
        await Future.delayed(_delayBetweenRequests);
      }

      debugPrint("All Products Are Uploaded Successfully!");
    } catch (e) {
      debugPrint("Error uploading products: $e");
      rethrow;
    }
  }

  // Sequential delete
  Future<void> deleteAllProducts() async {
    try {
      final response = await _send(() => http.get(Uri.parse(baseUrl)));
      final data = jsonDecode(response.body);

      if (data is! List || data.isEmpty) {
        debugPrint("Database is already empty");
        return;
      }

      for (final product in data) {
        final id = product["id"];
        await _send(() => http.delete(Uri.parse("$baseUrl/$id")));
        await Future.delayed(_delayBetweenRequests);
      }

      debugPrint("All products successfully deleted from database");
    } catch (e) {
      debugPrint("Error during database wipe: $e");
      rethrow;
    }
  }

//it will fetch records
  Future<List<ProductdataModel>> fetchRecords() async {
    final response = await http.get(
      // Uri.parse("https://6a44f2a5aab3faec3f69164c.mockapi.io/api/studentData"),
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final dataList = jsonDecode(response.body);

      return dataList
          .map<ProductdataModel>(
            (jsonObj) => ProductdataModel.fromJson(jsonObj),
          )
          .toList();
    } else {
      throw Exception("Failed to fetch data");
    }
  }

//it will add product
  Future<void> addProduct(ProductdataModel product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      debugPrint("Product added successfully.");
    } else {
      throw Exception("Failed to add product");
    }
  }
}
