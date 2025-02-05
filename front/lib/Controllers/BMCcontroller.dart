import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AuthController.dart';

class BMCcontroller {
  final String baseUrl = "http://192.168.1.25:4000/api/v1/businessCanva";

  Future<String?> _getToken() async {
    AuthController authController = AuthController();
    return await authController.getToken();
  }

  Future<Map<String, dynamic>?> addBusinessCanva({
    required String customerSegments,
    required String valuePropositions,
    required String channels,
    required String customerRelationships,
    required String revenueStreams,
    required String keyResources,
    required String keyActivities,
    required String keyPartners,
    required String costStructure,
  }) async {
    final savedToken =await _getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");


    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addBusinessCanva/6790e05564da1d62885f5e00'),
        headers: {'Content-Type': 'application/json',
          'token': tokenWithPrefix,},
        body: json.encode({
          'keyPartners': keyPartners,
          'keyActivities': keyActivities,
          'keyResources': keyResources,
          'valuePropositions': valuePropositions,
          'customerRelationships': customerRelationships,
          'channels': channels,
          'customerSegments': customerSegments,
          'costStructure': costStructure,
          'revenueStreams': revenueStreams,
        }),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData.containsKey('saveIdea')) {
        return {'success': true, 'message': "BMC added successfully!"};
      } else {
        return {'success': false, 'message': responseData['message'] ?? "Failed to add BMC"};
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }
}